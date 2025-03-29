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
        let timeSinceReset = Int(System.elapsedTime)
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
        let yPos = Int(GameData.screen.bounds.y) - 24
        let width = Int(GameData.screen.bounds.x)
        Graphics.fillRect(Rect(x: 0, y: yPos, width: width, height: 24), color: .white)
        Graphics.drawRect(Rect(x: 0, y: yPos, width: width, height: 24))

        guard let table = GameResource.clockTable,
              let frame = table.bitmap(at: Int(frameForCurrentPercentage)) else {
            System.log("No clock?")
            return false
        }

        let pos = Vector2(x: 24, y: 20) - GameData.screen.bounds
        Graphics.drawBitmap(frame, at: Point(x: pos.x, y: pos.y), flip: .unflipped)

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
