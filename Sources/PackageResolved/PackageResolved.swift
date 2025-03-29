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
                System.error("WTF there are no levels")
                return
            }
            GameData.configuration = config
            GameData.set(level: config.levels[0])
        } catch GameConfigurationParser.ParserError.missingHandle {
            System.log("No handle available.")
        } catch GameConfigurationParser.ParserError.missingFileStats {
            System.log("No file stats available.")
        } catch GameConfigurationParser.ParserError.readFileFailure {
            System.log("Something went wrong in read.")
        } catch GameConfigurationParser.ParserError.kdlStringEmpty {
            System.log("KDL string is empty")
        } catch GameConfigurationParser.ParserError.kdlParserError {
            System.log("Something went wrong when parsing the data.")
        } catch {
            System.log("Something else happened aaaaa")
        }
    }
}

// MARK: GameRunner conformance
extension PackageResolvedGameloop: GameSystem {
    func process() {
        let (_, _, released) = System.buttonState
        switch GameData.gameState {
        case .gameOver(let gameOverState):
            guard released.contains(.a) else { return }
            if (gameOverState == .success) {
                GameData.nextLevel()
                return
            }
            GameData.reset()
            self.recentDisplay = .none 
        case .startingLevel:
            guard released.contains(.a) else { return }
            GameData.reset(jumpIntoLevel: true)
            self.recentDisplay = .none
        default:
            if !GameData.initializedGameLoop {
                System.log("Game loop not ready. Please call setup.")
                GameData.reset()
                return
            }
            Gameloop.cycleFrames(frame: &GameData.playerFrame, updated: &GameData.frameUpdated)
        }
    }

    func draw() -> Bool {
        switch GameData.gameState {
        case .inLevel:
            if !GameData.initializedGameLoop {
                System.log("Calling setup.")
                return setup()
            }
            return true

        default:
           return true 
        }
    }

    func drawUI() -> Bool {
        switch GameData.gameState {
        case .startingLevel:
            UI.displayLevelSummary(packages: GameData.configuredLevelData.packages, time: GameData.configuredLevelData.time)
            if self.recentDisplay != .levelSummary {
                self.recentDisplay = .levelSummary
                return true
            }
            return false
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
           return true 
        }
    }
}

extension PackageResolvedGameloop: SubsystemManaged {}
