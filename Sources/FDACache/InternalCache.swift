import Combine
import Foundation

/// Internal cache.
/// This class is not thread safe. It is the responsibility of the caller
/// to ensure thread safety.
/// This class is not meant to be used directly. Use `FDACache` instead.
final class InternalCache<I: AnyObject> where I: Hashable {

    // MARK: Properties
    private var cache: NSCache<I, FDACacheObject>
    private let lifeTime: TimeInterval

    // MARK: Lifecycle
    init(limit: Int,
         lifeTime: TimeInterval) {
        cache = NSCache<I,FDACacheObject>()
        cache.countLimit = limit
        self.lifeTime = lifeTime
    }
}

// MARK: - Public
extension InternalCache {

    /// Sets the value of the specified key in the cache.
    /// - Parameters:
    ///  - key: The key with which to associate the value.
    /// - value: The value to set.
    func set(_ key: I, value: Any) {
        let object = FDACacheObject(data: value)
        cache.setObject(object, forKey: key)
    }

    /// Returns the value associated with a given key.
    /// - Parameters:
    /// - key: The key for which to return the corresponding value.
    /// - Returns: The value associated with key, or nil if no value is associated with key.
    func get(_ key: I) -> Any? {
        let result = cache.object(forKey: key)

        guard let result,
              Date() < result.date.addingTimeInterval(lifeTime) else {
            delete(key)
            return nil
        }

        return result
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
