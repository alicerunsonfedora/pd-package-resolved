import Charolette
import PlaydateKit

/// The subsystem responsible for handling the game's current time.
final class ClockSubsystem: Subsystem {
    private var percentRemaining: Float {
        Float(GameData.timeRemaining) / 60
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
        let timeSinceReset = Int(Playdate.System.elapsedTime)
        GameData.timeRemaining = 60 - timeSinceReset

        if GameData.timeRemaining == 55 {
            GameData.paletteGracePeriodActive = false
        }

        if GameData.timeRemaining <= 0 {
            GameData.gameOverState = .outOfTime
        }
    }

    override func draw() -> Bool {
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
        return true
    }
}