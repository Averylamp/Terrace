//
//  ImagePickerProtocol.swift
//  Terrace
//
//  Created by Avery Lamp on 1/12/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

import UIKit
import Photos

protocol PHPhotoPickerDelegate: AnyObject {
  func pickerDidSelectPHImage(asset: PHAsset)
}
