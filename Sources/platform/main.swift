import Foundation

//let p0 = Platform<CpuService>()
//let p1 = Platform<AsyncCpuService>()
//let p2 = Platform<CudaService>()
//let p3 = Platform<Sharding<AsyncCpuService>>()

let runs = 10
var elapsed: [Double] = []

var platform = Platform<CpuService>()


for _ in 0..<runs {
    let start = Date()
    var count = 0
    for i in 0..<100000 {
        count += platform.service.cpu.queues[0].add(i, i)
    }
    elapsed.append(Date().timeIntervalSince(start))
    assert(count > 0)
}

print(String(describing: elapsed.reduce(0.0,+) / Double(runs)))
print("end")
