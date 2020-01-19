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
  @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var ratioSegmentedControl: UISegmentedControl!
  @IBOutlet weak var frameSegmentedControl: UISegmentedControl!
  
  var fullAsset: PHAsset!
  var assetImage: UIImage?
  var effectRatio: CGFloat = 1.0

  var firstFrameCropper: KBFrameCropView = KBFrameCropView()
  var secondFrameCropper: KBFrameCropView = KBFrameCropView()
  var panGestureRecognizer: UIPanGestureRecognizer?
  
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
  
  @IBAction func frameSegmentedControlChanged(_ sender: Any) {
    self.frameSelectedChanged()
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
    
    self.imageViewWidthConstraint.isActive = false
    let ratioConstraint = NSLayoutConstraint(item: self.imageView, attribute: .width, relatedBy: .equal,
                                             toItem: self.imageView, attribute: .height,
                                             multiplier: CGFloat(self.fullAsset.pixelWidth) / CGFloat(self.fullAsset.pixelHeight), constant: 0.0)
    self.imageView.addConstraint(ratioConstraint)
    self.view.layoutIfNeeded()
    
    self.firstFrameCropper.setupKBFrameView()
    self.secondFrameCropper.setupKBFrameView()
    self.imageView.addSubview(self.firstFrameCropper)
    self.firstFrameCropper.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
    self.imageView.addSubview(self.secondFrameCropper)
    self.firstFrameCropper.translatesAutoresizingMaskIntoConstraints = false
    self.secondFrameCropper.translatesAutoresizingMaskIntoConstraints = false
    
    let imageViewSize = self.imageView.frame.size
    let minSide = min(imageViewSize.width, imageViewSize.height)
    let firstSize = minSide / 2.0 * 0.9
    let secondSize = minSide / 2.0 * 0.8
    self.firstFrameCropper.leftConstraint = NSLayoutConstraint(item: self.firstFrameCropper, attribute: .left, relatedBy: .equal,
                                                               toItem: self.imageView, attribute: .left, multiplier: 1.0, constant: imageViewSize.width / 2 - firstSize)
    self.firstFrameCropper.topConstraint = NSLayoutConstraint(item: self.firstFrameCropper, attribute: .top, relatedBy: .equal,
                                                              toItem: self.imageView, attribute: .top, multiplier: 1.0, constant: imageViewSize.height / 2 - firstSize)
    self.firstFrameCropper.rightConstraint = NSLayoutConstraint(item: self.firstFrameCropper, attribute: .right, relatedBy: .equal,
                                                                toItem: self.imageView, attribute: .right, multiplier: 1.0, constant: -(imageViewSize.width / 2 - firstSize))
    self.firstFrameCropper.bottomConstraint = NSLayoutConstraint(item: self.firstFrameCropper, attribute: .bottom, relatedBy: .equal,
                                                                 toItem: self.imageView, attribute: .bottom, multiplier: 1.0, constant: -(imageViewSize.height / 2 - firstSize))
    self.imageView.addConstraints([
      self.firstFrameCropper.leftConstraint!,
      self.firstFrameCropper.topConstraint!,
      self.firstFrameCropper.rightConstraint!,
      self.firstFrameCropper.bottomConstraint!
    ])

    self.secondFrameCropper.leftConstraint = NSLayoutConstraint(item: self.secondFrameCropper, attribute: .left, relatedBy: .equal,
                                                               toItem: self.imageView, attribute: .left, multiplier: 1.0, constant: imageViewSize.width / 2 - secondSize)
    self.secondFrameCropper.topConstraint = NSLayoutConstraint(item: self.secondFrameCropper, attribute: .top, relatedBy: .equal,
                                                              toItem: self.imageView, attribute: .top, multiplier: 1.0, constant: imageViewSize.height / 2 - secondSize)
    self.secondFrameCropper.rightConstraint = NSLayoutConstraint(item: self.secondFrameCropper, attribute: .right, relatedBy: .equal,
                                                                toItem: self.imageView, attribute: .right, multiplier: 1.0, constant: -(imageViewSize.width / 2 - secondSize))
    self.secondFrameCropper.bottomConstraint = NSLayoutConstraint(item: self.secondFrameCropper, attribute: .bottom, relatedBy: .equal,
                                                                 toItem: self.imageView, attribute: .bottom, multiplier: 1.0, constant: -(imageViewSize.height / 2 - secondSize))
    self.imageView.addConstraints([
      self.secondFrameCropper.leftConstraint!,
      self.secondFrameCropper.topConstraint!,
      self.secondFrameCropper.rightConstraint!,
      self.secondFrameCropper.bottomConstraint!
    ])
    self.firstFrameCropper.setSelected(selected: true)
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
      self.firstFrameCropper.setRatio(ratio: ratio)
      self.secondFrameCropper.setRatio(ratio: ratio)
    }
  }
  
  func frameSelectedChanged() {
    let frameTitle = self.frameSegmentedControl.titleForSegment(at: self.frameSegmentedControl.selectedSegmentIndex)
    if frameTitle == "First" {
      self.firstFrameCropper.setSelected(selected: true)
      self.secondFrameCropper.setSelected(selected: false)
    } else if frameTitle == "Second"{
      self.firstFrameCropper.setSelected(selected: false)
      self.secondFrameCropper.setSelected(selected: true)
    }
  }
}

// MARK: Effect Handlers
extension KBCropEditorViewController {
  
  func changeEffectRatio(ratio: CGFloat) {
    self.effectRatio = ratio
    
  }
  
}
