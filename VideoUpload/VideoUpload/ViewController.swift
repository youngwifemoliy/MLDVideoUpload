//
//  ViewController.swift
//  VideoUpload
//
//  Created by MoliySDev on 2020/3/3.
//  Copyright © 2020 MoliySDev. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var cloudUrl = [String]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(title: "拍摄",
                                   style: .plain,
                                   target: self,
                                   action: #selector(showCamera))
        navigationItem.rightBarButtonItem = item
        addNotification()
    }

    func addNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tableViewReload),
                                               name: NSNotification.Name(rawValue: "UploadSuccess"),
                                               object: nil)
    }
    
    @objc func tableViewReload() {
        tableView.reloadData()
    }
    
}

extension ViewController {
    
    //录像回看
    func reviewRecord(_ url: URL) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    @objc func showCamera() {
        let vc = CameraViewController()
        vc.superViewController = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true) {
            
        }
    }
    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cloudUrl.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = cloudUrl[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: cloudUrl[indexPath.row])
        reviewRecord(url!)
    }
    
    
}

