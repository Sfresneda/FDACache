import Foundation

/// FDACache errors.
public enum FDACacheError: Error {

    /// The item was not found in the cache.
    case notFound

    /// The item was found but could not be parsed.
    case nonParseable

    /// Unknown error.
    case unknown
}
