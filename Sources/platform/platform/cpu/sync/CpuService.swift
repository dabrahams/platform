//******************************************************************************
// Copyright 2020 Google LLC
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

public protocol TensorView {
    var value: Int { get }
//    init(_ v: Int)
}

extension Int: TensorView {
    public var value: Int { return self }
//    public init(_ v: Int) { self = v }
}

//==============================================================================
/// CudaService
/// The collection of compute resources available to the application
/// on the machine where the process is being run.

//==============================================================================
/// CpuService
/// The collection of compute resources available to the application
/// on the machine where the process is being run.
public struct CpuService: ComputeService {
    // properties
    public var accelerators: [CpuDevice]
    public var cpu: CpuDevice
    public var id: Int
    public let logInfo: LogInfo
    public var name: String
    
    //--------------------------------------------------------------------------
    public init(parent logInfo: LogInfo, id: Int) {
        self.name = "CpuService"
        self.logInfo = logInfo.child(name)
        self.cpu = CpuDevice(parent: self.logInfo, id: 0)
        self.id = id
        self.accelerators = []
    }
}

//==============================================================================
/// CpuDevice
public struct CpuDevice: ComputeDevice {
    // properties
    public var id: Int
    public let logInfo: LogInfo
    public var name: String
    public var queues: [CpuQueue]
    
    public init(parent logInfo: LogInfo, id: Int) {
        self.id = id
        self.name = "cpu:\(id)"
        self.logInfo = logInfo.child(name)
        self.queues = []
        queues.append(CpuQueue(parent: self.logInfo, deviceName: name, id: 0))
    }
}

//==============================================================================
/// CpuQueue
public struct CpuQueue: DeviceQueue
{
    public let id: Int
    public let logInfo: LogInfo
    public let deviceName: String
    public let name: String

    /// used to detect accidental queue access by other threads
    @usableFromInline
    let creatorThread: Thread

    //--------------------------------------------------------------------------
    // initializers
    @inlinable
    public init(parent logInfo: LogInfo, deviceName: String, id: Int)
    {
        self.id = id
        self.name = "q:\(id)"
        self.logInfo = logInfo.child(name)
        self.deviceName = deviceName
        self.creatorThread = Thread.current

        diagnostic("\(createString) DeviceQueue " +
            "\(deviceName)_\(name)", categories: .queueAlloc)
    }

    public func add<T>(_ lhs: T, _ rhs: T) -> T
        where T: TensorView & AdditiveArithmetic
    {
        lhs + rhs
    }
    
    public func createEvent(options: QueueEventOptions) -> QueueEvent {
        CpuQueueEvent()
    }
    
    public func record(event: QueueEvent) -> QueueEvent {
        CpuQueueEvent()
    }
    
    public func wait(for event: QueueEvent) {
        fatalError()
    }
    
    public func waitUntilQueueIsComplete() {
        fatalError()
    }
}

//==============================================================================
/// CpuQueueEvent
public struct CpuQueueEvent: QueueEvent {
    // properties
    public var occurred: Bool
    public var recordedTime: Date?

    //--------------------------------------------------------------------------
    public init() {
        // the queue is synchronous so the event has already occurred
        self.occurred = true
    }
    
    @inlinable
    public func wait() throws {
    }
}
