import Charolette
import PlaydateKit

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
            GameResource.currentFont = styled
            Playdate.Graphics.setFont(styled.font)
        } catch {
            Playdate.System.error("Failed to load a suitable font!")
        }

        Playdate.System.addMenuItem(title: "Restart") { _ in
            GameData.reset()
        }

        let mainGameloop = PackageResolvedGameloop()
        Playdate.System.updateCallback = mainGameloop.runManagedIteration
    default: break
    }
    return 0
}

func setup() -> Bool {
    // MARK: Screen Clearing
    GameData.screen.bounds.x = Float(Playdate.Display.width)
    GameData.screen.bounds.y = Float(Playdate.Display.height)

    Playdate.Graphics.clear(color: 1)

    // MARK: Player Setup
    let playerPosition = Vector2<Float>(x: 0, y: 24)

    if GameResource.playerTable == nil {
        GameResource.playerTable = Playdate.Graphics.BitmapTable(path: "Images/charlie")
    }

    if let table = GameResource.playerTable {
        GameData.player = Player(at: playerPosition, size: GameConstants.charlieSize, table: table)
    }
    GameData.player?.move(to: .init(x: GameData.screen.bounds.x / 2, y: 24))
    Playdate.Sprite.updateAndDrawDisplayListSprites()

    // MARK: Palette Resource
    if GameResource.paletteImage == nil {
        GameResource.paletteImage = Playdate.Graphics.Bitmap(path: "Images/palette")
        if GameResource.paletteImage == nil {
            Playdate.System.error("Couldn't load palette image.")
            GameData.gameOverState = .crash
            return false
        }
    }

    // MARK: Boxes
    if GameResource.boxOnFrame == nil, GameResource.boxOffFrame == nil {
        GameResource.boxOnFrame = Playdate.Graphics.Bitmap(path: "Images/boxOn")
        GameResource.boxOffFrame = Playdate.Graphics.Bitmap(path: "Images/boxOff")
    }

    Boxes.fill(boxes: &GameData.boxes, screen: GameData.screen)

    // MARK: UI
    if GameResource.clockTable == nil {
        let clockTable = Playdate.Graphics.BitmapTable(path: "Images/clock")
        GameResource.clockTable = clockTable
    }
    
    Playdate.System.resetElapsedTime()

    GameData.paletteGracePeriodActive = true

    GameData.initializedGameLoop = true
    Playdate.System.log("Game has been set up.")
    return true
}
