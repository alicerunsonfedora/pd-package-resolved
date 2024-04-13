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
            Playdate.Graphics.setFont(styled.font)
        } catch {
            Playdate.System.error("Failed to load a suitable font!")
        }

        Playdate.System.updateCallback = update
    default: break
    }
    return 0
}

func setup() -> Bool {
    GameData.screen.bounds.x = Float(Playdate.Display.width)
    GameData.screen.bounds.y = Float(Playdate.Display.height)

    Playdate.Graphics.clear(color: 1)

    let playerPosition = Vector2<Float>(x: 0, y: 24)
    let table = Playdate.Graphics.BitmapTable(path: "Images/charlie")
    GameResource.playerTable = table
    GameData.player = Player(at: playerPosition, size: GameConstants.charlieSize, table: table)
    GameData.player?.move(to: .init(x: GameData.screen.bounds.x / 2, y: 24))
    Playdate.Sprite.updateAndDrawDisplayListSprites()

    GameResource.paletteImage = Playdate.Graphics.Bitmap(path: "Images/palette")
    if GameResource.paletteImage == nil {
        Playdate.System.error("Couldn't load palette image.")
        GameData.gameOverState = .crash
        return false
    }

    // let boxTable = try? Gameloop.getBoxTable()
    // guard let (on, off) = boxTable else {
    //     Playdate.System.error("Expected box images but found nothing.")
    //     GameData.gameOverState = .crash
    //     return false
    // }
    GameResource.boxOnFrame = Playdate.Graphics.Bitmap(path: "Images/boxOn")
    GameResource.boxOffFrame = Playdate.Graphics.Bitmap(path: "Images/boxOff")
    Boxes.fill(boxes: &GameData.boxes, screen: GameData.screen)
    Playdate.System.resetElapsedTime()

    GameData.paletteGracePeriodActive = true

    GameData.initializedGameLoop = true
    Playdate.System.log("Game has been set up.")
    return true
}