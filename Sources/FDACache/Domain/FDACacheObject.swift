import Foundation

/// FDACacheObject is a wrapper for the cached object.
/// It contains the date when the object was cached, and the object itself.
/// This class is not meant to be used directly. Use `FDACache` instead.
final class FDACacheObject<T: Any> {
    let date: Date = Date()
    let data: T

    init(data: T) {
        self.data = data
    }
}
