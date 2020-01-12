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
    let pickerController = UIImagePickerController()
    pickerController.delegate  = self
    pickerController.sourceType = .photoLibrary
    self.present(pickerController, animated: true, completion: nil)
    
  }
  
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    
//    let image = info[.originalImage]
//    let url = info[.imageURL]
//    print("url=", url)
//
//    guard let source = CGImageSourceCreateWithURL(url as! CFURL, nil) else {
//      return
//    }
//
//    guard let auxDataInfo = CGImageSourceCopyAuxiliaryDataInfoAtIndex(source, 0, kCGImageAuxiliaryDataTypeDisparity) as? [AnyHashable: Any] else {
//      return
//    }
//
//    print("asdfadf")
//
    //    var phAsset: PHAsset?
    //    if let asset = info[.phAsset] as? PHAsset {
    //      PHImageManager.default().requestImageData(for: asset, options: nil) { (_, _, _, phInfo) in
    //        print("Here")
    //
    //        if let phAssetUTI = phInfo?["PHImageFileUTIKey"] as? String {
    //          print("phAssetUTI: \(phAssetUTI)")
    //        }
    //
    ////        guard let source = CGImageSourceCreateWithURL(url, nil) else {
    ////          return
    ////        }
    ////        guard let auxDataInfo = CGImageSourceCopyAuxiliaryDataInfoAtIndex(source, 0, kCGImageAuxiliaryDataTypeDisparity) as? [AnyHashable: Any] else {
    ////          return
    ////        }
    //      }
    //    }
    
    picker.dismiss(animated: true, completion: nil)
    
  }
  
}
