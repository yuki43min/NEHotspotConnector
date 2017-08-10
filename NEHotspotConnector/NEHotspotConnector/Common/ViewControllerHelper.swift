//
//  ViewControllerHelper.swift
//  NEHotspotConnector
//
//  Created by Yuki.S on 2017/08/10.
//  Copyright © 2017年 Yuki.S. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerHelper {
  
  static func showIndicator(uiView: UIView) {
    if(existsIndicator(uiView: uiView)) {
      hideIndicator(uiView: uiView)
    }
    
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.frame = CGRect.init(x: 0.0, y: 0.0,
                                          width: UIScreen.main.bounds.width,
                                          height: UIScreen.main.bounds.height)
    activityIndicator.center = uiView.center
    activityIndicator.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
    activityIndicator.hidesWhenStopped = false
    activityIndicator.activityIndicatorViewStyle = .whiteLarge
    uiView.addSubview(activityIndicator)
    activityIndicator.startAnimating()
  }
  
  static func hideIndicator(uiView: UIView) {
    for v in uiView.subviews {
      if(v is UIActivityIndicatorView) {
        v.removeFromSuperview()
      }
    }
  }
  
  static func existsIndicator(uiView: UIView) -> Bool {
    for v in uiView.subviews {
      if(v is UIActivityIndicatorView) {
        return true
      }
    }
    return false
  }
}
