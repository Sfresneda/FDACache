import XCTest
@testable import FDACache

final class FDAInternalCacheTests: XCTestCase {
    var sut: InternalCache<NSString>!

    override func setUp() {
        sut = InternalCache(limit: 1, lifeTime: 600.0)
    }
    
    override func tearDown() {
        sut = nil
    }

    // MARK: - Set

    func test_set_andGetShouldSucceed() {
        // Given
        let key: NSString = "foo"
        let value: NSString = "bar"

        // When
        sut.set(key, value: value)
        let result = sut.get(key) as? FDACacheObject

        // Then

        XCTAssertEqual(value, result?.data as? NSString)
    }
    
    func test_set_andGetWrongValueShouldReturnNil() {
        // Given
        let key: NSString = "foo"
        let value: NSString = "bar"
        let wrongKey: NSString = "baz"

        // When
        sut.set(key, value: value)
        let result = sut.get(wrongKey)

        // Then
        XCTAssertNil(result)
    }

    // MARK: - Get

    func test_get_withOutSetShouldReturnNil() {
        // Given
        let key: NSString = "foo"

        // When
        let result = sut.get(key)

        // Then
        XCTAssertNil(result)
    }

    // MARK: - Delete

    func test_delete_shouldSuceed() {
        // Given
        let key: NSString = "foo"
        let value: NSString = "bar"

        // When
        sut.set(key, value: value)
        let result = sut.get(key)
        
        sut.delete(key)
        let result2 = sut.get(key)

        // Then
        XCTAssertNotNil(result)
        XCTAssertNil(result2)
    }

    // MARK: - Clean

    func test_clean_shouldSucceed() {
        // Given
        let key: NSString = "foo"
        let value: NSString = "bar"

        // When
        sut.set(key, value: value)
        let result = sut.get(key)
        
        sut.clean()
        let result2 = sut.get(key)

        // Then
        XCTAssertNotNil(result)
        XCTAssertNil(result2)
    }

    // MARK: - Lifetime
    func test_get_outdate_shouldFail() {
        // Given
        let key: NSString = "foo"
        let value: NSString = "bar"
        let sut = InternalCache<NSString>(limit: 1,
                                          lifeTime: -1)
        // When
        sut.set(key, value: value)
        let result = sut.get(key)

        // Then
        XCTAssertNil(result)
    }
}
