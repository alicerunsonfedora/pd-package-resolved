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
        case unimplemented
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
                readCount = try handle.read(buffer: buffer, length: 8)
            } catch {
                throw .readFileFailure
            }
        }

        try? handle.close()

        let kdlString = kdl_str_from_cstr(buffer)
        guard kdlString.len != 0 else {
            throw .kdlStringEmpty
        }

        let parser = kdl_create_string_parser(kdlString, KDL_DEFAULTS)

        throw .unimplemented
    }
}
