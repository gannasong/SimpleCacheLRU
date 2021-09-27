//
//  SimpleLinkedList.swift
//  SimpleCacheLRU
//
//  Created by SUNG HAO LIN on 2021/9/27.
//

import Foundation

public class SimpleLinkedList<T> {
  public typealias Node = SimpleNode<T>
  public private(set) var count: Int = 0

  private var head: Node?
  private var tail: Node?

  public var isEmpty: Bool {
    return head == nil
  }

  // MARK: - Initialization

  public init() {}

  // MARK: - Public Methods

  func addHead(value: T) -> Node {
    let newNode = Node(value: value)

    defer {
      head = newNode
      count += 1
    }

    guard let headNode = head else {
      tail = newNode
      return newNode
    }

    headNode.previous = newNode
    newNode.previous = nil
    newNode.next = headNode
    return newNode
  }

  public func moveToHead(_ node: Node) {
    guard node !== head else { return }
    let prev = node.previous
    let next = node.next

    prev?.next = next
    next?.previous = prev

    node.next = head
    node.previous = nil

    if node === tail {
      tail = prev
    }

    self.head = node
  }

  public func removeLast() -> T? {
    guard count > 0 else { return nil }
    return remove(node: tail!)
  }

  // MARK: - Private Methods

  private func remove(node: Node) -> T {
    let prev = node.previous
    let next = node.next

    if let prev = prev {
      prev.next = next
    } else {
      head = next
    }

    next?.previous = prev

    if next == nil {
      tail = prev
    }

    node.previous = nil
    node.next = nil
    count -= 1

    return node.value
  }
}
