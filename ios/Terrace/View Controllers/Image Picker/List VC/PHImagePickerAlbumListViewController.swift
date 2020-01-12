//
//  PHImagePickerAlbumListViewController.swift
//  Terrace
//
//  Created by Avery Lamp on 1/12/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

import UIKit
import Photos

struct AlbumItem {
  let name: String
  let count: Int
  let albumResult: PHAssetCollection
}

class PHImagePickerAlbumListViewController: UIViewController {
  
  weak var pickerDelegate: PHImagePickerDelegate?
  
  var allAlbums: [AlbumItem] = []
  
  @IBOutlet weak var albumTableView: UITableView!
  
  /// Factory method for creating this view controller.
  ///
  /// - Returns: Returns an instance of this view controller.
  class func instantiate(delegate: PHImagePickerDelegate? = nil) -> PHImagePickerAlbumListViewController? {
    let vcName = String(describing: PHImagePickerAlbumListViewController.self)
    let storyboard = R.storyboard.phImagePickerAlbumListViewController
    guard let vcPHImageAlbumList = storyboard.instantiateInitialViewController() else {
      fatalError("Unable to instantiate \(vcName)")
    }
    vcPHImageAlbumList.pickerDelegate = delegate
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
    self.albumTableView.dataSource = self
    self.albumTableView.delegate = self
    self.loadTableData()
  }
  
  /// Stylize should only be called once
  func stylize() {
    
  }
  
}

// MARK: UITableViewDelegate
extension PHImagePickerAlbumListViewController: UITableViewDataSource {
  
  func loadTableData() {
    self.allAlbums.removeAll()
    print("Loading table data")
    let depthAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.smartAlbumDepthEffect, options: nil)
//    
//    for index in 0..<depthAlbums.count {
//      let album = depthAlbums[index]
//      
//      self.allAlbums.append(AlbumItem(name: "Depth Album", count: album.estimatedAssetCount, albumResult: album))
//      print("Adding Depth album")
//    }
//    
//    let nativeAlbumns = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
//    for index in 0..<nativeAlbumns.count {
//      let album = nativeAlbumns[index]
//      self.allAlbums.append(AlbumItem(name: "Native Album", count: album.estimatedAssetCount, albumResult: album))
//      print("Adding Native album")
//    }
    
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
        self.allAlbums.append(AlbumItem(name: collection.localizedTitle ?? "Test", count: count, albumResult: collection))
      }
    }
    
    UIView.animate(withDuration: 0.5) {
      self.albumTableView.reloadData()
    }
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.allAlbums.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.phPhotoPickerAlbumIdentifier.identifier,
                                             for: indexPath) as? PHPhotoPickerAlbumTableViewCell else {
                                              return UITableViewCell()
    }
    cell.configure(albumItem: self.allAlbums[indexPath.row])
    return cell
  }
  
}

extension PHImagePickerAlbumListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("TableView: Selected item at row: \(indexPath.row)")
  }
  
}
