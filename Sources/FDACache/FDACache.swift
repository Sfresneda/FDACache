import Combine
import Foundation

/// FDACache is a caching framework that provides a simple and efficient way to store and retrieve data in memory.
public actor FDACache<T: Any> {

    // MARK: Properties
    private var cache: InternalCache<NSString, FDACacheObject<T>>
    private var decoder: FDACacheDecoder
    private var cancellables: Set<AnyCancellable> = []

    @Published public var removedItem: T?

    // MARK: Lifecycle
    init(maxItems: Int = 0, decoder: FDACacheDecoder = JSONDecoder()) {
        cache = InternalCache<NSString, FDACacheObject<T>>(limit: maxItems)
        self.decoder = decoder

        Task { await bind() }
    }

    deinit {
        Task { await unbind() }
    }
}

// MARK: - Public
public extension FDACache {

    /// Sets the value of the specified key in the cache.
    /// - Parameters:
    /// - key: The key with which to associate the value.
    /// - value: The value to set.
    func set(_ key: String, value: T) {
        let model = FDACacheObject(data: value)
        cache.set(key as NSString, value: model)
    }

    /// Returns the value associated with a given key.
    /// - Parameters:
    /// - key: The key for which to return the corresponding value.
    /// - Returns: The value associated with key, or nil if no value is associated with key.
    func get(_ key: String) async -> T? {
        cache.get(key as NSString)?.data
    }

    /// Returns the model associated with a given key.
    /// - Parameters:
    /// - key: The key for which to return the corresponding value.
    /// - Returns: The model associated with key, or nil if no value is associated with key.
    /// - Throws: FDACacheError.notFound if the item was not found in the cache.
    /// - Throws: FDACacheError.nonParseable if the item was found but could not be parsed.
    func get<M: Decodable>(_ key: String, transform: ((T) -> Data?)) async throws -> M {
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

// MARK: - Private
private extension FDACache {

    /// Binds the cache published property.
    func bind() {
        cache
            .$removedObject
            .sink { object in
                self.removedItem = object?.data
            }
            .store(in: &cancellables)
    }

    /// Unbinds the cache published property.
    func unbind() {
        cancellables.removeAll()
    }
}

