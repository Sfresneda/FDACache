import Combine
import Foundation

/// Internal cache.
/// This class is not thread safe. It is the responsibility of the caller 
/// to ensure thread safety.
/// This class is not meant to be used directly. Use `FDACache` instead.
final class InternalCache<I: AnyObject, T: AnyObject> where I: Hashable {

    // MARK: Properties
    private var cache: NSCache<I, T>
    private var cacheDelegateHandler: InternalCacheCacheHandler
    private var cancellables: Set<AnyCancellable> = []

    @Published var removedObject: T?

    // MARK: Lifecycle
    init(limit: Int = .zero) {
        cache = NSCache<I,T>()
        cache.countLimit = limit

        cacheDelegateHandler = InternalCacheCacheHandler()
        cache.delegate = cacheDelegateHandler

        bind()
    }

    deinit {
        unbind()
    }
}

// MARK: - Public
extension InternalCache {

    /// Sets the value of the specified key in the cache.
    /// - Parameters:
    ///  - key: The key with which to associate the value.
    /// - value: The value to set.
    func set(_ key: I, value: T) {
        cache.setObject(value, forKey: key)
    }

    /// Returns the value associated with a given key.
    /// - Parameters:
    /// - key: The key for which to return the corresponding value.
    /// - Returns: The value associated with key, or nil if no value is associated with key.
    func get(_ key: I) -> T? {
        cache.object(forKey: key)
    }

    /// Removes the value of the specified key in the cache.
    /// - Parameters:
    /// - key: The key with which to associate the value.
    func delete(_ key: I) {
        cache.removeObject(forKey: key)
    }

    /// Removes all values from the cache.
    func clean() {
        cache.removeAllObjects()
    }
}

// MARK: - Private
private extension InternalCache {

    /// Binds the cache delegate handler.
    func bind() {
        cacheDelegateHandler
            .$removedObject
            .sink { object in
                self.removedObject = object as? T
            }
            .store(in: &cancellables)
    }

    /// Unbinds the cache delegate handler.
    func unbind() {
        cancellables.removeAll()
    }
}

/// Internal cache cache handler.
/// This class is not meant to be used directly. Use `InternalCache` instead.
final class InternalCacheCacheHandler: NSObject, NSCacheDelegate {

    @Published var removedObject: Any?

    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        removedObject = obj
    }
}
