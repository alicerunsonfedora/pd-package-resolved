import Charolette
import PlaydateKit

enum GameState {
   case menu
   case startingLevel
   case inLevel
   case gameOver(GameOverState)
}

extension GameState: Equatable {}

// TODO: How do we make these thread-safe?

/// An enumeration containing various game constants.
enum GameConstants {
    /// A vector representation of the player's width and height.
    nonisolated(unsafe) static let charlieSize: Vector2<Float> = .init(x: 32, y: 64)

    /// The number of boxes that should spawn in a given run on the screen.
    static let boxCount: Int = 6
    
    /// The number of palettes that should spawn in a given run on the screen.
    static let paletteCount: Int = 2

    /// The default horizontal inset from either side of the screen.
    static let xInset: Float = 32
}

/// An enumeration of the various resources the game may use.
enum GameResource {
    /// The current font for all text on the screen.
    nonisolated(unsafe) static var currentFont: FontSet?

    /// The player's image table.
    nonisolated(unsafe) static var playerTable: Playdate.Graphics.BitmapTable?

    /// The palette's bitmap image.
    nonisolated(unsafe) static var paletteImage: Playdate.Graphics.Bitmap?

    /// The box's primary or "on" bitmap image.
    nonisolated(unsafe) static var boxOnFrame: Playdate.Graphics.Bitmap?

    /// The box's secondary or "off" bitmap image.
    nonisolated(unsafe) static var boxOffFrame: Playdate.Graphics.Bitmap?

    /// The clock UI's image table.
    nonisolated(unsafe) static var clockTable: Playdate.Graphics.BitmapTable?
}

// FIXME: Big doo doo turd bad

enum GameData {
    nonisolated(unsafe) static var screen = ScreenData(
        bounds: .zero,
        insets: .init(
            top: GameConstants.charlieSize.y + 8,
            left: GameConstants.xInset,
            right: GameConstants.xInset,
            bottom: 32))

    nonisolated(unsafe) static var palettes: [Palette] = []
    nonisolated(unsafe) static var boxes: [Vector2<Float>] = Array(
        repeating: .zero, count: GameConstants.boxCount)

    nonisolated(unsafe) static var playerFrame: Int = 0
    nonisolated(unsafe) static var boxFrame: Int = 0

    nonisolated(unsafe) static var player: Player?
    nonisolated(unsafe) static var boxesCollected: Int = 0
    
    nonisolated(unsafe) static var timeRemaining: Int = 60

    @available(*, deprecated, message: "Use GameState with the .gameOver case.")
    nonisolated(unsafe) static var gameOverState: GameOverState?
    nonisolated(unsafe) static var gameState = GameState.menu
    
    nonisolated(unsafe) static var frameUpdated = false
    nonisolated(unsafe) static var initializedGameLoop = false
    nonisolated(unsafe) static var paletteGracePeriodActive = false
    
    nonisolated(unsafe) static var configuredLevelData = Level(packages: 30, time: 60)
    nonisolated(unsafe) static var configuration: GameConfiguration = GameConfiguration(levels: [])
    nonisolated(unsafe) static var currentLevel: Int = 0

    static func nextLevel() {
       guard GameData.currentLevel <= GameData.configuration.levels.endIndex else {
           Playdate.System.log("No more levels to load.")
           return
       }

       GameData.currentLevel += 1
       if GameData.currentLevel >= GameData.configuration.levels.count {
           GameData.currentLevel = GameData.configuration.levels.count - 1
       }

       GameData.set(level: GameData.configuration.levels[GameData.currentLevel])
    }

    static func set(level: Level) {
        GameData.configuredLevelData = level
        GameData.timeRemaining = level.time
        GameData.gameState = .startingLevel 
    }

    static func reset(jumpIntoLevel: Bool = true) {
        GameData.initializedGameLoop = false
        if jumpIntoLevel {
            GameData.gameState = .inLevel
        }

        GameData.palettes.removeAll()
        GameData.boxes = Array(repeating: .zero, count: GameConstants.boxCount)
        GameData.playerFrame = 0
        GameData.boxFrame = 0
        GameData.player = nil
        GameData.boxesCollected = 0
        GameData.timeRemaining = configuredLevelData.time 
        GameData.frameUpdated = false
        GameData.paletteGracePeriodActive = false
    }
}
