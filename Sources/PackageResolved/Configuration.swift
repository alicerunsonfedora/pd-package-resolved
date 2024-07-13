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
        case probingLevels
        case probingLevel
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
        
        var readCount: CInt = 1
        while readCount != 0 {
            do {
                readCount = try handle.read(buffer: buffer, length: stats.size)
                try handle.seek(to: readCount)
            } catch {
                throw .readFileFailure
            }
        }

        try? handle.close()

        let kdlString = kdl_str_from_cstr(buffer)
        guard kdlString.len > 0 else {
            throw .kdlStringEmpty
        }
        
        Playdate.System.log("Data received: ")
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
            case let (KDL_EVENT_START_NODE, state):
                if currentEvent.event != KDL_EVENT_START_NODE {
                    Playdate.System.log("HUH?!?!?!?!")
                }

                if currentEvent.name == nil {
                    parserState = .errored
                    break
                }
                if strcmp(currentEvent.name.data, StaticString("levels").utf8Start) == 0 {
                    Playdate.System.log("foo")
                } else {
                    Playdate.System.log("bar")
                }
            default:
                Playdate.System.log("New event fired!")
            }
            currentEvent = kdl_parser_next_event(parser).pointee
        }
        throw .unimplemented
    }
}

