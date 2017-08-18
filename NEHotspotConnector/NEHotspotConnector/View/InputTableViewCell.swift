//
//  InputTableViewCell.swift
//  NEHotspotConnector
//
//  Created by Yuki.S on 2017/08/15.
//  Copyright © 2017年 Yuki.S. All rights reserved.
//

import Foundation
import UIKit

class InputTableViewCell : UITableViewCell {

  var textFieldInput : UITextField?
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    self.textLabel?.accessibilityElementsHidden = true
    self.textFieldInput = UITextField.init()
    self.textFieldInput?.backgroundColor = UIColor.white
    self.textFieldInput?.textAlignment = .right
    self.textLabel?.isUserInteractionEnabled = true
    self.textLabel?.addSubview(self.textFieldInput!)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let b = self.textLabel!.bounds
    self.textFieldInput?.frame = CGRect(x:b.width*0.5, y:0, width: b.width*0.5, height: b.height)
  }
}
