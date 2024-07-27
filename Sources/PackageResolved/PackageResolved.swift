import Charolette
import KDL
import PlaydateKit

// MARK: Gameloop handler
final class PackageResolvedGameloop {
    nonisolated(unsafe) var subsystems: [Subsystem] = [
        PlayerSubsystem(),
        PaletteSubsystem(),
        PackageSubsystem(),
        ClockSubsystem()
    ]

    init() {
        let parser = GameConfigurationParser(path: "prconfig")

        do {
            let config = try parser.parse()
            guard !config.levels.isEmpty else {
                Playdate.System.error("WTF there are no levels")
                return
            }
            GameData.configuration = config
            GameData.set(level: config.levels[0])
        } catch GameConfigurationParser.ParserError.missingHandle {
            Playdate.System.log("No handle available.")
        } catch GameConfigurationParser.ParserError.missingFileStats {
            Playdate.System.log("No file stats available.")
        } catch GameConfigurationParser.ParserError.readFileFailure {
            Playdate.System.log("Something went wrong in read.")
        } catch GameConfigurationParser.ParserError.kdlStringEmpty {
            Playdate.System.log("KDL string is empty")
        } catch GameConfigurationParser.ParserError.kdlParserError {
            Playdate.System.log("Something went wrong when parsing the data.")
        } catch {
            Playdate.System.log("Something else happened aaaaa")
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
            if released.contains(.a) {
                if (GameData.gameOverState == .success) {
                    GameData.nextLevel()
                }
                GameData.reset()
            }
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
