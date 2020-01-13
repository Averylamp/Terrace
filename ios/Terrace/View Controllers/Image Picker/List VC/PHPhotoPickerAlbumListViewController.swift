//
//  PHImagePickerAlbumListViewController.swift
//  Terrace
//
//  Created by Avery Lamp on 1/12/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

import UIKit
import Photos

struct AlbumSection {
  var albumItems: [AlbumItem]
  let sectionTitle: String
}

struct AlbumItem {
  let name: String
  let count: Int
  let albumResult: PHAssetCollection
}

class PHPhotoPickerAlbumListViewController: UIViewController {
  
  weak var pickerDelegate: PHImagePickerDelegate?
  
  var allAlbumSections: [AlbumSection] = []
  
  @IBOutlet weak var albumTableView: UITableView!
  
  /// Factory method for creating this view controller.
  ///
  /// - Returns: Returns an instance of this view controller.
  class func instantiate(delegate: PHImagePickerDelegate? = nil) -> PHPhotoPickerAlbumListViewController? {
    let vcName = String(describing: PHPhotoPickerAlbumListViewController.self)
    let storyboard = R.storyboard.phPhotoPickerAlbumListViewController
    guard let vcPHImageAlbumList = storyboard.instantiateInitialViewController() else {
      fatalError("Unable to instantiate \(vcName)")
    }
    vcPHImageAlbumList.pickerDelegate = delegate
    return vcPHImageAlbumList
  }
  
}

// MARK: Life Cycle
extension  PHPhotoPickerAlbumListViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
    self.stylize()
  }
  
  /// Setup should only be called once
  func setup() {
    self.albumTableView.dataSource = self
    self.albumTableView.delegate = self
    self.loadTableData()
  }
  
  /// Stylize should only be called once
  func stylize() {
    
  }
  
}

// MARK: UITableViewDelegate
extension PHPhotoPickerAlbumListViewController: UITableViewDataSource {
  
  func loadTableData() {
    self.allAlbumSections.removeAll()
    var allAlbums: [AlbumItem]  = []
    
    var nativeAlbumCollection: [PHAssetCollection] = []
    let nativeAlbumns = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
    for index in 0..<nativeAlbumns.count {
      let album = nativeAlbumns[index]
      nativeAlbumCollection.append(album)
    }
    
//    Adds all native albums
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: true)]

    let albums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
    let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: fetchOptions)

    [albums, smartAlbums].forEach {
      $0.enumerateObjects { collection, _, _ in
        let count = PHAsset.fetchAssets(in: collection, options: nil).count
        if count == 0 {
          return
        }
        print("Adding found album")
        allAlbums.append(AlbumItem(name: collection.localizedTitle ?? "Test", count: count, albumResult: collection))
      }
    }
    var nativeSection = AlbumSection(albumItems: allAlbums.filter({ (nCollection) -> Bool in
      return !nativeAlbumCollection.contains { (oCollection) -> Bool in
        nCollection.albumResult.localizedTitle == oCollection.localizedTitle
      }
    }), sectionTitle: "Native Collections")
    nativeSection.albumItems.sort(by: {$0.count > $1.count})
    var otherSection =  AlbumSection(albumItems: allAlbums.filter({ (nCollection) -> Bool in
         return nativeAlbumCollection.contains { (oCollection) -> Bool in
           nCollection.albumResult.localizedTitle == oCollection.localizedTitle
         }
       }), sectionTitle: "Other Albums")
    otherSection.albumItems.sort(by: {$0.count > $1.count})
    self.allAlbumSections.append(contentsOf: [nativeSection, otherSection])
//    let depthAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.smartAlbumDepthEffect, options: nil)
//
//    for index in 0..<depthAlbums.count {
//      let album = depthAlbums[index]
//      let count = PHAsset.fetchAssets(in: album, options: nil).count
//      self.allAlbums.append(AlbumItem(name: "Depth Photos", count: count, albumResult: album))
//      print("Adding Depth album")
//    }
    
    UIView.animate(withDuration: 0.5) {
      self.albumTableView.reloadData()
    }
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.allAlbumSections[section].albumItems.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.allAlbumSections.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.phPhotoPickerAlbumIdentifier.identifier,
                                             for: indexPath) as? PHPhotoPickerAlbumTableViewCell else {
                                              return UITableViewCell()
    }
    cell.configure(albumItem: self.allAlbumSections[indexPath.section].albumItems[indexPath.row])
    return cell
  }
  
}

extension PHPhotoPickerAlbumListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return self.allAlbumSections[section].sectionTitle
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("TableView: Selected item at row: \(indexPath.row)")
    guard let phCollectionVC = PHPhotoPickerCollectionViewController.instantiate(photosCollection: self.allAlbumSections[indexPath.section].albumItems[indexPath.row]) else {
      print("Failed to instantiate picker collection vc")
      return
    }
    
    self.navigationController?.pushViewController(phCollectionVC, animated: true)
  }
  
}
