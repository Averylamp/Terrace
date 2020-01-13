//
//  PHImagePickerViewController.swift
//  Terrace
//
//  Created by Avery Lamp on 1/12/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

import UIKit
import Photos

class PHPhotoPickerCollectionViewController: UIViewController {
  
  weak var pickerDelegate: PHImagePickerDelegate?
  
  var photoCollectionItem: AlbumItem!
  
  @IBOutlet weak var imageCollectionView: UICollectionView!
  
  /// Factory method for creating this view controller.
  ///
  /// - Returns: Returns an instance of this view controller.
  class func instantiate(delegate: PHImagePickerDelegate? = nil, photosCollection: AlbumItem) -> PHPhotoPickerCollectionViewController? {
    let vcName = String(describing: PHPhotoPickerCollectionViewController.self)
    let storyboard = R.storyboard.phPhotoPickerCollectionViewController
    guard let vcPHImagePicker = storyboard.instantiateInitialViewController() else {
      fatalError("Unable to instantiate \(vcName)")
    }
    vcPHImagePicker.photoCollectionItem = photosCollection
    vcPHImagePicker.pickerDelegate = delegate
    return vcPHImagePicker
  }
  
}

// MARK: Life Cycle
extension  PHPhotoPickerCollectionViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
    self.stylize()
  }
  
  /// Setup should only be called once
  func setup() {
    self.title = self.photoCollectionItem.albumResult.localizedTitle
  }
  
  /// Stylize should only be called once
  func stylize() {
    
  }
  
}
