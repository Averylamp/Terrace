//
//  KBNavigationController.swift
//  Terrace
//
//  Created by Avery Lamp on 1/15/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

import UIKit
import Photos

class KBNavigationController: UINavigationController {
  
  /// Factory method for creating this view controller.
  ///
  /// - Returns: Returns an instance of this view controller.
  class func instantiate(asset: PHAsset) -> KBNavigationController? {
    let vcName = String(describing: KBNavigationController.self)
    let storyboard = R.storyboard.kbNavigationController
    guard let kbNaviagationController = storyboard.instantiateInitialViewController() else {
      fatalError("Unable to instantiate \(vcName)")
    }
    guard let kbCropVC = KBCropEditorViewController.instantiate(asset: asset) else {
      fatalError("Unable to instantiate KB Crop VC")
    }
    kbNaviagationController.setViewControllers([kbCropVC], animated: false)
    return kbNaviagationController
  }
  
}

// MARK: Life Cycle
extension  KBNavigationController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
    self.stylize()
  }
  
  /// Setup should only be called once
  func setup() {
    
  }
  
  /// Stylize should only be called once
  func stylize() {
    
  }
  
}
