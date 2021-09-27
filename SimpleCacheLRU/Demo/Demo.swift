//
//  Demo.swift
//  SimpleCacheLRU
//
//  Created by SUNG HAO LIN on 2021/9/27.
//

import Foundation

/*
 * Just sudo code ...
 */
protocol AnyLoader {
  func load(url: URL, completion: @escaping (String) -> Void)
}

class AnyStore {
  private let loader: AnyLoader
  private let imageStore = CacheLRU<URL, String>(capacity: 10)

  init(loader: AnyLoader) {
    self.loader = loader
  }

  func fetch(_ url: URL, completion: @escaping (String) -> Void) {
    if let cacheImage = imageStore.getValue(for: url) {
      completion(cacheImage)
    } else {
      loader.load(url: url) { [weak self] image in
        self?.imageStore.setValue(image, for: url)
        completion(image)
      }
    }
  }
}
