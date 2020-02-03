import Foundation
import Dispatch

// composition examples
let p0 = Platform<CpuService>()
let p1 = Platform<AsyncCpuService>()
let p2 = Platform<CudaService>()
let p3 = Platform<Sharding<CudaService>>()

//------------------------------------------------------------------------------
// simulated api
func add<T>(_ lhs: T, _ rhs: T) -> T
    where T: TensorView & AdditiveArithmetic
{
    queue.add(lhs, rhs)
}

func addMore<T>(_ lhs: T, _ rhs: T) -> T
    where T: TensorView & BinaryInteger
{
    queue.addMore(lhs, rhs)
}

//------------------------------------------------------------------------------
// test parameters
let runs = 10
let iterations = 1000000 // 1 million
var count = 0
var elapsed: [Double] = []

// device is accessed via protocol in generic platform composition
let globalPlatform = Platform<CpuService>()

// add -> 0.000280  addMore -> 0.651
let viaProtocol: PlatformDevices = globalPlatform

// add -> 0.000280  addMore -> 0.651
//let queue = globalPlatform.service.cpu.queues[0]

// add -> 0.0250    100X slower!!
//DeviceContext.current.platform = globalPlatform
//let viaProtocol: PlatformDevices = DeviceContext.current.platform

let queue: DeviceQueue = viaProtocol.cpu(queue: 0)

// gather average runs
elapsed = []
count = 0
for _ in 0..<runs {
    let start = Date()
    for i in 0..<iterations {
        count += add(i, i)
//        count += addMore(i, i)
        //            count += queue.add(i, i)
        //            count += globalPlatform.service.cpu.queues[0].add(i, i)
    }
    elapsed.append(Date().timeIntervalSince(start))
}
print("count: \(count)")
print("protocol based time: \(String(describing: elapsed.reduce(0.0,+) / Double(runs))))")

