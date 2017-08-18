//
//  ViewController.swift
//  NEHotspotConnector
//
//  Created by Yuki.S on 2017/08/10.
//  Copyright © 2017年 Yuki.S. All rights reserved.
//
import UIKit
import NetworkExtension



class ViewController: UIViewController {
  let titles: [String] = ["SSID", "暗号化方式", "パスワード"]
  
  @IBOutlet var navigationBar: UINavigationBar!
  @IBOutlet var buttonConnect: UIBarButtonItem!
  @IBOutlet var tableWifiSetting: UITableView!
  
  var ssid : String!
  var passPhrase : String!
  var isPasswordSwitchOn : Bool!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.buttonConnect.action = #selector(didTapButtonConnect(button:))
    self.tableWifiSetting.delegate = self
    self.tableWifiSetting.dataSource = self
    
    self.ssid = ""
    self.passPhrase = ""
    self.isPasswordSwitchOn = false
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @objc func switchChanged(uiSwitch: UISwitch) {
    isPasswordSwitchOn = uiSwitch.isOn
  }
  
  @objc func didTapButtonConnect(button: UIBarButtonItem) {
    connect(ssid: "", passphrase: "textFieldPassword.text", isWEP: true)
  }
  
  func connect(ssid: String, passphrase: String, isWEP: Bool) {
    #if (!arch(i386) && !arch(x86_64))
    let manager:NEHotspotConfigurationManager = NEHotspotConfigurationManager.shared
    let hotspotConfiguration = NEHotspotConfiguration(ssid: ssid, passphrase: passphrase, isWEP: isWEP)
    hotspotConfiguration.joinOnce = true
    hotspotConfiguration.lifeTimeInDays = 1

    manager.apply(hotspotConfiguration, completionHandler: { (error) in
      if let error = error {
        print(error)
      } else {
        print("success")
      }
    })
    #else
    #endif
  }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell : UITableViewCell? = nil
    
    switch (indexPath.row) {
    case 0:
      cell = InputTableViewCell.init(style: .default, reuseIdentifier: "test")
      (cell as! InputTableViewCell).textFieldInput?.delegate = self;
      (cell as! InputTableViewCell).textFieldInput?.placeholder = "入力してください...";
      (cell as! InputTableViewCell).textFieldInput?.keyboardType = .default;
      (cell as! InputTableViewCell).textFieldInput?.isEnabled = true;
      (cell as! InputTableViewCell).textFieldInput?.text = self.ssid;
      (cell as! InputTableViewCell).textFieldInput?.clearsOnBeginEditing = true;
      break
    case 1:
      ccell = SwitchTableViewCell.init(style: .subtitle, reuseIdentifier: "test", withValue: isPasswordSwitchOn, withTag: 0, withTarget: self, action: #selector(didSwitchChanged))
      break
    case 2:
      cell = InputTableViewCell.init(style: .default, reuseIdentifier: "test")
      (cell as! InputTableViewCell).textFieldInput?.delegate = self;
      (cell as! InputTableViewCell).textFieldInput?.placeholder = "入力してください...";
      (cell as! InputTableViewCell).textFieldInput?.keyboardType = .default;
      (cell as! InputTableViewCell).textFieldInput?.isSecureTextEntry = true;
      (cell as! InputTableViewCell).textFieldInput?.isEnabled = true;
      (cell as! InputTableViewCell).textFieldInput?.text = self.passPhrase;
      (cell as! InputTableViewCell).textFieldInput?.clearsOnBeginEditing = true;
      break;
      
    default: break
    }

    
    cell?.textLabel?.text = self.titles[indexPath.row]
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
  @objc func didSwitchChanged(sender: Any) {
    let switchButton = sender as! UISwitch
    self.isPasswordSwitchOn = switchButton.isOn
  }
  
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    self.passPhrase = textField.text;
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool{
    // キーボードを閉じる
    textField.resignFirstResponder()
    return true
  }
  
}

