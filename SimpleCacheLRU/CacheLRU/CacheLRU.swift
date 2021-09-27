//
//  CacheLRU.swift
//  SimpleCacheLRU
//
//  Created by SUNG HAO LIN on 2021/9/27.
//

import Foundation

public final class CacheLRU<Key: Hashable, Value> {
  private let list = SimpleLinkedList<CachePayload>()
  private var nodesDict = [Key: SimpleLinkedList<CachePayload>.Node]()
  private let capacity: Int
  private let concurrentQueue = DispatchQueue.init(label: "com.cacheLRU.queue", attributes: .concurrent)
  private var isFull: Bool {
    return nodesDict.count >= capacity
  }

  // MARK: - Initialization

  public init(capacity: Int) {
    self.capacity = max(0, capacity)
  }

  // MARK: - Public Methods

  public func getValue(for key: Key) -> Value? {
    return safeGetValue(for: key)
  }

  public func setValue(_ value: Value, for key: Key) {
    safeSetValue(value, for: key)
  }

  // MARK: - Private Methods

  private struct CachePayload {
    let key: Key
    let value: Value
  }
}

private extension CacheLRU {
  func safeGetValue(for key: Key) -> Value? {
    var value: Value?
    concurrentQueue.sync {
      if let node = nodesDict[key] {
        value = node.value.value
        list.moveToHead(node)
      }
    }
    return value
  }

  func safeSetValue(_ value: Value, for key: Key) {
    concurrentQueue.async(flags: .barrier) { [weak self] in
      let payload = CachePayload(key: key, value: value)

      if let node = self?.nodesDict[key] {
        node.value = payload
        self?.list.moveToHead(node)
      } else {
        let node = self?.list.addHead(value: payload)
        self?.nodesDict[key] = node
      }

      if let isCacheFull = self?.isFull, isCacheFull == true {
        let nodeRemoved = self?.list.removeLast()
        if let key = nodeRemoved?.key {
          self?.nodesDict[key] = nil
        }
      }
    }
  }
}
