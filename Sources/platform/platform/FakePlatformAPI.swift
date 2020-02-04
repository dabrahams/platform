//------------------------------------------------------------------------------
extension ComputePlatform {
    func add<T>(_ lhs: T, _ rhs: T) -> T
        where T: TensorView & AdditiveArithmetic
    {
        // DaveA
        // Option 1
        // this is fast: 1X perf
        return service.cpu.queues[0].add(lhs, rhs)

        // Option 2
        // want this to look like: perf ~100X
        // return service.queues[0].add(lhs, rhs)
        
        // Option 3
        // ugly but ... perf: ~1.9X
//        if service.useCpu {
//            return service.cpu.queues[0].add(lhs, rhs)
//        } else {
//            return service.accelerators[0].queues[0].add(lhs, rhs)
//        }
    }
    
    func addMore<T>(_ lhs: T, _ rhs: T) -> T
        where T: TensorView & BinaryInteger
    {
        service.cpu.queues[0].addMore(lhs, rhs)
    }
}

//------------------------------------------------------------------------------
extension DeviceQueue {
    public func add<T>(_ lhs: T, _ rhs: T) -> T
        where T: TensorView & AdditiveArithmetic
    {
        lhs + rhs
    }
    
    public func addMore<T>(_ lhs: T, _ rhs: T) -> T
        where T: TensorView & BinaryInteger
    {
        let vl = [T](repeating: lhs, count: 10)
        let vr = [T](repeating: rhs, count: 10)
        return (zip(vl, vr).map { $0 + $1 }).reduce(0,+) / 10
    }
    
    public func sub<T>(_ lhs: T, _ rhs: T) -> T
        where T: TensorView & AdditiveArithmetic {
            print("default user sub from DeviceFunctions")
            return lhs - rhs
    }
}
