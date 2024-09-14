import CPlaydate
import KDL
import PlaydateKit

struct Level {
    var packages: Int
    var time: Int
}

struct GameConfiguration {
    var levels: [Level]
}

class GameConfigurationParser {
    enum Constants {
        static let gameConfigKeyword = StaticString("gameconfig")
        static let levelsKeyword = StaticString("levels")
        static let levelKeyword = StaticString("level")

        static let packagesProperty = StaticString("packages")
        static let timeProperty = StaticString("time")
    }
    enum ParserError: Error {
        case missingHeader
        case missingHandle
        case missingFileStats
        case readFileFailure
        case kdlStringEmpty
        case kdlParserError
        case unimplemented
    }

    enum InternalParserState {
        case initial
        case probingConfiguration
        case probingLevels
        case probingLevel
        case finished
        case errored
    }

    let path: StaticString
    
    init(path: StaticString) {
        self.path = path
    }

    func parse() throws(ParserError) -> GameConfiguration {
        guard let handle = try? Playdate.File.open(path: path, mode: FileOptions(rawValue: 0)) else {
            throw .missingHandle
        }
        guard let stats = try? Playdate.File.stat(path: self.path) else {
            throw .missingFileStats
        }

        let buffer = UnsafeMutableRawPointer.allocate(byteCount: Int(stats.size),
                                                      alignment: MemoryLayout<CChar>.alignment)
        
        do {
            _ = try handle.read(buffer: buffer, length: stats.size)
        } catch {
            throw .readFileFailure
        }

        try? handle.close()

        let kdlString = kdl_str_from_cstr(buffer)
        guard kdlString.len > 0 else {
            throw .kdlStringEmpty
        }
       
        Playdate.System.log("[CONF] Data received: ")
        Playdate.System.log(kdlString.data)

        let parser = kdl_create_string_parser(kdlString, KDL_DEFAULTS)
        var currentEvent: kdl_event_data = kdl_parser_next_event(parser).pointee
        var parserState = InternalParserState.initial
        var levels = [Level]()
        var currentPackages: Int = 0
        var currentTimeRemaining: Int = 0

        while currentEvent.event != KDL_EVENT_EOF, currentEvent.event != KDL_EVENT_PARSE_ERROR {
            switch (currentEvent.event, parserState) {
            case (KDL_EVENT_PARSE_ERROR, _), (_, .errored):
                throw .kdlParserError
            case (KDL_EVENT_START_NODE, let state):
                if currentEvent.name == nil {
                    parserState = .errored
                    break
                }

                switch (currentEvent.name, state) {
                case (Constants.gameConfigKeyword, .initial):
                    Playdate.System.log("[CONF] Starting a new game config read")
                    parserState = .probingConfiguration
                case (Constants.levelsKeyword, .probingConfiguration):
                    Playdate.System.log("[CONF] Probing all available levels")
                    parserState = .probingLevels
                case (Constants.levelKeyword, .probingLevels):
                    Playdate.System.log("[CONF] Probing new level")
                    parserState = .probingLevel
                default:
                    parserState = .errored
                    break
                }
            case (KDL_EVENT_PROPERTY, .probingLevel):
                switch currentEvent.name {
                case Constants.packagesProperty:
                    Playdate.System.log("[CONF] Updating package count.")
                    currentPackages = Int(currentEvent.value.number.integer)
                case Constants.timeProperty:
                    Playdate.System.log("[CONF] Update time count.")
                    currentTimeRemaining = Int(currentEvent.value.number.integer)
                default:
                    Playdate.System.log("[CONF] Unknown property. Skipping...")
                }
                break
            case (KDL_EVENT_END_NODE, .probingLevel):
                Playdate.System.log("[CONF] Adding new level to the level list.")
                let newLevel = Level(packages: currentPackages, time: currentTimeRemaining)
                levels.append(newLevel)
                parserState = .probingLevels
            case (KDL_EVENT_END_NODE, .probingLevels):
                Playdate.System.log("[CONF] Finished probing levels.")
                parserState = .probingConfiguration
            case (KDL_EVENT_END_NODE, .probingConfiguration):
                Playdate.System.log("[CONF] Done reading configuration block.")
                parserState = .finished
            default:
                Playdate.System.log("[CONF] New event fired, but not recognized or needed.")
            }
            currentEvent = kdl_parser_next_event(parser).pointee
        }
        
        guard parserState == .finished else {
            throw .kdlParserError
        }
        return GameConfiguration(levels: levels)
    }
}

// From @rauhul 
extension kdl_str {
  static func ==(lhs: Self, rhs: StaticString) -> Bool {
    let rhsCount = lhs.len
    let lhsCount = rhs.utf8CodeUnitCount
    guard rhsCount == lhsCount else { return false }
    let count = min(rhsCount, lhsCount)
    return strncmp(lhs.data, rhs.utf8Start, count) == 0
  }
}

extension StaticString { 
  static func ~=(lhs: Self, rhs: kdl_str) -> Bool {
    rhs == lhs
  }
}
