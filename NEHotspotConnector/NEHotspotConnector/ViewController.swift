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
  
  let kTableViewHotspotIdentifier = "tableViewHotspotIdentifier"

  @IBOutlet var navigationBar: UINavigationBar!
  @IBOutlet var tableViewHotspot: UITableView!
  @IBOutlet var buttonUpdate: UIToolbar!
  
  private var wifiList: Array<String>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableViewHotspot.delegate = self
    
    getWifiList()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  } 

  
  func getWifiList() {
    ViewControllerHelper.showIndicator(uiView: self.view)
    
    let queue = DispatchQueue.main
//    NEHotspotHelper.register(options: nil, queue: queue, handler: { (handler) in
//      self.wifiList = Array<String>.init();
//      if(handler.commandType == .evaluate || handler.commandType == .filterScanList) {
//        for network in handler.networkList! {
//          print("ssid: \(network.ssid)")
//          self.wifiList.append(network.ssid)
//        }
//      }
//
//      ViewControllerHelper.hideIndicator(uiView: self.view)
//    })
  }
  
  func connect(ssid: String, passphrase: String, isWEP: Bool) {
    let manager = NEHotspotConfigurationManager.shared
//    let hotspotConfiguration = NEHotspotConfiguration(ssid: ssid, passphrase: passphrase, isWEP: isWEP)
//    hotspotConfiguration.joinOnce = true
//    hotspotConfiguration.lifeTimeInDays = 1
//
//    manager.apply(hotspotConfiguration, completionHandler: { (error) in
//      if let error = error {
//        print(error)
//      } else {
//        print("success")
//      }
//    })
  }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.wifiList.count;
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: kTableViewHotspotIdentifier, for: indexPath)
    let row = indexPath.row
    cell.textLabel?.text = self.wifiList[row]
    
    return cell
  }
  
}

