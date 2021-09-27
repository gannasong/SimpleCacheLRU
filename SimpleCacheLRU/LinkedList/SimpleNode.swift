//
//  SimpleNode.swift
//  SimpleCacheLRU
//
//  Created by SUNG HAO LIN on 2021/9/27.
//

import Foundation

public class SimpleNode<T> {
  public var value: T
  public var next: SimpleNode?
  // To avoid ownership cycles, declare the previous pointer to be weak.
  public weak var previous: SimpleNode?

  // MARK: - Initialization
  public init(value: T) {
    self.value = value
  }
}
