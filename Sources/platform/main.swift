import Foundation
import Dispatch

// platform composition examples
//let p0 = Platform<CpuService>()
//let p1 = Platform<AsyncCpuService>()
//let p2 = Platform<CudaService>()
//let p3 = Platform<Sharding<CudaService>>()

//------------------------------------------------------------------------------
// choose the desired platform type
typealias ApplicationPlatform = Platform<CpuService>

// create a platform instance
let platform = ApplicationPlatform()

// run a user defined function
platform.runModel()

// extend the application platform with our model
extension ApplicationPlatform
{
    func runModel() {
        // test parameters
        let runs = 10
        let iterations = 1000000 // 1 million
        var count = CommandLine.arguments.count
        var elapsed: [Double] = []
        
        // gather average runs
        for _ in 0..<runs {
            let start = Date()
            for i in 0..<iterations {
                count += add(i, i)
//                count += addMore(i, i)
            }
            elapsed.append(Date().timeIntervalSince(start))
        }
        print("protocol based time: " +
            "\(String(describing: elapsed.reduce(0.0,+) / Double(runs))))")
        
        // use count so it isn't optimized out
        print("count: \(count)")
    }
}

//------------------------------------------------------------------------------
// simulated api
extension ComputePlatform {
    func add<T>(_ lhs: T, _ rhs: T) -> T
        where T: TensorView & AdditiveArithmetic
    {
        service.cpu.queues[0].add(lhs, rhs)
    }
    
    func addMore<T>(_ lhs: T, _ rhs: T) -> T
        where T: TensorView & BinaryInteger
    {
        service.cpu.queues[0].addMore(lhs, rhs)
    }
}
