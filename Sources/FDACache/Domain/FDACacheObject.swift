import Foundation

/// FDACacheObject is a wrapper for the cached object.
/// It contains the date when the object was cached, and the object itself.
/// This class is not meant to be used directly. Use `FDACache` instead.
final class FDACacheObject {
    let date: Date = Date()
    let data: Any

    init(data: Any) {
        self.data = data
    }
}
