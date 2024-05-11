import Charolette
import PlaydateKit

// MARK: Gameloop handler

final class PackageResolvedGameloop {
    nonisolated(unsafe) var subsystems: [Subsystem] = [
        PlayerSubsystem(),
        PaletteSubsystem(),
        PackageSubsystem(),
        ClockSubsystem()
    ]

    init() {}
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
        return true
    }
}

extension PackageResolvedGameloop: SubsystemManaged {}
