//
//  PHImagePickerAlbumListViewController.swift
//  Terrace
//
//  Created by Avery Lamp on 1/12/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

import UIKit

class PHImagePickerAlbumListViewController: UIViewController {
  
  weak var pickerDelegate: PHImagePickerDelegate?
  
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
  }
  
  /// Stylize should only be called once
  func stylize() {
    
  }
  
}

// MARK: UITableViewDelegate
extension PHImagePickerAlbumListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.phPhotoPickerAlbumIdentifier.identifier,
                                             for: indexPath)
    
    return cell
  }
  
}

extension PHImagePickerAlbumListViewController: UITableViewDelegate {
    
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("TableView: Selected item at row: \(indexPath.row)")
  }
  
}
