import Foundation

//let p0 = Platform<CpuService>()
//let p1 = Platform<AsyncCpuService>()
//let p2 = Platform<CudaService>()
//let p3 = Platform<Sharding<AsyncCpuService>>()

var platform = Platform<CpuService>()
let start = Date()

var count = 0
for i in 0..<100000 {
    count += platform.service.cpu.queues[0].add(i, i)
}
let elapsed = Date().timeIntervalSince(start)

assert(count > 0)
print(String(describing: elapsed))
print("end")
