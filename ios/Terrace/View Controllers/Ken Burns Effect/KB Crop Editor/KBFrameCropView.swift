//
//  KBFrameCropView.swift
//  Terrace
//
//  Created by Avery Lamp on 1/15/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

import UIKit

class KBFrameCropView: UIView {
  
  var handles: [UIButton] = [UIButton(), UIButton(), UIButton(), UIButton()]
  
  var leftConstraint: NSLayoutConstraint?
  var topConstraint: NSLayoutConstraint?
  var rightConstraint: NSLayoutConstraint?
  var bottomConstraint: NSLayoutConstraint?
  
  let selectedColor: UIColor = UIColor(red: 0.18, green: 0.47, blue: 0.95, alpha: 0.3)
  let deselectedColor: UIColor = UIColor(white: 0.9, alpha: 0.4)
  let highlightColor: UIColor = UIColor(white: 0.7, alpha: 0.3)
  var ratio: CGFloat = 1.0
  var selected: Bool = false
  var minSize: CGSize = CGSize.zero
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  func setupKBFrameView() {
    self.setupSubviews()
    self.setupGestureRecognizers()
    self.stylize()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupSubviews() {
    var count = 0
    for button in self.handles {
      self.addSubview(button)
      button.translatesAutoresizingMaskIntoConstraints = false
      let panGestureRecognizer = UIPanGestureRecognizer()
      panGestureRecognizer.addTarget(self, action: #selector(KBFrameCropView.handlePanGestureRecognizer(gestureRecognizer:)))
      panGestureRecognizer.name = "ButtonHandle:\(count)"
      count += 1
      button.addGestureRecognizer(panGestureRecognizer)
      button.addConstraints([
        NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal,
                           toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30),
        NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal,
                           toItem: button, attribute: .width, multiplier: 1.0, constant: 0)
      ])
    }
    
    // Top Left Button
    self.addConstraints([
      NSLayoutConstraint(item: self.handles[0], attribute: .left, relatedBy: .equal,
                         toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: self.handles[0], attribute: .top, relatedBy: .equal,
                         toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
    ])
    
    // Top Right Button
    self.addConstraints([
      NSLayoutConstraint(item: self.handles[1], attribute: .right, relatedBy: .equal,
                         toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: self.handles[1], attribute: .top, relatedBy: .equal,
                         toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
    ])
    
    // Bottom Right Button
    self.addConstraints([
      NSLayoutConstraint(item: self.handles[2], attribute: .right, relatedBy: .equal,
                         toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: self.handles[2], attribute: .bottom, relatedBy: .equal,
                         toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
    ])
    
    // Bottom Left Button
    self.addConstraints([
      NSLayoutConstraint(item: self.handles[3], attribute: .left, relatedBy: .equal,
                         toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: self.handles[3], attribute: .bottom, relatedBy: .equal,
                         toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
    ])
  }
  
  func setupGestureRecognizers() {
    let panGestureRecongnizer = UIPanGestureRecognizer()
    panGestureRecongnizer.addTarget(self, action: #selector(KBFrameCropView.handlePanGestureRecognizer(gestureRecognizer:)))
    panGestureRecongnizer.delegate = self
    panGestureRecongnizer.name = "Drag"
    self.addGestureRecognizer(panGestureRecongnizer)
  }
  
  func stylize() {
    self.backgroundColor = UIColor(white: 0.3, alpha: 0.1)
    self.layer.borderWidth = 1.5
    self.setSelected(selected: false)
  }
  
  func setSelected(selected: Bool) {
    self.selected = selected
    self.isUserInteractionEnabled = selected
    if selected {
      self.backgroundColor = self.highlightColor
      self.layer.borderColor = self.selectedColor.cgColor
      self.handles.forEach({
        $0.backgroundColor = self.selectedColor
      })
    } else {
      self.backgroundColor = nil
      self.layer.borderColor = self.deselectedColor.cgColor
      self.handles.forEach({
        $0.backgroundColor = self.deselectedColor
      })
    }
  }
  
  func setRatio(ratio: CGFloat) {
    var targetSize: CGSize = CGSize.zero
    let maxWidth = self.frame.width + (self.leftConstraint?.constant ?? 0) - (self.rightConstraint?.constant ?? 0)
    let maxHeight = self.frame.height + (self.topConstraint?.constant ?? 0) - (self.bottomConstraint?.constant ?? 0)
    var scalar: CGFloat = 1.0
    if self.ratio < ratio {
      //      Needs to make the ratio wider
      targetSize.height = self.frame.height
      targetSize.width = targetSize.height * ratio
    } else {
      //      Needs to make the ratio taller
      targetSize.width = self.frame.width
      targetSize.height = targetSize.width / ratio
    }
    
    if targetSize.width > maxWidth && maxWidth / targetSize.width * 0.9 < scalar {
      scalar = maxWidth / targetSize.width  * 0.9
    }
    if targetSize.height > maxHeight && maxHeight / targetSize.height * 0.9 < scalar {
      scalar = maxHeight / targetSize.height  * 0.9
    }
    
    // Apply scalar
    targetSize.width *= scalar
    targetSize.height *= scalar
    
    let widthDifference = targetSize.width - self.frame.width
    let heightDifference = targetSize.height - self.frame.height
    self.leftConstraint?.constant -= widthDifference / 2.0
    self.rightConstraint?.constant += widthDifference / 2.0
    if (self.leftConstraint?.constant ?? 0) < 0 {
      self.rightConstraint?.constant -= self.leftConstraint?.constant ?? 0
      self.leftConstraint?.constant = 0
    }
    if (self.rightConstraint?.constant ?? 0) > 0 {
      self.leftConstraint?.constant -= self.rightConstraint?.constant ?? 0
      self.rightConstraint?.constant = 0
    }
    self.topConstraint?.constant -= heightDifference / 2.0
    self.bottomConstraint?.constant += heightDifference / 2.0
    if (self.topConstraint?.constant ?? 0) < 0 {
      self.bottomConstraint?.constant -= self.topConstraint?.constant ?? 0
      self.topConstraint?.constant = 0
    }
    if (self.bottomConstraint?.constant ?? 0) > 0 {
      self.topConstraint?.constant -= self.bottomConstraint?.constant ?? 0
      self.bottomConstraint?.constant = 0
    }
    UIView.animate(withDuration: 0.5) {
      self.layoutIfNeeded()
    }
    
    self.ratio = ratio
  }
  
}

// MARK: UIGestureRecognizers
extension KBFrameCropView: UIGestureRecognizerDelegate {
  
  @objc func handleButtonClicked(sender: UIButton) {
    print("Handle button clicked")
  }
  
  override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
  @objc func handlePanGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
    guard let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
      return
    }
    let translation = gestureRecognizer.translation(in: self)
    gestureRecognizer.setTranslation(CGPoint.zero, in: self)
    let gestureRecognizerName = gestureRecognizer.name ?? ""
    
    if gestureRecognizerName == "Drag"{
      self.handleDragTranslation(translation: translation)
      
    } else if (gestureRecognizerName.components(separatedBy: ":").first == "ButtonHandle"),
      let handleNumber = Int(gestureRecognizerName.components(separatedBy: ":").last ?? "") {
      self.handleScaleTranslation(translation: translation, handleNumber: handleNumber)
    }
  }
  
  func handleDragTranslation(translation: CGPoint) {
    var translation = translation
    if (self.leftConstraint?.constant ?? 0 + translation.x < 0 && translation.x < 0) ||
      (self.rightConstraint?.constant ?? self.frame.width + translation.x > 0 && translation.x > 0) {
      translation.x = 0.0
    }
    if (self.topConstraint?.constant ?? 0 + translation.y < 0 && translation.y < 0) ||
      (self.bottomConstraint?.constant ?? self.frame.width + translation.y > 0 && translation.y > 0) {
      translation.y = 0.0
    }
    
    self.leftConstraint?.constant += translation.x
    self.rightConstraint?.constant += translation.x
    self.topConstraint?.constant += translation.y
    self.bottomConstraint?.constant += translation.y
    
    self.superview?.layoutIfNeeded()
  }
  
  func handleScaleTranslation(translation: CGPoint, handleNumber: Int) {
    var translation = translation
    let largeSideHorizontal = max(abs(translation.x), abs(translation.y)) == abs(translation.x)
    var shrinking: Bool = true
    switch handleNumber {
    case 0:
      if largeSideHorizontal {
        translation.y = translation.x * CGFloat(1.0) / ratio
        shrinking = translation.x > 0
      } else {
        translation.x = translation.y * CGFloat(1.0) * ratio
        shrinking = translation.y > 0
      }
    case 1:
      if largeSideHorizontal {
        translation.y = translation.x * CGFloat(-1.0) / ratio
        shrinking = translation.x < 0
      } else {
        translation.x = translation.y * CGFloat(-1.0) * ratio
        shrinking = translation.y > 0
      }
    case 2:
      if largeSideHorizontal {
        translation.y = translation.x * CGFloat(1.0) / ratio
        shrinking = translation.x < 0
      } else {
        translation.x = translation.y * CGFloat(1.0) * ratio
        shrinking = translation.y < 0
      }
    case 3:
      if largeSideHorizontal {
        translation.y = translation.x * CGFloat(-1.0) / ratio
        shrinking = translation.x < 0
      } else {
        translation.x = translation.y * CGFloat(-1.0) * ratio
        shrinking = translation.y < 0
      }
    default:
      break
    }
        
    let leftConstraintConstant = self.leftConstraint?.constant ?? 0
    let rightConstraintConstant = self.rightConstraint?.constant ?? 0
    let topConstraintConstant = self.topConstraint?.constant ?? 0
    let bottomConstraintConstant = self.bottomConstraint?.constant ?? 0
    
    let halfSize = CGSize(width: (self.superview?.frame.width ?? 0) / 2.0, height: (self.superview?.frame.height ?? 0) / 2.0)
    if shrinking && (self.frame.width < halfSize.width || self.frame.height < halfSize.height / ratio) {
      return
    }
    switch handleNumber {
    case 0:
      if leftConstraintConstant + translation.x < 0  ||
        topConstraintConstant + translation.y < 0 {
        return
      }
      self.leftConstraint?.constant += translation.x
      self.topConstraint?.constant += translation.y
    case 1:
      if rightConstraintConstant + translation.x > 0  ||
        topConstraintConstant + translation.y < 0 {
        return
      }
      self.rightConstraint?.constant += translation.x
      self.topConstraint?.constant += translation.y
    case 2:
      if rightConstraintConstant + translation.x > 0  ||
        bottomConstraintConstant + translation.y > 0 {
        return
      }
      self.rightConstraint?.constant += translation.x
      self.bottomConstraint?.constant += translation.y
    case 3:
      if leftConstraintConstant + translation.x < 0  ||
        bottomConstraintConstant + translation.y > 0 {
        return
      }
      self.leftConstraint?.constant += translation.x
      self.bottomConstraint?.constant += translation.y
    default:
      break
    }
    self.superview?.layoutIfNeeded()
  }
  
  @objc func handleTapGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
    print("Tap Gesture Recognizer triggered")
  }
  
}
