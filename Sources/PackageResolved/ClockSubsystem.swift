import Charolette
import PlaydateKit

/// The subsystem responsible for handling the game's current time.
final class ClockSubsystem: Subsystem {
    private var percentRemaining: Float {
        Float(GameData.timeRemaining) / Float(GameData.configuredLevelData.time) 
    }

    private var frameForCurrentPercentage: CInt {
        return switch percentRemaining {            
        case 0.76...1.0: 0
        case 0.51...0.75: 1
        case 0.26...0.50: 2
        case 0.01...0.25: 3
        default: 4
        }
    }

    override func process() {
        guard GameData.gameState == .inLevel else { return }
        let timeSinceReset = Int(Playdate.System.elapsedTime)
        GameData.timeRemaining = GameData.configuredLevelData.time - timeSinceReset

        if GameData.timeRemaining == 55 {
            GameData.paletteGracePeriodActive = false
        }

        if GameData.timeRemaining <= 0, GameData.initializedGameLoop {
            let metTarget = GameData.boxesCollected >= GameData.configuredLevelData.packages
            let gameOverState: GameOverState = metTarget ? .success : .outOfTime
            GameData.gameState = .gameOver(gameOverState)
        }
    }

    override func draw() -> Bool {
        guard GameData.gameState == .inLevel else { return true }
        let yPos = Int32(GameData.screen.bounds.y) - 24
        let width = Int32(GameData.screen.bounds.x)
        Playdate.Graphics.fillRect(x: 0, y: yPos, width: width, height: 24, color: 1)
        Playdate.Graphics.drawRect(x: 0, y: yPos, width: width, height: 24)

        guard let table = GameResource.clockTable,
              let frame = table.bitmap(at: frameForCurrentPercentage) else {
            Playdate.System.log("No clock?")
            return false
        }

        Playdate.Graphics.drawBitmap(frame,
                                    position: Vector2(x: 24, y: 20) - GameData.screen.bounds,
                                    flip: .bitmapUnflipped)

        // NOTE: Because the clock subsystem has the highest priority for UI drawing, all parts of the overlay with
        // text are written here.
        let yBaseline = GameData.screen.bounds.y - Float(GameResource.currentFont?.size ?? 9) - 1

        let boxesCollectedMessage = "\(GameData.boxesCollected)/\(GameData.configuredLevelData.packages)"
        UI.drawText(boxesCollectedMessage, at: .init(x: 8, y: Int(yBaseline)))

        let timeRemainingMessage = "\(GameData.timeRemaining < 10 ? "0" : "")\(GameData.timeRemaining)"
        
        // 36.0 to account for clock and padding, then n * 9.0 to account for string length.
        let offset: Float = 36.0 + (2 * 9.0)
        UI.drawText(timeRemainingMessage,
                    at: .init(x: Int(GameData.screen.bounds.x - offset), y: Int(yBaseline)))

        return true
    }
}
