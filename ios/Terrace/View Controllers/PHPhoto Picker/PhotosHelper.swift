//
//  PhotosHelper.swift
//  Terrace
//
//  Created by Avery Lamp on 1/12/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

import UIKit
import Foundation
import Photos

class PhotosHelper {
  
  static func lastImageFromCollection(_ collection: PHAssetCollection?, size: CGSize) -> UIImage? {
    
    var returnImage: UIImage?
    
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
    
    let fetchResult = (collection == nil) ? PHAsset.fetchAssets(with: .image, options: fetchOptions) : PHAsset.fetchAssets(in: collection!, options: fetchOptions)
    if let lastAsset = fetchResult.lastObject {
      
      let imageRequestOptions = PHImageRequestOptions()
      imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.fastFormat
      imageRequestOptions.resizeMode = PHImageRequestOptionsResizeMode.exact
      imageRequestOptions.isSynchronous = true
      
      let cropSideLength = min(lastAsset.pixelWidth, lastAsset.pixelHeight)
      let square = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(cropSideLength), height: CGFloat(cropSideLength))
      let cropRect = square.applying(CGAffineTransform(scaleX: 1.0 / CGFloat(lastAsset.pixelWidth), y: 1.0 / CGFloat(lastAsset.pixelHeight)))
      
      imageRequestOptions.normalizedCropRect = cropRect
      
      PHImageManager.default().requestImage(for: lastAsset,
                                            targetSize: size,
                                            contentMode: PHImageContentMode.aspectFill,
                                            options: imageRequestOptions,
                                            resultHandler: { (image: UIImage?, _: [AnyHashable: Any]?) -> Void in
        returnImage = image
      })
    }
    
    return returnImage
  }
  
}
