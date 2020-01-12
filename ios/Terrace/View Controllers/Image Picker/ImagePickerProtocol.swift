//
//  ImagePickerProtocol.swift
//  Terrace
//
//  Created by Avery Lamp on 1/12/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

import UIKit

protocol PHImagePickerDelegate: AnyObject {
  func pickerDidSelectPHImage()
}

extension PHImagePickerDelegate {
  func pickerDidSelectPHImage() {
    print("Selected image")
  }
}
