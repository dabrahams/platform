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
import Real

infix operator **  : MultiplicationPrecedence
infix operator .<  : ComparisonPrecedence
infix operator .<= : ComparisonPrecedence
infix operator .>= : ComparisonPrecedence
infix operator .>  : ComparisonPrecedence
infix operator .== : ComparisonPrecedence
infix operator .!= : ComparisonPrecedence


//==============================================================================
// parameter matching helper
@inlinable
public func implicitlyMatchExtents<T>(_ lhs: T, _ rhs: T) -> (T, T)
    where T: TensorView
{
    if lhs.count == rhs.count {
        return (lhs, rhs)
    } else if lhs.count > rhs.count {
        return (lhs, rhs.repeated(to: lhs.extents))
    } else {
        return (lhs.repeated(to: rhs.extents), rhs)
    }
}

//==============================================================================
// DeviceFunctions
public protocol DeviceFunctions {
    //--------------------------------------------------------------------------
    // generic helpers
    /// mapOp 1
    /// generically maps tensor elements
    func mapOp<T, R>(_ x: T, _ result: inout R,
                     _ op: @escaping (T.Element) -> R.Element) where
        T: TensorView, R: TensorView
    /// mapOp 2
    /// generically combines two tensors
    func mapOp<LHS, RHS, R>(
        _ lhs: LHS, _ rhs: RHS, _ result: inout R,
        _ op: @escaping (LHS.Element, RHS.Element) -> R.Element) where
        LHS: TensorView, RHS: TensorView, R: TensorView
    /// mapOp 3
    /// generically combines three tensors
    func mapOp<T1, T2, T3, R>(
        _ a: T1, _ b: T2, _ c: T3, _ result: inout R,
        _ op: @escaping (T1.Element, T2.Element, T3.Element) -> R.Element) where
        T1: TensorView, T2: TensorView, T3: TensorView, R: TensorView
    /// mapOp 3R2
    func mapOp<T1, T2, T3, R>(
        _ a: T1, _ b: T2, _ c: T3, _ result1: inout R,  _ result2: inout R,
        _ op: @escaping (T1.Element, T2.Element, T3.Element) -> (R.Element, R.Element))
        where T1: TensorView, T2: TensorView, T3: TensorView, R: TensorView
    /// inPlaceOp
    /// does in place op on a mutable collection
    func inPlaceOp<T>(_ result: inout T,
                      _ op: @escaping (T.Element) -> T.Element) where
        T: MutableCollection
    /// reductionOp
    /// does a tensor reduction op
    func reductionOp<T, R>(
        _ x: T, _ result: inout R,
        _ op: @escaping (R.Element, T.Element) -> R.Element) where
        T: Collection, R: MutableCollection

    //--------------------------------------------------------------------------
    // ops
    /// Computes the absolute value of the specified TensorView element-wise.
    func abs<T>(x: T, result: inout T) where
        T: TensorView, T.Element: Real
    /// add
    func add<T>(lhs: T, rhs: T, result: inout T) where
        T: TensorView, T.Element: AdditiveArithmetic
    /// cast
    func cast<T, U>(from view: T, to result: inout U) where
        T: TensorView, T.Element: AnyConvertable,
        U: TensorView, U.Element: AnyConvertable
    /// concat
    func concat<T>(tensors: [T], alongAxis axis: Int, result: inout T) where
        T: TensorView
    /// div
    func div<T>(lhs: T, rhs: T, result: inout T) where
        T: TensorView, T.Element: AlgebraicField
    /// elementsAlmostEqual
    func elementsAlmostEqual<T>(lhs: T, rhs: T, tolerance: T.Element,
                                result: inout T.BoolView) where
        T: TensorView, T.Element: SignedNumeric & Comparable
    /// equal
    func equal<T>(lhs: T, rhs: T, result: inout T.BoolView) where T: TensorView
    /// exp
    func exp<T>(x: T, result: inout T) where
        T: TensorView, T.Element: Real
    /// fill(result:with:
    func fill<T>(result: inout T, with value: T.Element) where T: TensorView
    /// fillWithIndex(x:startAt:
    func fillWithIndex<T>(result: inout T, startAt: Int) where
        T: TensorView, T.Element: AnyNumeric
    /// greater
    func greater<T>(lhs: T, rhs: T, result: inout T.BoolView)
        where T: TensorView, T.Element: Comparable
    /// greaterOrEqual
    func greaterOrEqual<T>(lhs: T, rhs: T, result: inout T.BoolView)
        where T: TensorView, T.Element: Comparable
    /// less
    func less<T>(lhs: T, rhs: T, result: inout T.BoolView)
        where T: TensorView, T.Element: Comparable
    /// lessOrEqual
    func lessOrEqual<T>(lhs: T, rhs: T, result: inout T.BoolView)
        where T: TensorView, T.Element: Comparable
    /// log
    func log<T>(x: T, result: inout T) where
        T: TensorView, T.Element: Real
    /// Computes the element-wise maximum of two tensors.
    func max<T>(lhs: T, rhs: T, result: inout T) where
        T: TensorView, T.Element: Comparable
    /// Computes the element-wise minimum of two tensors.
    func min<T>(lhs: T, rhs: T, result: inout T) where
        T: TensorView, T.Element: Comparable
    /// mul
    func mul<T>(lhs: T, rhs: T, result: inout T) where
        T: TensorView, T.Element: Numeric
    /// neg
    /// returns the element-wise negation of `x`
    func neg<T>(x: T, result: inout T) where
        T: TensorView, T.Element: SignedNumeric
    /// notEqual
    func notEqual<T>(lhs: T, rhs: T, result: inout T.BoolView) where
        T: TensorView
    /// pow
    func pow<T>(x: T, y: T, result: inout T) where
        T: TensorView, T.Element: Real
    /// replace
    func replace<T>(x: T, with y: T, where condition: T.BoolView,
                    result: inout T) where T: TensorView
    /// sign
    func sign<T>(x: T, result: inout T) where
        T: TensorView, T.Element: Real
    /// subtract
    func subtract<T>(lhs: T, rhs: T, result: inout T) where
        T: TensorView, T.Element: AdditiveArithmetic
    /// sqrt
    func sqrt<T>(x: T, result: inout T) where
        T: TensorView, T.Element: Real
    /// squared
    func squared<T>(x: T, result: inout T)
        where T: TensorView, T.Element: Numeric
    /// reduce
    /// Reduces `x` along the specified axes
    /// - Parameter x: value tensor
    /// - Parameter result: contains the initial value of the result on entry
    ///  and then final reduction result on return
    /// - Parameter opNext: the operation to perform on pairs of elements
    /// - Parameter opFinal: the operation to perform on the final result
    /// - Precondition: Each value in `axes` must be in the range `-rank..<rank`.
    func reduce<T>(x: T,
                   into result: inout T,
                   opId: ReductionOp,
                   opNext: @escaping (T.Element, T.Element) -> T.Element,
                   opFinal: ReduceOpFinal<T>?)
        where T: TensorView

    //==========================================================================
    // derivative function declarations
    
    /// vjpMinMax
    func vjpMinMax<T>(
        x: T, y: T, scale: T, op: @escaping (T.Element, T.Element) -> Bool,
        resultTrue: inout T, resultFalse: inout T)
        where T: TensorView, T.Element: Comparable & Numeric
}

//==============================================================================
// DeviceQueue default implementations
public extension DeviceFunctions where Self: DeviceQueue {
    // mapOp 1
    /// generically maps a tensor
    @inlinable
    func mapOp<T, R>(_ x: T, _ result: inout R,
                     _ op: @escaping (T.Element) -> R.Element) where
        T: TensorView, R: TensorView
    {
        x.map(into: &result, op)
    }
    // mapOp 2
    /// generically combines two tensors
    @inlinable
    func mapOp<LHS, RHS, R>(
        _ lhs: LHS, _ rhs: RHS, _ result: inout R,
        _ op: @escaping (LHS.Element, RHS.Element) -> R.Element) where
        LHS: TensorView, RHS: TensorView, R: TensorView
    {
        zip(lhs, rhs).map(into: &result, op)
    }
    // mapOp 3
    /// generically combines three tensors
    @inlinable
    func mapOp<T1, T2, T3, R>(
        _ a: T1, _ b: T2, _ c: T3, _ result: inout R,
        _ op: @escaping (T1.Element, T2.Element, T3.Element) -> R.Element) where
        T1: TensorView, T2: TensorView, T3: TensorView, R: TensorView
    {
        zip(a, b, c).map(into: &result, op)
    }
    // mapOp 3R2
    /// generically combines three tensors
    @inlinable
    func mapOp<T1, T2, T3, R>(
        _ a: T1, _ b: T2, _ c: T3, _ result1: inout R,  _ result2: inout R,
        _ op: @escaping (T1.Element, T2.Element, T3.Element) -> (R.Element, R.Element))
        where T1: TensorView, T2: TensorView, T3: TensorView, R: TensorView
    {
        var r1 = result1.mutableElements()
        var r2 = result2.mutableElements()
        
        for ((av, bv, cv), (i1, i2)) in
            zip(zip(a, b, c), zip(r1.indices, r2.indices))
        {
            let (rv1, rv2) = op(av, bv, cv)
            r1[i1] = rv1
            r2[i2] = rv2
        }
    }
    // inPlaceOp
    @inlinable
    func inPlaceOp<T>(_ result: inout T,
                      _ op: @escaping (T.Element) -> T.Element) where
        T: MutableCollection
    {
        result.indices.forEach { result[$0] = op(result[$0]) }
    }
    // reductionOp
    @inlinable
    func reductionOp<T, R>(
        _ x: T, _ result: inout R,
        _ op: @escaping (R.Element, T.Element) -> R.Element) where
        T: Collection, R: MutableCollection
    {
        zip(result.indices, x).forEach { result[$0] = op(result[$0], $1) }
    }
    
    //==========================================================================
    /// abs
    @inlinable
    func abs<T>(x: T, result: inout T) where
        T: TensorView, T.Element: Real
    {
        mapOp(x, &result) { Swift.abs($0) }
    }
    // add
    @inlinable
    func add<T>(lhs: T, rhs: T, result: inout T) where
        T: TensorView, T.Element: AdditiveArithmetic
    {
        mapOp(lhs, rhs, &result, +)
    }
    /// cast
    @inlinable
    func cast<T, U>(from view: T, to result: inout U) where
        T: TensorView, T.Element: AnyConvertable,
        U: TensorView, U.Element: AnyConvertable
    {
        mapOp(view, &result) { U.Element(any: $0) }
    }
    // concat
    // TODO: if the tensors are large they could
    // be copied in parallel. Maybe leave for the compiler in the future
    @inlinable
    func concat<T>(tensors: [T], alongAxis axis: Int, result: inout T) where
        T: TensorView
    {
        var index = T.Shape.zeros
        
        for tensor in tensors {
            var view = result.mutableView(at: index, extents: tensor.extents)
            tensor.map(into: &view) { $0 }
            index[axis] += tensor.extents[axis]
        }
    }
    /// div
    @inlinable
    func div<T>(lhs: T, rhs: T, result: inout T) where
        T: TensorView, T.Element: AlgebraicField
    {
        mapOp(lhs, rhs, &result, /)
    }
    /// elementsAlmostEqual
    @inlinable
    func elementsAlmostEqual<T>(lhs: T, rhs: T, tolerance: T.Element,
                                result: inout T.BoolView) where
        T: TensorView, T.Element: SignedNumeric & Comparable
    {
        mapOp(lhs, rhs, &result) { Swift.abs($0 - $1) <= tolerance }
    }
    /// equal
    @inlinable
    func equal<T>(lhs: T, rhs: T, result: inout T.BoolView) where
        T: TensorView
    {
        mapOp(lhs, rhs, &result, ==)
    }
    /// exp
    @inlinable
    func exp<T>(x: T, result: inout T) where
        T: TensorView, T.Element: Real
    {
        mapOp(x, &result) { .exp($0) }
    }
    /// fill(result:with:
    @inlinable
    func fill<T>(result: inout T, with value: T.Element) where T: TensorView
    {
        var elements = result.mutableElements()
        elements.indices.forEach { elements[$0] = value }
    }
    /// fillWithIndex(x:startAt:
    @inlinable
    func fillWithIndex<T>(result: inout T, startAt: Int) where
        T: TensorView, T.Element: AnyNumeric
    {
        var elements = result.mutableElements()
        zip(elements.indices, startAt..<(startAt + elements.count)).forEach {
            elements[$0] = T.Element(any: $1)
        }
    }
    /// less
    @inlinable
    func less<T>(lhs: T, rhs: T, result: inout T.BoolView)
        where T: TensorView, T.Element: Comparable
    {
        mapOp(lhs, rhs, &result, <)
    }
    /// lessOrEqual
    @inlinable
    func lessOrEqual<T>(lhs: T, rhs: T, result: inout T.BoolView)
        where T: TensorView, T.Element: Comparable
    {
        mapOp(lhs, rhs, &result, <=)
    }
    /// greater
    @inlinable
    func greater<T>(lhs: T, rhs: T, result: inout T.BoolView)
        where T: TensorView, T.Element: Comparable
    {
        mapOp(lhs, rhs, &result, >)
    }
    /// greaterOrEqual
    @inlinable
    func greaterOrEqual<T>(lhs: T, rhs: T, result: inout T.BoolView)
        where T: TensorView, T.Element: Comparable
    {
        mapOp(lhs, rhs, &result, >=)
    }
    /// log
    @inlinable
    func log<T>(x: T, result: inout T) where
        T: TensorView, T.Element: Real
    {
        mapOp(x, &result) { .log($0) }
    }
    /// Computes the element-wise maximum of two tensors.
    @inlinable
    func max<T>(lhs: T, rhs: T, result: inout T) where
        T: TensorView, T.Element: Comparable
    {
        mapOp(lhs, rhs, &result) { $0 >= $1 ? $0 : $1 }
    }
    /// Computes the element-wise minimum of two tensors.
    @inlinable
    func min<T>(lhs: T, rhs: T, result: inout T) where
        T: TensorView, T.Element: Comparable
    {
        mapOp(lhs, rhs, &result) { $0 <= $1 ? $0 : $1 }
    }
    /// mul
    @inlinable
    func mul<T>(lhs: T, rhs: T, result: inout T) where
        T: TensorView, T.Element: Numeric
    {
        mapOp(lhs, rhs, &result, *)
    }
    /// neg
    @inlinable
    func neg<T>(x: T, result: inout T) where
        T: TensorView, T.Element: SignedNumeric
    {
        mapOp(x, &result, -)
    }
    /// notEqual
    @inlinable
    func notEqual<T>(lhs: T, rhs: T, result: inout T.BoolView)
        where T: TensorView
    {
        mapOp(lhs, rhs, &result, !=)
    }
    /// pow
    @inlinable
    func pow<T>(x: T, y: T, result: inout T) where
        T: TensorView, T.Element: Real
    {
        mapOp(x, y, &result) { .pow($0, $1) }
    }
    /// replace
    @inlinable
    func replace<T>(x: T, with y: T, where condition: T.BoolView,
                    result: inout T)
        where T: TensorView
    {
        mapOp(condition, y, x, &result) { $0 ? $1 : $2 }
    }
    /// sign
    @inlinable
    func sign<T>(x: T, result: inout T) where
        T: TensorView, T.Element: Real
    {
        mapOp(x, &result) { $0 < 0 ? -1 : 1 }
    }
    /// subtract
    @inlinable
    func subtract<T>(lhs: T, rhs: T, result: inout T) where
        T: TensorView, T.Element: AdditiveArithmetic
    {
        mapOp(lhs, rhs, &result, -)
    }
    /// sqrt
    @inlinable
    func sqrt<T>(x: T, result: inout T) where
        T: TensorView, T.Element: Real
    {
        mapOp(x, &result) { .sqrt($0) }
    }
    /// squared
    @inlinable
    func squared<T>(x: T, result: inout T)
        where T: TensorView, T.Element: Numeric
    {
        mapOp(x, &result) { $0 * $0 }
    }
    /// reduce
    /// Reduces `x` along the specified axes
    /// - Parameter x: value tensor
    /// - Parameter result: contains the initial value of the result on entry
    ///  and then final reduction result on return
    /// - Parameter opNext: the operation to perform on pairs of elements
    /// - Parameter opFinal: the operation to perform on the final result
    /// - Precondition: Each value in `axes` must be in the range `-rank..<rank`.
    @inlinable
    func reduce<T>(x: T,
                   into result: inout T,
                   opId: ReductionOp,
                   opNext: @escaping (T.Element, T.Element) -> T.Element,
                   opFinal: ReduceOpFinal<T>?)
        where T: TensorView
    {
        assert(result.isContiguous, "Result storage must be contiguous")
        
        // created a repeated view of the initial results to match `x`
        var repeated = T(shape: result.shape.repeated(to: x.extents),
                         tensorArray: result.tensorArray,
                         viewOffset: result.viewOffset,
                         isMutable: true)
        
        // get the elements collection and do the reduction
        var repeatedElements = repeated.mutableElements(using: self)
        reductionOp(x.elements, &repeatedElements, opNext)

        if let op = opFinal {
            var elements = result.mutableElements(using: self)
            inPlaceOp(&elements, op)
        }
    }
}

//==============================================================================
// DeviceQueue default derivative implementations
public extension DeviceFunctions where Self: DeviceQueue {
    /// vjpMinMax
    @inlinable
    func vjpMinMax<T>(
        x: T, y: T, scale: T, op: @escaping (T.Element, T.Element) -> Bool,
        resultTrue: inout T, resultFalse: inout T)
        where T: TensorView, T.Element: Comparable & Numeric
    {
        mapOp(x, y, scale, &resultTrue, &resultFalse) {
            op($0, $1) ? ($2, T.Element.zero) : (T.Element.zero, $2)
        }
    }
}
