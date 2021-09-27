# SimpleCacheLRU

## Introduction
**SimpleCacheLRU** is a pure Swift Least Recently Used "LRU" Cache. Older items that have not been recently used are discarded from the cache. The time, space complexity is O(1) and thanks to generics any values can be stored.

## Usage
You can create an instance of SimpleCacheLRU and set max capacity as follows:
```swift
let cache = CacheLRU<URL, UIImage>(capacity: 10)
```
To add a value to the cache, use:
```swift
cache.setValue(image, for: url)
```
To fetch a cached value, use:
```swift
let cacheImage = cache.getValue(for: url)
```

## TODO
- [X] concurrency
- [X] read-write-lock
