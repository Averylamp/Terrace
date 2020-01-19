//
//  KenBurnsPreviewViewController.swift
//  Terrace
//
//  Created by Avery Lamp on 1/15/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

import UIKit

class KBPreviewViewController: UIViewController {
  
  /// Factory method for creating this view controller.
  ///
  /// - Returns: Returns an instance of this view controller.
  class func instantiate() -> KBPreviewViewController? {
    let vcName = String(describing: KBPreviewViewController.self)
    let storyboard = R.storyboard.kbPreviewViewController
    guard let kbPreviewVC = storyboard.instantiateInitialViewController() else {
      fatalError("Unable to instantiate \(vcName)")
    }
    return kbPreviewVC
  }
  
}

// MARK: Life Cycle
extension  KBPreviewViewController {
  
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
