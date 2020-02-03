import Foundation
import Dispatch

let runs = 10
let iterations = 1000000
var count = 0
var elapsed: [Double] = []

// device is accessed via protocol in generic platform composition
do {
    let globalPlatform = Platform<CpuService>()
    let absPlatform: PlatformDevices = globalPlatform

    // 0.000280
    let queue: DeviceQueue = absPlatform.cpu(queue: 0)

    // 0.000280
//    let queue: DeviceQueue = globalPlatform.cpu(queue: 0)
//    let queue: DeviceQueue = globalPlatform.service.cpu.queues[0]
    
    // simulated api
    func add<T>(_ lhs: T, _ rhs: T) -> T
        where T: TensorView & AdditiveArithmetic
    {
        queue.add(lhs, rhs)
    }
    
    // gather average runs of 1 million iterations
    elapsed = []
    count = 0
    for _ in 0..<runs {
        let start = Date()
        for i in 0..<iterations {
            count += add(i, i)
            //            count += queue.add(i, i)
            //            count += platform.service.cpu.queues[0].add(i, i)
        }
        elapsed.append(Date().timeIntervalSince(start))
    }
    print("count: \(count)")
    print("protocol based time: \(String(describing: elapsed.reduce(0.0,+) / Double(runs))))")
}

// device is accessed via class object in generic platform composition
//do {
//    let globalPlatform = Platform<CpuService>()
//    let queue = globalPlatform.service.cpu.queues[0]
//
//    // simulated api
//    func add<T>(_ lhs: T, _ rhs: T) -> T
//        where T: TensorView & AdditiveArithmetic
//    {
//        queue.add(lhs, rhs)
//    }
//
//    // gather average runs of 1 million iterations
//    elapsed = []
//    count = 0
//    for _ in 0..<runs {
//        let start = Date()
//        for i in 0..<iterations {
//            count += add(i, i)
////            count += queue.add(i, i)
////            count += platform.service.cpu.queues[0].add(i, i)
//        }
//        elapsed.append(Date().timeIntervalSince(start))
//    }
//    print("count: \(count)")
//    print("class based time: \(String(describing: elapsed.reduce(0.0,+) / Double(runs))))")
//}


//let semaphore = DispatchSemaphore(value: 0)
//DispatchQueue.global().async {
//    let result = add(2, 3)
//    print("async result: \(result)")
//    semaphore.signal()
//}
//semaphore.wait()


print("end")

