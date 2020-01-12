//
//  PHImagePickerViewController.swift
//  Terrace
//
//  Created by Avery Lamp on 1/12/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

import UIKit

class PHImagePickerViewController: UIViewController {
  
  /// Factory method for creating this view controller.
  ///
  /// - Returns: Returns an instance of this view controller.
  class func instantiate() -> PHImagePickerViewController? {
    let vcName = String(describing: PHImagePickerViewController.self)
    let storyboard = R.storyboard.phImagePickerViewController
    guard let vcPHImagePicker = storyboard.instantiateInitialViewController() else {
      fatalError("Unable to instantiate \(vcName)")
    }
    return vcPHImagePicker
  }
  
}

// MARK: Life Cycle
extension  PHImagePickerViewController {
  
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
