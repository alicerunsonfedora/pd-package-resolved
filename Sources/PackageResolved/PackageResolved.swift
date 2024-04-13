import Charolette
import PlaydateKit

func processGameOverState() -> Bool {
    guard let gameOverState = GameData.gameOverState else { return true }
    switch gameOverState {
    case .crash:
        Playdate.System.error("A crash occurred.")
    case .injury:
        Playdate.System.log("You got injured by a palette.")
    case .outOfTime:
        Playdate.System.log("You ran out of time.")
    default:
        break
    }
    return false
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

func mupdate() -> Bool {
    if !GameData.initializedGameLoop {
        return setup()
    }
    return true
}

/// The update function should return true to tell the system to update the display, or false if update isn’t needed.
func update() -> Bool {
    if !GameData.initializedGameLoop {
        return setup()
    }

    // NOTE: Impl. here is just temporary until we get proper screenage.
    if !processGameOverState() {
        return false
    }

    guard let playerTable = GameResource.playerTable else {
        GameData.gameOverState = .crash
        Playdate.System.error("Uh oh, where's the player table?")
        return false
    }

    GameData.player?.update(using: playerTable, frame: GameData.playerFrame)

    guard let paletteImage = GameResource.paletteImage else {
        GameData.gameOverState = .crash
        return false
    }

    if !GameData.paletteGracePeriodActive {
        if GameData.palettes.count != GameConstants.paletteCount {
            Playdate.System.log("What are you doing?!")
            GameData.gameOverState = .crash
            return false
        }
        for index in 0..<GameConstants.paletteCount {
            GameData.palettes[index] = Palettes.shift(
                palette: GameData.palettes[index],
                threshold: -GameConstants.charlieSize.y,
                screen: GameData.screen,
                image: paletteImage)
            
            let overlappingCounts = GameData.player?.sprite.overlappingSprites.count ?? 0
            if overlappingCounts <= 0 {
                continue
            }

            GameData.gameOverState = .injury
            return false
        }
    }

    Playdate.Sprite.updateAndDrawDisplayListSprites()

    guard let boxOnFrame = GameResource.boxOnFrame,
          let boxOffFrame = GameResource.boxOffFrame else {
            GameData.gameOverState = .crash
            return false
    }

    let currentBoxesCollected = GameData.boxesCollected
    GameData.boxFrame = (GameData.playerFrame > 2) ? 1 : 0
    for index in 0..<GameConstants.boxCount {
        GameData.boxes[index] = Boxes.shift(
            box: GameData.boxes[index],
            threshold: -GameConstants.charlieSize.y,
            index: index,
            screen: GameData.screen,
            totalBoxes: GameConstants.boxCount)
        Gameloop.drawBox(
            from: GameData.boxes,
            at: index,
            boxFrame: GameData.boxFrame,
            boxOnFrame: boxOnFrame, 
            boxOffFrame: boxOffFrame)


        let distanceToPlayer = GameData.player?.position.distance(to: GameData.boxes[index]) ?? .zero
        if distanceToPlayer < 32 {
            GameData.boxes[index].y = -GameConstants.charlieSize.y
        }

        if index < GameConstants.boxCount - 1 || !GameData.paletteGracePeriodActive || GameData.boxes[index].y >= 0 {
            continue
        }
        Palettes.fill(
            palettes: &GameData.palettes,
            to: GameConstants.paletteCount,
            screen: GameData.screen,
            image: paletteImage)
        GameData.paletteGracePeriodActive = false
    }

    // if (boxesCollected > currentBoxesCollectedInFrame) {
    //     pd->system->formatString(&counterMessage, "Boxes collected: %i", boxesCollected);
    // }

    // const vec2i boxTextPosition = {8, (int)screen.bounds.y - fontSize - 8};
    // drawASCIIText(pd, counterMessage, boxTextPosition);

    let timeSinceReset = Int(Playdate.System.elapsedTime)
    let currentTime = GameData.timeRemaining
    GameData.timeRemaining = 60 - timeSinceReset

    // if (timeRemaning < currentTime || timerMessage == NULL)
    //     pd->system->formatString(&timerMessage, "%i", timeRemaning);

    // const vec2i timerPosition = {(int)screen.bounds.x - fontSize - 12,
    //                              (int)screen.bounds.y - fontSize - 8};
    // drawASCIIText(pd, timerMessage, timerPosition);

    Gameloop.cycleFrames(frame: &GameData.playerFrame, updated: &GameData.frameUpdated)
    if !Playdate.System.isCrankDocked {
        GameData.player?.move(to: Movement.translate(
            from: GameData.player?.position ?? .zero,
            withCrankRotation: Playdate.System.crankAngle,
            bounds: GameData.screen.bounds))
    }

    // if GameData.timeRemaining <= 0 {
    //     GameData.gameOverState = .outOfTime
    // }
    
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
