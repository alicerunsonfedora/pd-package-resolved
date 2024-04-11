/// A structure representing insets of a rectangle.
/// 
/// Typically, insets are used to provide padding for a rectangle or bounds by which
/// certain elements or vectors cannot reside in.
public struct EdgeInsets: Equatable {
    /// A constant for no insets.
    public static var zero: EdgeInsets { EdgeInsets(all: 0) }

    /// The number of pixels or units away from the rectangle's top edge.
    public var top: Float

    /// The number of pixels or units away from the rectangle's left edge.
    public var left: Float

    /// The number of pixels or units away from the rectangle's right edge.
    public var right: Float

    /// The number of pixels or units away from the rectangle's bottom edge.
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

/// A structure representing information about the screen.
public struct ScreenData {
    /// The width and height of the screen, represented as a vector.
    public var bounds: Vector2<Float>

    /// The insets set from the edges of the screen's rectangle for suitable drawing.
    public var edgeInsets: EdgeInsets

    public init(bounds: Vector2<Float>, insets: EdgeInsets = .zero) {
        self.bounds = bounds
        self.edgeInsets = insets
    }

    /// Shifts a point in space to fit within the screen's safe area.
    /// - Parameter point: The position to shift into the safe area.
    /// - Returns: A translated vector that is within the safe areas of the screen.
    public func fencingIn(point: Vector2<Float>) -> Vector2<Float> {
        var newPosition = point
        newPosition.x = newPosition.x.clamp(lower: edgeInsets.left, upper: bounds.x - edgeInsets.right)
        newPosition.y = newPosition.y.clamp(lower: edgeInsets.top, upper: bounds.y - edgeInsets.bottom)
        return newPosition
    }
}