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
  @IBOutlet weak var ratioSegmentedControl: UISegmentedControl!
  
  var fullAsset: PHAsset!
  var assetImage: UIImage?
  var effectRatio: CGFloat = 1.0
  var fullImageFrame: CGRect = CGRect.zero
  
  let firstFrameCropper: KBFrameCropView = KBFrameCropView(frame: CGRect.zero)
  let secondFrameCropper: KBFrameCropView = KBFrameCropView(frame: CGRect.zero)
  
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
  
  @IBAction func ratioSegmentedControllerChanged(_ sender: Any) {
    self.segmentedControlChangedHandler()
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
    self.fullImageFrame = self.imageView.frame
    var frameOffset: CGFloat = 30
    self.imageView.addSubview(self.firstFrameCropper)
    self.imageView.addSubview(self.secondFrameCropper)
    self.firstFrameCropper.translatesAutoresizingMaskIntoConstraints = false
    self.secondFrameCropper.translatesAutoresizingMaskIntoConstraints = false
    self.firstFrameCropper.leftConstraint = NSLayoutConstraint(item: self.firstFrameCropper, attribute: .left, relatedBy: .equal,
                                                               toItem: self.imageView, attribute: .left, multiplier: 1.0, constant: frameOffset)
    self.firstFrameCropper.topConstraint = NSLayoutConstraint(item: self.firstFrameCropper, attribute: .top, relatedBy: .equal,
                                                              toItem: self.imageView, attribute: .top, multiplier: 1.0, constant: frameOffset)
    self.firstFrameCropper.rightConstraint = NSLayoutConstraint(item: self.firstFrameCropper, attribute: .right, relatedBy: .equal,
                                                                toItem: self.imageView, attribute: .right, multiplier: 1.0, constant: -frameOffset)
    self.firstFrameCropper.bottomConstraint = NSLayoutConstraint(item: self.firstFrameCropper, attribute: .bottom, relatedBy: .equal,
                                                                 toItem: self.imageView, attribute: .bottom, multiplier: 1.0, constant: -frameOffset)
    self.imageView.addConstraints([
      self.firstFrameCropper.leftConstraint!,
      self.firstFrameCropper.topConstraint!,
      self.firstFrameCropper.rightConstraint!,
      self.firstFrameCropper.bottomConstraint!
    ])
    frameOffset += 30

    self.secondFrameCropper.leftConstraint = NSLayoutConstraint(item: self.secondFrameCropper, attribute: .left, relatedBy: .equal,
                                                               toItem: self.imageView, attribute: .left, multiplier: 1.0, constant: frameOffset)
    self.secondFrameCropper.topConstraint = NSLayoutConstraint(item: self.secondFrameCropper, attribute: .top, relatedBy: .equal,
                                                              toItem: self.imageView, attribute: .top, multiplier: 1.0, constant: frameOffset)
    self.secondFrameCropper.rightConstraint = NSLayoutConstraint(item: self.secondFrameCropper, attribute: .right, relatedBy: .equal,
                                                                toItem: self.imageView, attribute: .right, multiplier: 1.0, constant: -frameOffset)
    self.secondFrameCropper.bottomConstraint = NSLayoutConstraint(item: self.secondFrameCropper, attribute: .bottom, relatedBy: .equal,
                                                                 toItem: self.imageView, attribute: .bottom, multiplier: 1.0, constant: -frameOffset)
    self.imageView.addConstraints([
      self.secondFrameCropper.leftConstraint!,
      self.secondFrameCropper.topConstraint!,
      self.secondFrameCropper.rightConstraint!,
      self.secondFrameCropper.bottomConstraint!
    ])
  }
  
  /// Stylize should only be called once
  func stylize() {
    self.title = "Ken Burns Editor"
    
  }
  
}

// MARK: IBActions
extension KBCropEditorViewController {
  
  func segmentedControlChangedHandler() {
    if let ratioString = self.ratioSegmentedControl.titleForSegment(at: self.ratioSegmentedControl.selectedSegmentIndex) {
      let ratioComponents = ratioString.components(separatedBy: ":")
      if ratioComponents.count != 2 {
        return
      }
      guard let ratioWidth = Int(ratioComponents[0]),
        let ratioHeight = Int(ratioComponents[1]) else {
          return
      }
      let ratio = CGFloat(ratioWidth) / CGFloat(ratioHeight)
      self.changeEffectRatio(ratio: ratio)
    }
  }
  
}

// MARK: Effect Handlers
extension KBCropEditorViewController {
  
  func changeEffectRatio(ratio: CGFloat) {
    self.effectRatio = ratio
    
  }
  
}
