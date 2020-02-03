//******************************************************************************
// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import Foundation

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
import Darwin
#else
import Glibc
#endif

//==============================================================================
/// Executes a closure on the specified queue
/// - Parameter cpuQueue: the cpu queue to use
/// - Parameter body: A closure whose operations are to be executed on the
///             specified device queue
@inlinable
public func using<R>(cpuQueue id: Int, _ body: () -> R) -> R {
    let context = DeviceContext.local
    context.push(context.platform.cpu(queue: id))
    defer { context.popQueue() }
    return body()
}

//==============================================================================
/// Executes a closure on the specified accelerator queue
/// - Parameter device: the accelerator device index
/// - Parameter queue: the accelerator device queue index
/// - Parameter body: A closure whose operations are to be executed on the
///             specified device queue
@inlinable
public func using<R>(accelerator id: Int, queue: Int, _ body: () -> R) -> R {
    let context = DeviceContext.local
    context.push(context.platform.accelerator(device: id, queue: queue))
    defer { context.popQueue() }
    return body()
}

//==============================================================================
/// Context
/// Manages global resources scoped to the current thread
public class DeviceContext {
    /// the platform associated with this context
    public var platform: PlatformDevices
    /// stack of device queues used to execute
    public var queueStack: [DeviceQueue]
    
    //--------------------------------------------------------------------------
    // initializers
    @inlinable
    public init() {
        // set the default service to synchronous cpu queue:0
        platform = Platform<CpuService>()
        queueStack = [platform.cpu(queue: 0)]
    }
    
    //--------------------------------------------------------------------------
    /// push(devices:
    /// pushes the specified device queue onto a stack which makes
    /// it the current queue used by operator functions
    @inlinable
    func push(_ queue: DeviceQueue) {
        queueStack.append(queue)
    }
    
    //--------------------------------------------------------------------------
    /// popDevices
    /// restores the previous device queue as the current queue
    @inlinable
    func popQueue() {
        assert(queueStack.count > 1)
        _ = queueStack.popLast()
    }

    //--------------------------------------------------------------------------
    /// queue
    @inlinable
    public static var queue: DeviceQueue {
        DeviceContext.local.queueStack.last!
    }
    
    //--------------------------------------------------------------------------
    /// hostQueue
    @inlinable
    public static var hostQueue: DeviceQueue {
        fatalError()
//        let current = DeviceContext.queue
//        return current.memory.addressing == .unified ?
//            current.queues[0] : Platform.cpu.queues[0]
    }
    
    //--------------------------------------------------------------------------
    /// returns the thread local instance of the queues stack
    @inlinable
    public static var local: DeviceContext {
        // try to get an existing state
        if let state = pthread_getspecific(key) {
            return Unmanaged.fromOpaque(state).takeUnretainedValue()
        } else {
            // create and return new state
            let state = DeviceContext()
            pthread_setspecific(key, Unmanaged.passRetained(state).toOpaque())
            return state
        }
    }

    //--------------------------------------------------------------------------
    /// thread data key
    @usableFromInline
    static let key: pthread_key_t = {
        var key = pthread_key_t()
        pthread_key_create(&key) {
            #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
            let _: AnyObject = Unmanaged.fromOpaque($0).takeRetainedValue()
            #else
            let _: AnyObject = Unmanaged.fromOpaque($0!).takeRetainedValue()
            #endif
        }
        return key
    }()
    

}
