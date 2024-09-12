import PlaydateKit

/// A basic protocol for running games and systems.
protocol GameSystem {
    /// Draws pixels to the screen as necessary.
    /// - Returns: Whether the screen should be updated.
    func draw() -> Bool

    /// Draws pixels to the screen as necessary, with the highest priority.
    /// - Returns: Whether the screen should be updated to reflect the UI.
    func drawUI() -> Bool

    /// Process game inputs and perform state manipulations.
    /// - Important: This should be called *before* the draw process.
    func process()
}

extension GameSystem {
    /// Runs a full game iteration on the current frame, typically separately from any managed
    /// systems.
    ///
    /// When executed by itself, the Playdate Sprite APIs are called to update and draw the screen,
    /// unless the draw call returns a value to not update the screen.
    /// - Returns: Whether to update the Playdate's screen.
    func runUnmanagedIteration() -> Bool {
        process()
        let drawCall = draw()
        if !drawCall { return false }
        Playdate.Sprite.updateAndDrawDisplayListSprites()
        return true
    }
}

/// A class type that represents a subsystem to be managed by another system.
/// - Important: ``Subsystem/process`` and ``Subsystem/draw`` must be overridden!
class Subsystem: GameSystem {
    /// Whether the current subsystem requires draw calls to be managed from Playdate's sprite
    /// system. Defaults to false.
    /// - Important: This variable must be overridden in subsystems that require this feature.
    var requiresManagedDrawCallsFromSprite: Bool { false }

    func process() {}
    func draw() -> Bool { true }
    func drawUI() -> Bool { true }
}

/// A protocol that manages a series of subsystems.
protocol SubsystemManaged {
    /// The subsystems that are currently managed by this type.
    var subsystems: [Subsystem] { get set }
}

extension SubsystemManaged where Self : GameSystem {
    /// Runs a full game iteration on the current frame, handling each subsystem's iterations.
    ///
    /// During the processing cycle, the main system's cycle is executed first, followed by the
    /// remaining subsystems. Draw cycles are handled in two passes. The first pass checks draw
    /// calls for subsystems that require draw calls to be managed via the Playdate's Sprite APIs.
    /// Once the Playdate Sprite API's finish their drawing calls, the remaining subsystems will
    /// update their draw calls, respectively. Finally, the game's drawUI method is called to draw
    /// any remaining UI bits with the highest render priority.
    ///
    /// - Returns: Whether the screen should be updated.
    func runManagedIteration() -> Bool {
        process()
        for subsystem in subsystems {
            subsystem.process()
        }

        var shouldRedrawScreen = draw() 
        
        // First pass: check for sprites managed by Playdate.
        for subsystem in subsystems where subsystem.requiresManagedDrawCallsFromSprite {
            shouldRedrawScreen = shouldRedrawScreen && subsystem.draw()
        }
        if !shouldRedrawScreen { return false }
        Playdate.Sprite.updateAndDrawDisplayListSprites()

        // Second pass: check for everything else.
        for subsystem in subsystems where !subsystem.requiresManagedDrawCallsFromSprite {
            shouldRedrawScreen = shouldRedrawScreen && subsystem.draw()
        }

        return shouldRedrawScreen && drawUI()
    }
}
