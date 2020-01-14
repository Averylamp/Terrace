//
//  PHImagePickerNavigationViewController.swift
//  Terrace
//
//  Created by Avery Lamp on 1/12/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

import UIKit
import Photos

class PHPhotoPickerNavigationViewController: UINavigationController {
  
  weak var pickerDelegate: PHPhotoPickerDelegate?  
  
  /// Factory method for creating this view controller.
  ///
  /// - Returns: Returns an instance of this view controller.
  class func instantiate(delegate: PHPhotoPickerDelegate? = nil) -> PHPhotoPickerNavigationViewController? {
    let vcName = String(describing: PHPhotoPickerNavigationViewController.self)
    let storyboard = R.storyboard.phPhotoPickerNavigationViewController
    guard let phImagePickerNavVC = storyboard.instantiateInitialViewController() else {
      fatalError("Unable to instantiate \(vcName)")
    }
    phImagePickerNavVC.pickerDelegate = delegate
    guard let listVC = PHPhotoPickerAlbumListViewController.instantiate(delegate: delegate) else {
      fatalError("Failed to instantiate album list view controlelr")
    }
    phImagePickerNavVC.setViewControllers([listVC], animated: false)
    return phImagePickerNavVC
  }
  
}

// MARK: Life Cycle
extension  PHPhotoPickerNavigationViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
    self.stylize()
  }
  
  /// Setup should only be called once
  func setup() {
    self.title = "Photo Albums"
  }
  
  /// Stylize should only be called once
  func stylize() {
    
  }
  
}
