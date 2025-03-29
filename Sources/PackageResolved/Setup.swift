import Charolette
import PlaydateKit

@_cdecl("eventHandler") func eventHandler(
    pointer: UnsafeMutableRawPointer!,
    event: System.Event,
    _: UInt32
) -> Int32 {
    switch event {
    case .initialize:
        Playdate.initialize(with: pointer)

        do {
            let styled = try Fonts.styledFont(for: .bold)
            GameResource.currentFont = styled
            Graphics.setFont(styled.font)
        } catch {
            System.error("Failed to load a suitable font!")
        }

        System.addMenuItem(title: "Restart") {
            GameData.reset()
        }

        let mainGameloop = PackageResolvedGameloop()
        System.updateCallback = mainGameloop.runManagedIteration
    default: break
    }
    return 0
}

func setup() -> Bool {
    // MARK: Screen Clearing
    GameData.screen.bounds.x = Float(Display.width)
    GameData.screen.bounds.y = Float(Display.height)

    Graphics.clear(color: .white)

    // MARK: Player Setup
    let playerPosition = Vector2<Float>(x: 0, y: 24)

    if GameResource.playerTable == nil {
        GameResource.playerTable = try? Graphics.BitmapTable(path: "Images/charlie")
    }

    if let table = GameResource.playerTable {
        GameData.player = Player(at: playerPosition, size: GameConstants.charlieSize, table: table)
    }
    GameData.player?.move(to: .init(x: GameData.screen.bounds.x / 2, y: 24))
    Sprite.updateAndDrawDisplayListSprites()

    // MARK: Palette Resource
    if GameResource.paletteImage == nil {
        GameResource.paletteImage = try? Graphics.Bitmap(path: "Images/palette")
        if GameResource.paletteImage == nil {
            System.error("Couldn't load palette image.")
            GameData.gameState = .gameOver(.crash)
            return false
        }
    }

    // MARK: Boxes
    if GameResource.boxOnFrame == nil, GameResource.boxOffFrame == nil {
        GameResource.boxOnFrame = try? Graphics.Bitmap(path: "Images/boxOn")
        GameResource.boxOffFrame = try? Graphics.Bitmap(path: "Images/boxOff")
    }

    Boxes.fill(boxes: &GameData.boxes, screen: GameData.screen)

    // MARK: UI
    if GameResource.clockTable == nil {
        let clockTable = try? Graphics.BitmapTable(path: "Images/clock")
        GameResource.clockTable = clockTable
    }
    
    System.resetElapsedTime()

    GameData.paletteGracePeriodActive = true

    GameData.initializedGameLoop = true
    System.log("Game has been set up.")
    return true
}
