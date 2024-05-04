import Charolette
import PlaydateKit

func processGameOver(state gameOverState: GameOverState) -> Bool {
    return UI.displayAlert(message: gameOverState.staticMessage,
                           options: .displayRestart)
}

func mupdate() -> Bool {
    return UI.displayAlert(message: "I like to eat pickles.")
}

/// The update function should return true to tell the system to update the display, or false if update isn’t needed.
func update() -> Bool {
    if !GameData.initializedGameLoop {
        return setup()
    }

    if let gameOverState = GameData.gameOverState {
        let (_, _, released) = Playdate.System.buttonState
        if released.contains(.a) {
            GameData.reset()
            return false
        }
        return processGameOver(state: gameOverState)
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

    // NOTE: Allocate C string via UnsafeMutableBufferPointer.allocate - rauhul
    
    // if (boxesCollected > currentBoxesCollectedInFrame) {
    //     pd->system->formatString(&counterMessage, "Boxes collected: %i", boxesCollected);
    // }

    // const vec2i boxTextPosition = {8, (int)screen.bounds.y - fontSize - 8};
    // drawASCIIText(pd, counterMessage, boxTextPosition);

    let timeSinceReset = Int(Playdate.System.elapsedTime)
    // let currentTime = GameData.timeRemaining


    // TODO: Get this to show different phases of the clock, not just the full clock
    GameData.timeRemaining = 60 - timeSinceReset
    if let clockFrame = GameResource.clockFrame {
        Playdate.Graphics.drawBitmap(clockFrame,
                                     // TODO: this is NOT how math works
                                     position: Vector2(x: 32, y: 32) - GameData.screen.bounds,
                                     flip: .bitmapUnflipped)
    } else {
        Playdate.System.log("No clock?")
    }

    // if (timeRemaning < currentTime || timerMessage == NULL)
    //     pd->system->formatString(&timerMessage, "%i", timeRemaning);

    // const vec2i timerPosition = {(int)screen.bounds.x - fontSize - 12,
    //                              (int)screen.bounds.y - fontSize - 8};
    // drawASCIIText(pd, timerMessage, timerPosition);

    let (currentButtons, _, _) = Playdate.System.buttonState
    let currentXPosition = GameData.player?.position.x ?? 0

    var movementDelta: Float = -1
    if !Playdate.System.isCrankDocked {
        movementDelta = Playdate.System.crankAngle
    } else if currentButtons.contains(.left) {
        movementDelta = currentXPosition - 4
    } else if currentButtons.contains(.right) {
        movementDelta = currentXPosition + 4
    }

    Gameloop.cycleFrames(frame: &GameData.playerFrame, updated: &GameData.frameUpdated)
    if movementDelta >= 0 {
        GameData.player?.move(to: Movement.translate(
            from: GameData.player?.position ?? .zero,
            withCrankRotation: movementDelta,
            bounds: GameData.screen.bounds))
    }
    if GameData.timeRemaining <= 0 {
        GameData.gameOverState = .outOfTime
    }
    
    return true
}
