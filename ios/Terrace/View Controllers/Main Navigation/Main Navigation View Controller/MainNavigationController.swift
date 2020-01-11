//
//  MainNavigationViewController.swift
//  Terrace
//
//  Created by Avery Lamp on 1/10/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
  
  /// Factory method for creating this view controller.
  ///
  /// - Returns: Returns an instance of this view controller.
  class func instantiate() -> MainNavigationController? {
    let vcName = String(describing: MainNavigationController.self)
    let storyboard = R.storyboard.mainNavigationController
    guard let vcMainNav = storyboard.instantiateInitialViewController() else {
      fatalError("Unable to instantiate \(vcName)")
    }
    return vcMainNav
  }
  
}
