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
  
  weak var pickerDelegate: PHPhotoPickerDelegate?
  
  var photoCollectionItem: AlbumItem!
  var assetsInRow: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 4 : 8
  let collectionViewEdgeInset: CGFloat = 2
  let flowLayout = UICollectionViewFlowLayout()
  let cachingImageManager = PHCachingImageManager()
  fileprivate var imageAssets: [PHAsset]! {
    willSet {
      cachingImageManager.stopCachingImagesForAllAssets()
    }
    
    didSet {
      cachingImageManager.startCachingImages(for: self.imageAssets, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.aspectFill, options: nil)
    }
  }
  
  @IBOutlet weak var imageCollectionView: UICollectionView!
  @IBOutlet weak var numberPerRowSegmentedControl: UISegmentedControl!
  
  /// Factory method for creating this view controller.
  ///
  /// - Returns: Returns an instance of this view controller.
  class func instantiate(delegate: PHPhotoPickerDelegate? = nil, photosCollection: AlbumItem) -> PHPhotoPickerCollectionViewController? {
    let vcName = String(describing: PHPhotoPickerCollectionViewController.self)
    let storyboard = R.storyboard.phPhotoPickerCollectionViewController
    guard let vcPHImagePicker = storyboard.instantiateInitialViewController() else {
      fatalError("Unable to instantiate \(vcName)")
    }
    vcPHImagePicker.photoCollectionItem = photosCollection
    vcPHImagePicker.pickerDelegate = delegate
    return vcPHImagePicker
  }
  
  @IBAction func segmentedControllerChanged(_ sender: UISegmentedControl) {
    self.changeNumberPerRow()
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
    self.view.layoutIfNeeded()
    self.title = self.photoCollectionItem.albumResult.localizedTitle
    self.setupCollectionView()
  }
  
  func setupCollectionView() {
    self.imageCollectionView.delegate = self
    self.imageCollectionView.dataSource = self
    
    flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
    
    self.imageCollectionView.collectionViewLayout = flowLayout
    self.loadCollectionData()
  }
  
  /// Stylize should only be called once
  func stylize() {
    
  }
  
}

// MARK: IBActions
extension PHPhotoPickerCollectionViewController {
  
  func changeNumberPerRow() {
    let newNumberPerRowString = self.numberPerRowSegmentedControl.titleForSegment(at: self.numberPerRowSegmentedControl.selectedSegmentIndex)
    guard let newNumberPerRow = Int(newNumberPerRowString ?? "unknown") else {
      print("Unable to parse new number per row")
      return
    }
    self.assetsInRow = CGFloat(newNumberPerRow)
    
    let firstVisibleIndex = self.imageCollectionView.visibleCells.first?.tag
    self.loadCollectionData()
    if let validFirstIndex = firstVisibleIndex {
      self.imageCollectionView.scrollToItem(at: IndexPath(row: validFirstIndex, section: 0), at: .top, animated: true)
    }
  }
  
}

// MARK: UICollectionView
extension PHPhotoPickerCollectionViewController: UICollectionViewDataSource {
  
  func loadCollectionData() {
    let allAssetsFetch = PHAsset.fetchAssets(in: self.photoCollectionItem.albumResult, options: nil)
    self.imageAssets = allAssetsFetch.objects(at: IndexSet(integersIn: Range(NSRange(location: 0, length: allAssetsFetch.count))!))
    self.imageCollectionView.reloadData()
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.imageAssets.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.phPhotoCollectionViewCell.identifier,
                                                        for: indexPath) as? PHPhotoPickerCollectionViewCell else {
                                                          return UICollectionViewCell()
    }
    
    let currentTag: Int = indexPath.row
    cell.tag = currentTag
    
    let scale = UIScreen.main.scale
    let assetGridThumbnailSize = CGSize(width: cell.frame.size.width * scale, height: cell.frame.size.height * scale)
    self.cachingImageManager.requestImage(for: self.imageAssets[indexPath.row],
                                     targetSize: assetGridThumbnailSize,
                                     contentMode: .aspectFill,
                                     options: nil) { (image, _) in
      if cell.tag == currentTag {
        cell.imageView.image = image
      }
    }
    
    return cell
  }
    
}

extension PHPhotoPickerCollectionViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let edgeSize = (self.view.frame.size.width - assetsInRow * 1 - 2 * collectionViewEdgeInset) / assetsInRow
    return CGSize(width: edgeSize, height: edgeSize)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets.init(top: collectionViewEdgeInset, left: collectionViewEdgeInset, bottom: collectionViewEdgeInset, right: collectionViewEdgeInset)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
  
}

extension PHPhotoPickerCollectionViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("Collection View selected item at: \(indexPath.item)")
    let asset = self.imageAssets[indexPath.item]
    if let delegate = self.pickerDelegate {
      delegate.pickerDidSelectPHImage(asset: asset)
    }
    self.navigationController?.dismiss(animated: true, completion: nil)
  }
  
}
