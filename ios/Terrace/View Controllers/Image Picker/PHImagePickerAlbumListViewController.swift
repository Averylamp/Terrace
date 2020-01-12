//
//  PHImagePickerAlbumListViewController.swift
//  Terrace
//
//  Created by Avery Lamp on 1/12/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

import UIKit

class PHImagePickerAlbumListViewController: UIViewController {
  
  /// Factory method for creating this view controller.
  ///
  /// - Returns: Returns an instance of this view controller.
  class func instantiate() -> PHImagePickerAlbumListViewController? {
    let vcName = String(describing: PHImagePickerAlbumListViewController.self)
    let storyboard = R.storyboard.phImagePickerAlbumListViewController
    guard let vcPHImageAlbumList = storyboard.instantiateInitialViewController() else {
      fatalError("Unable to instantiate \(vcName)")
    }
    return vcPHImageAlbumList
  }
  
}

// MARK: Life Cycle
extension  PHImagePickerAlbumListViewController {
  
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
