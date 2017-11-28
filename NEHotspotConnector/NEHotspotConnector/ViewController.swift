//
//  ViewController.swift
//  NEHotspotConnector
//
//  Created by Yuki.S on 2017/08/10.
//  Copyright © 2017年 Yuki.S. All rights reserved.
//
import UIKit
import NetworkExtension
import SystemConfiguration.CaptiveNetwork



class ViewController: UIViewController {
  let kTitleSSID = "SSID"
  let kTitleIsWEP = "暗号化方式(WEP)"
  let kTitlePassPhrase = "パスワード"
  var dic: Dictionary<String, Any>!
  var connectedSSID: String?
  
  @IBOutlet var navigationBar: UINavigationBar!
  @IBOutlet var buttonConnectedSSID: UIBarButtonItem!
  @IBOutlet var buttonConnect: UIBarButtonItem!
  @IBOutlet var buttonDisconnect: UIBarButtonItem!
  @IBOutlet var tableWifiSetting: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationBar.topItem?.title = "NEHotspotConnector"
    self.buttonConnectedSSID.title = "SSID確認"
    self.buttonConnectedSSID.action = #selector(didTapButtonConnectedSSID(button:))
    self.buttonConnect.title = "接続する"
    self.buttonConnect.action = #selector(didTapButtonConnect(button:))
    self.buttonDisconnect.title = "切断する"
    self.buttonDisconnect.action = #selector(didTapButtonDisconnect(button:))
    self.tableWifiSetting.delegate = self
    self.tableWifiSetting.dataSource = self
    
    self.dic =
      [kTitleSSID       : "",
       kTitleIsWEP      : false,
       kTitlePassPhrase : ""]
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @objc func switchChanged(uiSwitch: UISwitch) {
    self.dic[kTitleIsWEP] = uiSwitch.isOn
  }
 
  @objc func didTapButtonConnectedSSID(button: UIBarButtonItem) {
    var currentSSID: String? = nil
    if let interfaces:CFArray = CNCopySupportedInterfaces() {
      for i in 0..<CFArrayGetCount(interfaces){
        let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
        let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
        let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
        if unsafeInterfaceData != nil {
          let interfaceData = unsafeInterfaceData! as Dictionary!
          for dictData in interfaceData! {
            if dictData.key as! String == "SSID" {
              currentSSID = dictData.value as? String
            }
          }
        }
      }
    }
    
    if currentSSID == nil {
      ViewControllerHelper.showAlert(title: "接続中のSSID", message: "nil", vc: self)
    } else {
      ViewControllerHelper.showAlert(title: "接続中のSSID", message: currentSSID!, vc: self)
    }
    
  }
  
  @objc func didTapButtonConnect(button: UIBarButtonItem) {
    connect(ssid: self.dic[kTitleSSID] as? String,
            passphrase: self.dic[kTitlePassPhrase] as? String,
            isWEP: self.dic[kTitleIsWEP] as! Bool)
  }
  
  @objc func didTapButtonDisconnect(button: UIBarButtonItem) {
    if (self.connectedSSID != nil) {
      disconnect(ssid: self.connectedSSID)
      ViewControllerHelper.showAlert(title: "切断", message: "\"" + self.connectedSSID! + "\"から切断しました", vc: self)
      self.connectedSSID = nil
    }
  }
  
  func connect(ssid: String?, passphrase: String?, isWEP: Bool) {
    #if (!arch(i386) && !arch(x86_64))
      let manager:NEHotspotConfigurationManager = NEHotspotConfigurationManager.shared
      var hotspotConfiguration:NEHotspotConfiguration;
      
      if (passphrase ?? "").isEmpty {
        hotspotConfiguration = NEHotspotConfiguration(ssid: ssid!)
      } else {
        hotspotConfiguration = NEHotspotConfiguration(ssid: ssid!, passphrase: passphrase!, isWEP: isWEP)
      }
      
      hotspotConfiguration.joinOnce = true
      hotspotConfiguration.lifeTimeInDays = 1
      
      manager.apply(hotspotConfiguration, completionHandler: { [unowned self] (error) in
        if let error = error {
          ViewControllerHelper.hideIndicator(uiView: self.view)
          print(error)
          ViewControllerHelper.showAlert(title: "エラー", message: "接続できませんでした", vc: self)
        } else {
          self.connectedSSID = ssid
          ViewControllerHelper.hideIndicator(uiView: self.view)
          print("success")
        }
      })
      ViewControllerHelper.showIndicator(uiView: self.view)
    #else
    #endif
  }
  
  func disconnect(ssid: String?) {
    
    #if (!arch(i386) && !arch(x86_64))
      let manager:NEHotspotConfigurationManager = NEHotspotConfigurationManager.shared
      manager.removeConfiguration(forSSID: ssid!)
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
      (cell as! InputTableViewCell).textFieldInput?.text = self.dic[kTitleSSID] as? String;
      (cell as! InputTableViewCell).textFieldInput?.clearsOnBeginEditing = true;
      (cell as! InputTableViewCell).textFieldInput?.tag = indexPath.row
      cell?.textLabel?.text = kTitleSSID
      break
    case 1:
      cell = SwitchTableViewCell.init(style: .subtitle, reuseIdentifier: "test", withValue: self.dic[kTitleIsWEP] as! Bool, withTag: 0, withTarget: self, action: #selector(didSwitchChanged))
      cell?.textLabel?.text = kTitleIsWEP
      break
    case 2:
      cell = InputTableViewCell.init(style: .default, reuseIdentifier: "test")
      (cell as! InputTableViewCell).textFieldInput?.delegate = self
      (cell as! InputTableViewCell).textFieldInput?.placeholder = "入力してください..."
      (cell as! InputTableViewCell).textFieldInput?.keyboardType = .default
      (cell as! InputTableViewCell).textFieldInput?.isSecureTextEntry = true
      (cell as! InputTableViewCell).textFieldInput?.isEnabled = true
      (cell as! InputTableViewCell).textFieldInput?.text = self.dic[kTitlePassPhrase] as? String
      (cell as! InputTableViewCell).textFieldInput?.clearsOnBeginEditing = true
      (cell as! InputTableViewCell).textFieldInput?.tag = indexPath.row
      cell?.textLabel?.text = kTitlePassPhrase
      break
      
    default: break
    }
    
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
  @objc func didSwitchChanged(sender: Any) {
    let switchButton = sender as! UISwitch
    self.dic[kTitleIsWEP] = switchButton.isOn
  }
  
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    switch (textField.tag) {
    case 0:
      self.dic[kTitleSSID] = textField.text;
      break
    case 2:
      self.dic[kTitlePassPhrase] = textField.text;
      break
    default:
      break
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool{
    // キーボードを閉じる
    textField.resignFirstResponder()
    return true
  }
  
}

