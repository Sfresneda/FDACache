import Combine
import Foundation

/// FDACache is a caching framework that provides a simple and efficient way to store and retrieve data in memory.
public actor FDACache {

    // MARK: Properties
    private var cache: InternalCache<NSString>
    private let decoder: FDACacheDecoder

    // MARK: Lifecycle
    public init(maxItems: Int = 0,
                lifetime: TimeInterval = 600.0,
                decoder: FDACacheDecoder = JSONDecoder()) {
        cache = InternalCache<NSString>(limit: maxItems,
                                        lifeTime: lifetime)
        self.decoder = decoder
    }
}

// MARK: - Public
public extension FDACache {

    /// Sets the value of the specified key in the cache.
    /// - Parameters:
    /// - key: The key with which to associate the value.
    /// - value: The value to set.
    func set(_ key: String, value: Any) {
        cache.set(key as NSString, value: value)
    }

    /// Returns the value associated with a given key.
    /// - Parameters:
    /// - key: The key for which to return the corresponding value.
    /// - Returns: The value associated with key, or nil if no value is associated with key.
    func get(_ key: String) async -> Any? {
        (cache.get(key as NSString) as? FDACacheObject)?
            .data
    }

    /// Returns the model associated with a given key.
    /// - Parameters:
    /// - key: The key for which to return the corresponding value.
    /// - Returns: The model associated with key, or nil if no value is associated with key.
    /// - Throws: FDACacheError.notFound if the item was not found in the cache.
    /// - Throws: FDACacheError.nonParseable if the item was found but could not be parsed.
    func get<M: Decodable>(_ key: String, transform: ((Any) -> Data?)) async throws -> M {
        guard let model = cache.get(key as NSString) as? FDACacheObject else {
            throw FDACacheError.notFound
        }
        guard let data = transform(model.data) else {
            throw FDACacheError.nonParseable
        }
        return try decoder.decode(M.self, from: data)
    }

    /// Removes the value of the specified key in the cache.
    /// - Parameters:
    /// - key: The key with which to associate the value.
    func delete(_ key: String) {
        cache.delete(key as NSString)
    }

    /// Removes all values from the cache.
    func clean() {
        cache.clean()
    }
}
