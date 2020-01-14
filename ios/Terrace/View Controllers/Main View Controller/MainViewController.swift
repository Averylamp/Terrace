//
//  ViewController.swift
//  imagear
//
//  Created by Avery Lamp on 1/9/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

import UIKit
import Photos

class MainViewController: UIViewController {
  
  @IBOutlet weak var firstImageView: UIImageView!
  @IBOutlet weak var secondImageView: UIImageView!
  
  /// Factory method for creating this view controller.
  ///
  /// - Returns: Returns an instance of this view controller.
  class func instantiate() -> MainViewController? {
    let vcName = String(describing: MainViewController.self)
    let storyboard = R.storyboard.mainViewController
    guard let vcMain = storyboard.instantiateInitialViewController() else {
      fatalError("Unable to instantiate \(vcName)")
    }
    return vcMain
  }
  
}

// MARK: Life Cycle
extension  MainViewController {
  
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

// MARK: IBActions
extension MainViewController {
  
  @IBAction func clickedLibraryButton(_ sender: UIButton) {
    guard let pickerController = PHPhotoPickerNavigationViewController.instantiate(delegate: self) else {
      fatalError("Failed to create picker controller")
    }
    pickerController.pickerDelegate = self
    
    self.present(pickerController, animated: true, completion: nil)
  }
  
}

// MARK: PHPhotoPickerDelegate
extension MainViewController: PHPhotoPickerDelegate {
  func pickerDidSelectPHImage(asset: PHAsset) {
    print("Found image")
    asset.doesContainImageDisparityMap { (containsImageDisparity) in
      if containsImageDisparity {
        print("Image contains disparity")
      } else {
        print("Image does not contain disparity")
      }
    }
    asset.doesContainImageDepthMap { (containsImageDepthMap) in
      if containsImageDepthMap {
        print("Image contains depth map")
      } else {
        print("Image does not contain depth map")
      }
    }
    
  }
}
