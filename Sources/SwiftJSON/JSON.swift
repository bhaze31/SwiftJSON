import Foundation

public enum JSON: Codable {
    case double(Double)
    case integer(Int)
    case string(String)
    case boolean(Bool)
    case null
    indirect case array([JSON])
    indirect case dict([String: JSON])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(Int.self) {
            self = .integer(value)
            return
        }

        if let value = try? container.decode(Double.self) {
            self = .double(value)
            return
        }

        if let value = try? container.decode(Bool.self) {
            self = .boolean(value)
            return
        }

        if let value = try? container.decode(String.self) {
            self = .string(value)
            return
        }

        if let value = try? container.decode([JSON].self) {
            self = .array(value)
            return
        }

        if let value = try? container.decode([String: JSON].self) {
            self = .dict(value)
            return
        }

        if container.decodeNil() {
            self = .null
            return
        }

        throw DecodingError.dataCorrupted(
            .init(
                codingPath: container.codingPath,
                debugDescription: "Cannot decode JSON object"
            )
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .double(let value):
                try container.encode(value)
            case .integer(let value):
                try container.encode(value)
            case .string(let value):
                try container.encode(value)
            case .boolean(let value):
                try container.encode(value)
            case .null:
                try container.encodeNil()
            case .array(let value):
                try container.encode(value)
            case .dict(let value):
                try container.encode(value)
        }
    }

    public func convertedType() -> String {
        switch self {
            case .double:
                return "double"
            case .integer:
                return "integer"
            case .boolean:
                return "boolean"
            case .string:
                return "string"
            case .null:
                return "null"
            case .array:
                return "array"
            case .dict:
                return "dictionary"
        }
    }

    public func keys() throws -> [String]? {
        switch self {
            case .dict:
                let dictionaryData = try dictionaryData()
                return dictionaryData.keys.map { $0 }
            default:
                return nil
        }
    }

    public func dictionaryData() throws -> Dictionary<String, JSON> {
        let data = try JSONEncoder().encode(self)
        return try JSONDecoder().decode([String: JSON].self, from: data)
    }

    public func stringValue() -> String? {
        switch self {
            case .string(let value):
                return value
            default:
                return nil
        }
    }

    public func doubleValue() -> Double? {
        switch self {
            case .double(let value):
                return value
            default:
                return nil
        }
    }

    public func intValue() -> Int? {
        switch self {
            case .integer(let value):
                return value
            default:
                return nil
        }
    }

    public func boolValue() -> Bool? {
        switch self {
            case .boolean(let value):
                return value
            default:
                return nil
        }
    }

    public func arrayValue() -> [JSON]? {
        switch self {
            case .array(let value):
                return value
            default:
                return nil
        }
    }
}
