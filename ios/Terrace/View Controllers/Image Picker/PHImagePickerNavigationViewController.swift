//
//  PHImagePickerNavigationViewController.swift
//  Terrace
//
//  Created by Avery Lamp on 1/12/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

import UIKit

class PHImagePickerNavigationViewController: UINavigationController {
  
  /// Factory method for creating this view controller.
  ///
  /// - Returns: Returns an instance of this view controller.
  class func instantiate() -> PHImagePickerNavigationViewController? {
    let vcName = String(describing: PHImagePickerNavigationViewController.self)
    let storyboard = R.storyboard.phImagePickerNavigationViewController
    guard let phImagePickerNavVC = storyboard.instantiateInitialViewController() else {
      fatalError("Unable to instantiate \(vcName)")
    }
    return phImagePickerNavVC
  }
  
}

// MARK: Life Cycle
extension  PHImagePickerNavigationViewController {
  
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
