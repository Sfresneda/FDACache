import Foundation

/// A protocol that provides a way to decode data into a specific type.
public protocol FDACacheDecoder {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: FDACacheDecoder {}
