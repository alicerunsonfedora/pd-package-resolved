import Charolette
import PlaydateKit

enum GameData {
    nonisolated(unsafe) static var boxOnFrame: Playdate.Graphics.Bitmap?
    nonisolated(unsafe) static var boxOffFrame: Playdate.Graphics.Bitmap?
}

/// The update function should return true to tell the system to update the display, or false if update isn’t needed.
func update() -> Bool {
    Playdate.System.drawFPS(x: 0, y: 0)

    if let frame = GameData.boxOnFrame {
        Playdate.Graphics.drawBitmap(frame, position: Vector2<Float>(x: 2, y: 2), flip: .bitmapUnflipped)
    }

    return true
}

@_cdecl("eventHandler") func eventHandler(
    pointer: UnsafeMutableRawPointer!,
    event: Playdate.System.Event,
    _: UInt32
) -> Int32 {
    switch event {
    case .initialize:
        Playdate.initialize(with: pointer)

        do {
            let styled = try Fonts.styledFont(for: .bold)
            Playdate.Graphics.setFont(styled.font)
        } catch {
            Playdate.System.error("Failed to load a suitable font!")
        }

        if let (onFrame, offFrame) = try? Gameloop.getBoxTable() {
            GameData.boxOnFrame = onFrame
            GameData.boxOffFrame = offFrame
        }

        Playdate.System.updateCallback = update
    default: break
    }
    return 0
}
