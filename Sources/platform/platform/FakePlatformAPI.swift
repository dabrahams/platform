//------------------------------------------------------------------------------
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

//------------------------------------------------------------------------------
public protocol DeviceFunctions {
    func add<T>(_ lhs: T, _ rhs: T) -> T
        where T: TensorView & AdditiveArithmetic
    
    func addMore<T>(_ lhs: T, _ rhs: T) -> T
        where T: TensorView & BinaryInteger
    
    func sub<T>(_ lhs: T, _ rhs: T) -> T
        where T: TensorView & AdditiveArithmetic
}

extension DeviceFunctions {
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
