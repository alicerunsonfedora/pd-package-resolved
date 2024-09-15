/// A container for the movement APIs.
public enum Movement {
    /// Translates a movement vector according to the crank's position angle.
    /// - Parameter position: The original movement vector to translate.
    /// - Parameter rotation: The current angle the crank is at, if the crank is engaged.
    /// - Parameter bounds: The bounds of the screen by which the position cannot translate past.
    /// - Returns: A translated vector accounting for the crank's angle.
    public static func translate(from position: Vector2<Float>,
                                 withCrankRotation rotation: Float,
                                 bounds: Vector2<Float>) -> Vector2<Float> {
        // Use the delta change to determine which direction to go.
        let xPosition: Float = rotation >= 0 ? position.x + 4 : position.x - 4
        return Vector2<Float>(
            x: xPosition.clamp(lower: 16, upper: bounds.x - 16),
            y: position.y.clamp(lower: 0, upper: bounds.y))
    }
}
