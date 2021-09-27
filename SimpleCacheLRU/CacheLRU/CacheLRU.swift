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

  // MARK: - Initialization

  public init(capacity: Int) {
    self.capacity = max(0, capacity)
  }

  // MARK: - Public Methods

  public func getValue(for key: Key) -> Value? {
    guard let node = nodesDict[key] else { return nil }

    list.moveToHead(node)

    return node.value.value
  }

  public func setValue(_ value: Value, for key: Key) {
    let payload = CachePayload(key: key, value: value)

    if let node = nodesDict[key] {
      node.value = payload
      list.moveToHead(node)
    } else {
      let node = list.addHead(value: payload)
      nodesDict[key] = node
    }

    if list.count > capacity {
      let nodeRemoved = list.removeLast()
      if let key = nodeRemoved?.key {
        nodesDict[key] = nil
      }
    }
  }

  // MARK: - Private Methods

  private struct CachePayload {
    let key: Key
    let value: Value
  }
}
