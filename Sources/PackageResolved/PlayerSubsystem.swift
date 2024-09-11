import Charolette
import PlaydateKit

/// The subsystem that controls player movement.
final class PlayerSubsystem: Subsystem {
    override var requiresManagedDrawCallsFromSprite: Bool { true }

    override func process() {
        guard GameData.gameState == .inLevel else { return }
        let (currentButtons, _, _) = Playdate.System.buttonState
        let currentXPosition = GameData.player?.position.x ?? 0

        var movementDelta: Float = -1
        if !Playdate.System.isCrankDocked {
            movementDelta = Playdate.System.crankAngle
        } else if currentButtons.contains(.left) {
            movementDelta = currentXPosition - 4
        } else if currentButtons.contains(.right) {
            movementDelta = currentXPosition + 4
        }

        if movementDelta >= 0 {
            GameData.player?.move(to: Movement.translate(
                from: GameData.player?.position ?? .zero,
                withCrankRotation: movementDelta,
                bounds: GameData.screen.bounds))
        }
    }

    override func draw() -> Bool {
        guard GameData.gameState == .inLevel else { return true }
        guard let playerTable = GameResource.playerTable else {
            GameData.gameOverState = .crash
            Playdate.System.error("Uh oh, where's the player table?")
            return false
        }

        GameData.player?.update(using: playerTable, frame: GameData.playerFrame)
        return true
    }
}
