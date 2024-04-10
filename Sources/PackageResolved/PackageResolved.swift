import PlaydateKit

/// The update function should return true to tell the system to update the display, or false if update isn’t needed.
func update() -> Bool {
    Playdate.System.drawFPS(x: 0, y: 0)
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

        Playdate.System.updateCallback = update
    default: break
    }
    return 0
}
