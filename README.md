# FDACache

FDACache is a Swift 5.8 library for making network requests. It provides a simple and clean API for caching objects in memory.

## Installation
Add this SPM dependency to your project:
```
https://github.com/Sfresneda/FDACache
```

## Usage
Here's an example of how to use FDACache:

```swift
import FDACache

let cache = FDACache()
await cache.set("foo", value: Foo())

let cachedFoo: Foo = try await cache.get("foo")
```

## License
This project is licensed under the Apache License - see the [LICENSE](LICENSE) file for details

## Author
Sergio Fresneda - [sfresneda](https://github.com/Sfresneda)
