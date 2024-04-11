/// A structure representing a point in two-dimensional space.
public struct Vector2<Value: Numeric & Hashable> {
    /// The vector's position on the X axis.
    public var x: Value

    /// The vector's position on the Y axis.
    public var y: Value

    public init(x: Value, y: Value) {
        self.x = x
        self.y = y
    }
}

extension Vector2: Equatable, Hashable {}

public extension Vector2 where Value == Int {
    static let zero = Vector2(x: 0, y: 0)
    static let one = Vector2(x: 1, y: 1)
}

public extension Vector2 where Value == Float {
    static let zero = Vector2(x: 0, y: 0)
    static let one = Vector2(x: 1, y: 1)
}

public extension Vector2 {
    static func +(lhs: Vector2, rhs: Vector2) -> Vector2 {
        Vector2(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func -(lhs: Vector2, rhs: Vector2) -> Vector2 {
        Vector2(x: rhs.x - lhs.x, y: rhs.y - lhs.y)
    }

    /// Calculates the distance between two vectors in space, as if they were connected with a single, straight line.
    /// - Parameter vector: The final point or vector.
    /// - Returns: The distance between the two vectors.
    func distance(to vector: Vector2) -> Value where Value == Float {
        return Self.distance(lhs: self, rhs: vector)
    }

    /// Calculates the distance between two vectors in space, as if they were connected with a single, straight line.
    /// - Parameter vector: The final point or vector.
    /// - Returns: The distance between the two vectors.
    func distance(to vector: Vector2) -> Value where Value == Int {
        return Self.distance(lhs: self, rhs: vector)
    }

    /// Calculates the distance between two vectors in space, as if they were connected with a single, straight line.
    /// - Parameter lhs: The starting point or vector.
    /// - Parameter rhs: The final point or vector.
    /// - Returns: The distance between the two vectors.
    static func distance(lhs: Vector2, rhs: Vector2) -> Value where Value == Float {
        let squaredX = pow(rhs.x - lhs.x, 2)
        let squaredY = pow(rhs.y - lhs.y, 2)
        return sqrt(squaredX + squaredY)
    }

    /// Calculates the distance between two vectors in space, as if they were connected with a single, straight line.
    /// - Parameter lhs: The starting point or vector.
    /// - Parameter rhs: The final point or vector.
    /// - Returns: The distance between the two vectors.
    static func distance(lhs: Vector2, rhs: Vector2) -> Value where Value == Int {
        let x = rhs.x - rhs.y
        let y = rhs.y - lhs.y
        return Int(sqrt(Float(x * x) + Float(y * y)))
    }
}

func sqrt(_ value: Float) -> Float {
    var last: Float = 0
    var current =  value

    while abs(current - last) > 0.5 {
        last = current
        current = 0.5 * (current + value / current)
    }

    return current
}

func pow(_ base: Float, _ power: Int) -> Float {
    var value = base
    for _ in 2...power {
        value *= base
    }
    return value
}