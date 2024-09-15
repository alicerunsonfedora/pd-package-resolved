import Charolette
import PlaydateKit

/// The subsystem that controls player movement.
final class PlayerSubsystem: Subsystem {
    override var requiresManagedDrawCallsFromSprite: Bool { true }

    override func process() {
        guard GameData.gameState == .inLevel else { return }
        let (currentButtons, _, _) = Playdate.System.buttonState
        let currentXPosition = GameData.player?.position.x ?? 0

        var movementDelta: Float = 0 
        if !Playdate.System.isCrankDocked {
            let crankChange = Playdate.System.crankChange
            Playdate.System.log("Crank change: \(Int(crankChange))")
            movementDelta = crankChange 
        } else if currentButtons.contains(.left) {
            movementDelta = -4
        } else if currentButtons.contains(.right) {
            movementDelta = +4
        }

        if movementDelta != 0 {
            let newMovementVector = Movement.translate(
                from: GameData.player?.position ?? .zero,
                withCrankRotation: movementDelta,
                bounds: GameData.screen.bounds
            )

            Playdate.System.log("New X Position: \(Int(newMovementVector.x))")

            GameData.player?.move(to: newMovementVector) 
        }
    }

    override func draw() -> Bool {
        guard GameData.gameState == .inLevel else { return true }
        guard let playerTable = GameResource.playerTable else {
            GameData.gameState = .gameOver(.crash)
            Playdate.System.error("Uh oh, where's the player table?")
            return false
        }

        GameData.player?.update(using: playerTable, frame: GameData.playerFrame)
        return true
    }
}
