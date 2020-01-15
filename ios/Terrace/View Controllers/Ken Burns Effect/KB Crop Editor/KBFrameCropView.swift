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
  let deselectedColor: UIColor = UIColor(white: 0.3, alpha: 0.3)
  let highlightColor: UIColor = UIColor(white: 0.7, alpha: 0.3)
  var selected: Bool = false
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupSubviews()
    self.stylize()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupSubviews() {
    for button in self.handles {
      self.addSubview(button)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.backgroundColor = UIColor.red
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
    
    // Bottom Left Button
    self.addConstraints([
      NSLayoutConstraint(item: self.handles[2], attribute: .left, relatedBy: .equal,
                         toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: self.handles[2], attribute: .bottom, relatedBy: .equal,
      toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
    ])
    
    // Bottom Right Button
    self.addConstraints([
      NSLayoutConstraint(item: self.handles[3], attribute: .right, relatedBy: .equal,
                         toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: self.handles[3], attribute: .bottom, relatedBy: .equal,
      toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
    ])
  }
  
  func stylize() {
    self.backgroundColor = UIColor(white: 0.3, alpha: 0.1)
    self.layer.borderWidth = 1.5
    self.setSelected(selected: false)
  }
  
  func setSelected(selected: Bool){
    self.selected = selected
    if selected{
      self.backgroundColor = self.highlightColor
      self.layer.borderColor = self.selectedColor.cgColor
      self.handles.forEach({
        $0.backgroundColor = self.selectedColor
      })
    }else{
      self.backgroundColor = nil
      self.layer.borderColor = self.deselectedColor.cgColor
      self.handles.forEach({
        $0.backgroundColor = nil
      })
    }
    
  }

}
