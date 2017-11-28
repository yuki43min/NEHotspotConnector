//
//  SwitchTableViewCell.swift
//  NEHotspotConnector
//
//  Created by Yuki.S on 2017/08/15.
//  Copyright © 2017年 Yuki.S. All rights reserved.
//

import Foundation
import UIKit

class SwitchTableViewCell : UITableViewCell {
  let kRectContainer : CGRect = CGRect(x:0, y:0, width:10+30, height:50)
  let kRectUiSwitch : CGRect = CGRect(x:10, y:0, width:30, height:50)
  var uiSwitch : UISwitch?
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(style: UITableViewCellStyle, reuseIdentifier: String?, withValue: Bool, withTag: Int, withTarget: Any, action: Selector) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    self.textLabel?.text = ""
    self.textLabel?.accessibilityElementsHidden = true
    self.uiSwitch = UISwitch.init(frame: kRectUiSwitch)
    let view = UIView.init(frame: kRectContainer)
    self.uiSwitch?.center = view.center
    view.addSubview(self.uiSwitch!)
    self.accessoryView = view
    self.uiSwitch?.addTarget(target, action: action, for: .valueChanged)
    self.uiSwitch?.isOn = withValue
    self.uiSwitch?.tag = tag
  }
}
