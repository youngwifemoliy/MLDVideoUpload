//
//  CameraViewController.swift
//  VideoUpload
//
//  Created by MoliySDev on 2020/3/3.
//  Copyright © 2020 MoliySDev. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController {
    
    var superViewController = ViewController()
    
    let captureSession = AVCaptureSession()
    let videoDevice = AVCaptureDevice.default(for: AVMediaType.video)
    let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
    let fileOutput = AVCaptureMovieFileOutput()
    var recordButton : UIButton!
    //帧数
    var framesPerSecond:Int32 = 30
    //录像数组
    var videoAssets = [AVAsset]()
    //录像本地url
    var assetURLs = [String]()
    //录像云端url
    var cloudURLs = [String]()
    //录像片段索引
    var appIndex: Int32 = 1
    //最大录制时间
    let totalSeconds: Float64 = 10
    //定时器间隔
    var incInterval: TimeInterval = 1
    //拍摄进度
    var timeHub = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MLDGCDTimerManager.cancel("RECORDTIMER")
    }
    
}


//MARK:- AVCaptureFileOutputRecordingDelegate
extension CameraViewController:AVCaptureFileOutputRecordingDelegate {
    
    //录像开始的代理方法
    func fileOutput(_ output: AVCaptureFileOutput,
                    didStartRecordingTo fileURL: URL,
                    from connections: [AVCaptureConnection]) {
        startRecordTimer()
    }
    
    //录像结束的代理方法
    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection], error: Error?) {
        let asset = AVURLAsset(url: outputFileURL, options: nil)
        //        var duration : TimeInterval = 0.0
        //        duration = CMTimeGetSeconds(asset.duration)
        print("视频片段：\(asset)")
        videoAssets.append(asset)
        assetURLs.append(outputFileURL.path)
        upload(outputFileURL)
        if assetURLs.count == 3 {
            self.dismiss(animated: true) {}
        }
        
    }
    
}

//MARK:- Net
extension CameraViewController {
    
    func upload(_ path:URL) {
        let data = try! Data.init(contentsOf: path)
        MLDQCloudCOSXML.upload(withFileData: data, withType: "video",
                               withProcess: { (bytesSent, totalBytesSent, totalBytesExpectedToSend) in
        }) { (url) in
            DispatchQueue.main.async {
                self.cloudURLs.append(url)
                self.superViewController.cloudUrl = self.cloudURLs
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UploadSuccess"),
                                                object: nil)
            }
        }
    }
    
}

//MARK:- TIMER
extension CameraViewController {
    
    func startRecordTimer() {
        MLDGCDTimerManager.scheduledTimer(name: "RECORDTIMER",
                                          interval: incInterval) { (time) in
                                            DispatchQueue.main.async {
                                                if time > 10 {
                                                    self.autoSlip()
                                                    self.startRecord()
                                                }
                                                self.reloadTimeHub(time)
                                            }
        }
        MLDGCDTimerManager.start("RECORDTIMER")
    }
    
    
    func reloadTimeHub(_ time:Int) {
        timeHub.text = "\(time)//\(totalSeconds)"
    }
    
}

//MARK:- Action
extension CameraViewController {
    
    //按下录制按钮，开始录制片段
    @objc func recordButtonClick(_ sender: UIButton) {
        startRecord()
    }
    
}

//MARK:- RecordDevice
extension CameraViewController {
    
    func autoSlip() {
        MLDGCDTimerManager.cancel("RECORDTIMER")
        fileOutput.stopRecording()
    }
    
    func startRecord() {
        if assetURLs.count < 3 {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                            .userDomainMask, true)
            let documentsDirectory = paths[0] as String
            let outputFilePath = "\(documentsDirectory)/output-\(appIndex).mov"
            appIndex += 1
            let outputURL = URL(fileURLWithPath: outputFilePath)
            let fileManager = FileManager.default
            if(fileManager.fileExists(atPath: outputFilePath)) {
                do {
                    try fileManager.removeItem(atPath: outputFilePath)
                } catch _ {
                }
            }
            print("开始录制：\(outputFilePath)")
            fileOutput.startRecording(to: outputURL, recordingDelegate: self)
        }
    }
    
}

//MARK:- UI
extension CameraViewController {
    
    func setupUI() {
        //初始化摄像设备
        setupRecordDevice()
        //创建按钮
        setupButton()
        //创建拍摄HUB
        setupTimeHub()
    }
    
    func setupRecordDevice() {
        let videoInput = try! AVCaptureDeviceInput(device: self.videoDevice!)
        self.captureSession.addInput(videoInput)
        let audioInput = try! AVCaptureDeviceInput(device: self.audioDevice!)
        self.captureSession.addInput(audioInput)
        let maxDuration = CMTimeMakeWithSeconds(totalSeconds,
                                                preferredTimescale: framesPerSecond)
        self.fileOutput.maxRecordedDuration = maxDuration
        self.captureSession.addOutput(self.fileOutput)
        let videoLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        videoLayer.frame = self.view.bounds
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.addSublayer(videoLayer)
    }
    
    func setupTimeHub() {
        //添加进度条
        timeHub = UILabel(frame: CGRect(x: 0, y: 10,
                                        width: self.view.bounds.width,
                                        height: self.view.bounds.height * 0.1))
        timeHub.backgroundColor = UIColor.white
        timeHub.textAlignment = .center
        self.view.addSubview(timeHub)
    }
    
    func setupButton(){
        self.recordButton = UIButton(frame: CGRect(x:0,y:0,width:100,height:100))
        self.recordButton.backgroundColor = UIColor.red
        self.recordButton.layer.masksToBounds = true
        self.recordButton.setTitle("录像", for: .normal)
        self.recordButton.layer.cornerRadius = 50
        self.recordButton.layer.position = CGPoint(x: self.view.bounds.width / 2,
                                                   y: self.view.bounds.height - 50)
        self.recordButton.addTarget(self,
                                    action: #selector(recordButtonClick(_:)),
                                    for: .touchUpInside)
        self.view.addSubview(self.recordButton);
    }
    
}
