//
//  KenBurnsAPI.swift
//  Terrace
//
//  Created by Avery Lamp on 1/19/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

import Foundation
import UIKit

enum KenBurnsAPIError: Error {
  case unknownError(message: String?)
}

protocol KenBurnsAPI {
  func sendBaseImage(image: UIImage,
                     completion: @escaping(Result<String, KenBurnsAPIError>) -> Void)
}
