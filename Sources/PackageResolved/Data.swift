import Charolette
import PlaydateKit

enum GameConstants {
    nonisolated(unsafe) static let charlieSize: Vector2<Float> = .init(x: 32, y: 64)
    nonisolated(unsafe) static let boxCount: Int = 6
    nonisolated(unsafe) static let paletteCount: Int = 2
    nonisolated(unsafe) static let xInset: Float = 32
}

enum GameResource {
    nonisolated(unsafe) static var currentFont: FontSet?
    nonisolated(unsafe) static var playerTable: Playdate.Graphics.BitmapTable?
    nonisolated(unsafe) static var paletteImage: Playdate.Graphics.Bitmap?
    nonisolated(unsafe) static var boxOnFrame: Playdate.Graphics.Bitmap?
    nonisolated(unsafe) static var boxOffFrame: Playdate.Graphics.Bitmap?
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
    nonisolated(unsafe) static var gameOverState: GameOverState?
    
    nonisolated(unsafe) static var frameUpdated = false
    nonisolated(unsafe) static var initializedGameLoop = false
    nonisolated(unsafe) static var paletteGracePeriodActive = false
}