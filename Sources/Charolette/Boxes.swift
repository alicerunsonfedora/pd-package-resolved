/// A container for the box APIs.
public enum Boxes {
    /// A representation of a box.
    public typealias Box = Vector2<Float>

    /// Fills an array of boxes with random positions.
    /// - Parameter boxes: The array of boxes to fill.
    /// - Parameter screen: Information about the current Playdate screen, such as the dimensions and edge insets.
    public static func fill(boxes: inout [Box], screen: ScreenData) {
        let step = screen.bounds.y / Float(boxes.count)
        let leftBoundary = screen.edgeInsets.left
        let rightBoundary = screen.bounds.x - screen.edgeInsets.right
        for index in 0..<boxes.count {
            let xRandSeed = Float(randomInteger()).truncatingRemainder(dividingBy: screen.bounds.x)
            let xPos = xRandSeed.clamp(lower: leftBoundary, upper: rightBoundary)
            let yPos = step * Float(index)
            boxes[index] = Vector2<Float>(x: xPos, y: yPos)
        }
    }

    /// Shifts a box towards the top of the screen, resetting its position if it reaches a threshold value past the screen's top edge.
    /// - Parameter box: The position of the box to shift.
    /// - Parameter threshold: The threshold value for which the box must surpass to be repositioned.
    /// - Parameter index: The index of the box in its array.
    /// - Parameter screen: Information about the current Playdate screen, such as the dimensions and edge insets.
    /// - Parameter totalBoxes: The number of boxes that live in the array of this box.
    /// - Returns: The new position of the box.
    public static func shift(box: Box, threshold: Float, index: Int, screen: ScreenData, totalBoxes: Int) -> Box {
        var transformed = box
        let step = screen.bounds.y / Float(totalBoxes)
        transformed.y -= 1
        if (transformed.y >= threshold) { return transformed }

        let leftBoundary = screen.edgeInsets.left
        let rightBoundary = screen.bounds.x - screen.edgeInsets.right

        let xRandSeed = Float(randomInteger()).truncatingRemainder(dividingBy: screen.bounds.x)
        transformed.x = xRandSeed.clamp(lower: leftBoundary, upper: rightBoundary)
        transformed.y = Float(index) * step + abs(threshold)
        return transformed
    }
}

nonisolated(unsafe) var randomSeed: Int = 5

public func randomInteger() -> Int {
    randomSeed = (75 * randomSeed + 74) % 65537
    return randomSeed
}