//------------------------------------------------------------------------------
extension ComputePlatform {
    func add<T>(_ lhs: T, _ rhs: T) -> T
        where T: TensorView & BinaryInteger
    {
        var result = T.zero
        // DaveA
        // Option 1
        // this is fast: 1X perf
        service.cpu.queues[0].add(lhs, rhs, &result)

        // Option 2
        // want this to look like: perf ~100X
        // service.queues[0].add(lhs, rhs, &result)
        
        // Option 3
        // not pretty but ...
        // pure overhead perf: ~1.9X
        // with workload perf: ~1.0X  no loss of performance
//        if service.useCpu {
//            service.cpu.queues[0].add(lhs, rhs, &result)
//        } else {
//            service.accelerators[0].queues[0].add(lhs, rhs, &result)
//        }

        return result
    }
    
    func addMore<T>(_ lhs: T, _ rhs: T) -> T
        where T: TensorView & BinaryInteger
    {
        var result = T.zero
        service.cpu.queues[0].addMore(lhs, rhs, &result)
        return result
    }
}

//------------------------------------------------------------------------------
extension DeviceQueue {
    public func add<T>(_ lhs: T, _ rhs: T, _ result: inout T)
        where T: TensorView & BinaryInteger
    {
        result = lhs + rhs
    }
    
    public func addMore<T>(_ lhs: T, _ rhs: T, _ result: inout T)
        where T: TensorView & BinaryInteger
    {
        let vl = [T](repeating: lhs, count: 10)
        let vr = [T](repeating: rhs, count: 10)
        result = (zip(vl, vr).map { $0 + $1 }).reduce(0,+) / 10
    }
}
