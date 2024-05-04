import PlaydateKit

/// A basic protocol for running games.
protocol GameRunner {
    /// Draws pixels to the screen as necessary.
    /// - Returns: Whether the screen should be updated.
    func draw() -> Bool

    /// Process game inputs and perform state manipulations.
    /// - Important: This should be called *before* the draw process.
    func process()
}

extension GameRunner {
    /// Runs a full game iteration on the current frame.
    func runIteration() -> Bool {
        process()
        return draw()
    }
}