import Charolette
import PlaydateKit

// MARK: Gameloop handler

final class PackageResolvedGameloop {
    nonisolated(unsafe) var subsystems: [Subsystem] = [
        PlayerSubsystem(),
        PaletteSubsystem(),
        PackageSubsystem()
    ]

    init() {}

    private func processTime() {
        let timeSinceReset = Int(Playdate.System.elapsedTime)
        GameData.timeRemaining = 60 - timeSinceReset

        if GameData.timeRemaining == 55 {
            GameData.paletteGracePeriodActive = false
        }

        if GameData.timeRemaining <= 0 {
            GameData.gameOverState = .outOfTime
        }
    }
}

// MARK: GameRunner conformance
extension PackageResolvedGameloop: GameSystem {
    func process() {
        if !GameData.initializedGameLoop {
            Playdate.System.log("Game loop not ready. Please call setup.")
            GameData.reset()
            return
        }

        if GameData.gameOverState != nil {
            let (_, _, released) = Playdate.System.buttonState
            if released.contains(.a) { GameData.reset() }
            Playdate.System.log("GAME OVER")
            return
        }

        processTime()
        Gameloop.cycleFrames(frame: &GameData.playerFrame, updated: &GameData.frameUpdated)
    }

    func draw() -> Bool {
        if !GameData.initializedGameLoop {
            Playdate.System.log("Calling setup.")
            return setup()
        }

        if let gameOverState = GameData.gameOverState {
            UI.displayAlert(message: gameOverState.staticMessage, options: .displayRestart)
            return false
        }

        // NOTE: Allocate C string via UnsafeMutableBufferPointer.allocate - rauhul

        // TODO: Get this to show different phases of the clock, not just the full clock
        if let clockFrame = GameResource.clockFrame {
            Playdate.Graphics.drawBitmap(clockFrame,
                                        // TODO: this is NOT how math works
                                        position: Vector2(x: 32, y: 32) - GameData.screen.bounds,
                                        flip: .bitmapUnflipped)
        } else {
            Playdate.System.log("No clock?")
            return false
        }
        return true
    }
}

extension PackageResolvedGameloop: SubsystemManaged {}
