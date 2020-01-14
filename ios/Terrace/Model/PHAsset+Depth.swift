//
//  PHAsset+Depth.swift
//  Terrace
//
//  Created by Avery Lamp on 1/14/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

import Foundation
import Photos
import ImageIO

extension PHAsset {
  
  func doesContainImageDepthMap(completion: @escaping (_ imageDisparityAvailable: Bool) -> Void) {
    doesContainImageData(mapType: kCGImageAuxiliaryDataTypeDepth, completion: completion)
  }
  
  func doesContainImageDisparityMap(completion: @escaping (_ imageDisparityAvailable: Bool) -> Void) {
    doesContainImageData(mapType: kCGImageAuxiliaryDataTypeDisparity, completion: completion)
  }
  
  func doesContainImageData(mapType: CFString, completion: @escaping (_ imageDisparityAvailable: Bool) -> Void) {
    
    self.requestContentEditingInput(with: nil) { (input, info) in
      guard let inputURL = input?.fullSizeImageURL else {
        completion(false)
        return
      }
      print("Image URL: \(inputURL), Image Info: \(info)")
      print(info)
      guard let cgImageSource = CGImageSourceCreateWithURL(inputURL as CFURL, nil) else {
        completion(false)
        return
      }
      if CGImageSourceCopyAuxiliaryDataInfoAtIndex(cgImageSource, 0, mapType) != nil {
        completion(true)
        return
      } else {
        completion(false)
        return
      }
    }
  }
  
  func getImageData(mapType: CFString, completion: @escaping (_ imageDisparityAvailable: Bool) -> Void) {
    
//    do
//                       var depthData = try AVDepthData(fromDictionaryRepresentation: auxDataInfo as! [AnyHashable : Any])
//                       if depthData.depthDataType != kCVPixelFormatType_DisparityFloat16
//                           depthData = depthData.converting(toDepthDataType: kCVPixelFormatType_DisparityFloat16)
//
//                       let depthMap : CVPixelBuffer = depthData.depthDataMap
//                       var ciImage = CIImage(cvPixelBuffer: depthMap)
//                       ciImage = ciImage.applyingFilter("CIDisparityToDepth", parameters: [:])
//                       DispatchQueue.main.async
//                           self.imageView.image = UIImage(ciImage: ciImage)
//
//
//                   catch
//
//
  }
  
}
