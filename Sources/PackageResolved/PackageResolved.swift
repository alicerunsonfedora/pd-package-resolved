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

func update() -> Bool {
    return UI.displayAlert(message: "I like to eat pickles.")
}

/// The update function should return true to tell the system to update the display, or false if update isn’t needed.
func mupdate() -> Bool {
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

    // let currentBoxesCollected = GameData.boxesCollected
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
    // let currentTime = GameData.timeRemaining
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
