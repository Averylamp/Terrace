//
//  KBCropEditorViewController.swift
//  Terrace
//
//  Created by Avery Lamp on 1/15/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

import UIKit
import Photos

class KBCropEditorViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
  
  var fullAsset: PHAsset!
  var assetImage: UIImage?
  
  /// Factory method for creating this view controller.
  ///
  /// - Returns: Returns an instance of this view controller.
  class func instantiate(asset: PHAsset) -> KBCropEditorViewController? {
    let vcName = String(describing: KBCropEditorViewController.self)
    let storyboard = R.storyboard.kbCropEditorViewController
    guard let kbCropEditorVC = storyboard.instantiateInitialViewController() else {
      fatalError("Unable to instantiate \(vcName)")
    }
    kbCropEditorVC.fullAsset = asset
    let imageRequestOption = PHImageRequestOptions()
    imageRequestOption.isSynchronous = true
    PHImageManager.default().requestImage(for: asset,
                                          targetSize: CGSize(width: UIScreen.main.bounds.width * UIScreen.main.scale, height: 2),
                                          contentMode: .aspectFill,
                                          options: imageRequestOption) { (image, _) in
      kbCropEditorVC.assetImage = image
    }
    return kbCropEditorVC
  }
  
}

// MARK: Life Cycle
extension  KBCropEditorViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
    self.stylize()
  }
  
  /// Setup should only be called once
  func setup() {
    print("Asset Size: \(self.fullAsset.pixelWidth) x \(self.fullAsset.pixelHeight)")
    print("Image Size: \(String(describing: self.assetImage?.size))")
    self.imageView.image = self.assetImage
    self.imageViewHeight.constant = CGFloat(self.fullAsset.pixelHeight) / CGFloat(self.fullAsset.pixelWidth) * self.view.frame.width
    self.view.layoutIfNeeded()
    
  }
  
  /// Stylize should only be called once
  func stylize() {
    
  }
  
}
