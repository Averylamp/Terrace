//
//  TerraceKenBurnsAPI.swift
//  Terrace
//
//  Created by Avery Lamp on 1/19/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

import Foundation
import SwiftyJSON

class TerraceKenBurnsAPI: KenBurnsAPI {
  
  static let shared = TerraceKenBurnsAPI()
  
  private init() {
  }
  
}

extension TerraceKenBurnsAPI {
  
  func sendBaseImage(image: UIImage, completion: @escaping (Result<String, KenBurnsAPIError>) -> Void) {
    completion(.failure(.unknownError(message: "Unimplemented")))
  }
  
}
