import Charolette
import PlaydateKit

final class ClockSubsystem: Subsystem {
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
        // TODO: Get this to show different phases of the clock, not just the full clock
        if let clockFrame = GameResource.clockFrame {
            Playdate.Graphics.drawBitmap(clockFrame,
                                        position: Vector2(x: 32, y: 32) - GameData.screen.bounds,
                                        flip: .bitmapUnflipped)
        } else {
            Playdate.System.log("No clock?")
            return false
        }
        return true
    }
}