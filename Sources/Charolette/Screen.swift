import Foundation

public struct EdgeInsets: Equatable {
    public static let zero = EdgeInsets(all: 0)

    public var top: Float
    public var left: Float
    public var right: Float
    public var bottom: Float

    public init(top: Float, left: Float, right: Float, bottom: Float) {
        self.top = top
        self.left = left
        self.right = right
        self.bottom = bottom
    }

    public init(vertical: Float, horizontal: Float) {
        self.top = vertical
        self.left = horizontal
        self.right = horizontal
        self.bottom = vertical
    }

    public init(all: Float) {
        self.top = all
        self.left = all
        self.right = all
        self.bottom = all
    }
}

public struct ScreenData {
    public var bounds: Vector2<Float>
    public var edgeInsets: EdgeInsets

    public init(bounds: Vector2<Float>, insets: EdgeInsets = .zero) {
        self.bounds = bounds
        self.edgeInsets = insets
    }

    public func fencingIn(point: Vector2<Float>) -> Vector2<Float> {
        var newPosition = point
        newPosition.x = newPosition.x.clamp(lower: edgeInsets.left, upper: bounds.x - edgeInsets.right)
        newPosition.y = newPosition.y.clamp(lower: edgeInsets.top, upper: bounds.y - edgeInsets.bottom)
        return newPosition
    }
}