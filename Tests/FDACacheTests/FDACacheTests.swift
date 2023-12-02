import XCTest
@testable import FDACache

final class FDACacheTests: XCTestCase {
    var sut: FDACache<Foo>!

    override func setUpWithError() throws {
        sut = FDACache<Foo>()
    }

    override func tearDownWithError() throws {
        sut = nil
    }


    // MARK: - Get
    func test_get_decodableShouldThrowAnError() async {
        // Given
        let key = "foo"

        // When
        do {
            let result: Foo = try await sut.get(key, transform: {
                $0.bar.data(using: .utf8)
            })
            XCTFail("Unexpected result \(result)")
        } catch {
            // Then
            XCTAssertEqual(FDACacheError.notFound, error as? FDACacheError)
        }
    }

    func test_get_decodableShouldSucceed() async throws {
        // Given
        let key = "foo"
        let value = Foo(bar: "baz")

        // When
        await sut.set(key, value: value)

        let result = await sut.get(key)

        // Then
        XCTAssertEqual(value, result)
    }

    func test_get_decodableWithNilDataTransformShouldFail() async {
        // Given
        let key = "foo"
        let value = Foo(bar: "baz")

        // When
        await sut.set(key as String, value: value)

        do {
            let _: Foo = try await sut.get(key as String, transform: { _ in nil })
            XCTFail("Unexpected result")
        } catch {
            // Then
            XCTAssertEqual(FDACacheError.nonParseable, error as? FDACacheError)
        }
    }




}


/*

 */
