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

    enum UIRecentDisplay {
        case gameOver
        case levelSummary
        case none
    }

    var recentDisplay = UIRecentDisplay.none

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
        let (_, _, released) = Playdate.System.buttonState
        switch GameData.gameState {
        case .gameOver(let gameOverState):
            if !released.contains(.a) { return }
            if (gameOverState == .success) {
                GameData.nextLevel()
                return
            }
            GameData.reset()
            self.recentDisplay = .none 
        case .startingLevel:
            if !released.contains(.a) { return }
            GameData.reset(jumpIntoLevel: true)
            self.recentDisplay = .none
        default:
            if !GameData.initializedGameLoop {
                Playdate.System.log("Game loop not ready. Please call setup.")
                GameData.reset()
                return
            }
            Gameloop.cycleFrames(frame: &GameData.playerFrame, updated: &GameData.frameUpdated)
        }
    }

    func draw() -> Bool {
        switch GameData.gameState {
        case .startingLevel:
            UI.displayLevelSummary(packages: GameData.configuredLevelData.packages, time: GameData.configuredLevelData.time)
            if self.recentDisplay != .levelSummary {
                self.recentDisplay = .levelSummary
                return true
            }
            return false 
        case .inLevel:
            if !GameData.initializedGameLoop {
                Playdate.System.log("Calling setup.")
                return setup()
            }
            return true
        case .gameOver(let gameOverState):
            var alertOptions: UI.AlertOptions = []
            if gameOverState == .success {
                alertOptions.insert(.displayContinue)
            } else {
                alertOptions.insert(.displayRestart)
            }
            UI.displayAlert(message: gameOverState.message, options: alertOptions)
            if self.recentDisplay != .gameOver {
                self.recentDisplay = .gameOver
                return true
            }
            return false 
        default:
           return false 
        }
    }
}

extension PackageResolvedGameloop: SubsystemManaged {}
