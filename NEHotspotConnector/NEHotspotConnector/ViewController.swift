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

  @IBOutlet var navigationBar: UINavigationBar!
  @IBOutlet var textFieldSSID: UITextField!
  @IBOutlet var switchIsWEP: UISwitch!
  @IBOutlet var textFieldPassword: UITextField!
  @IBOutlet var buttonConnect: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.switchIsWEP.addTarget(self, action: #selector(switchChanged(swicth:)), for: UIControlEvents.valueChanged)
    self.buttonConnect.action = #selector(didTapButtonConnect(button:))
    self.textFieldSSID.delegate = self
    self.textFieldPassword.delegate = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @objc func switchChanged(swicth: UISwitch) {
    
  }
  
  @objc func didTapButtonConnect(button: UIBarButtonItem) {
    connect(ssid: self.textFieldSSID.text!, passphrase: textFieldPassword.text!, isWEP: switchIsWEP.isOn)
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

extension ViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool{
    // キーボードを閉じる
    textField.resignFirstResponder()
    return true
  }
}

