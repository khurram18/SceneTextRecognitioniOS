//
//  ViewController.swift
//  SceneTextRecognitioniOS
//
//  Created by Khurram Shehzad on 09/08/2017.
//  Copyright © 2017 devcrew. All rights reserved.
//

import AVFoundation
import UIKit
import Vision


class ViewController: UIViewController {

override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    if isAuthorized() {
        configureCamera()
    }
}

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}
private func configureCamera() {
    preview.session = session
    let cameraDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
    var cameraDevice: AVCaptureDevice?
    for device in cameraDevices.devices {
        if device.position == .back {
            cameraDevice = device
            break
        }
    }
    do {
        let captureDeviceInput = try AVCaptureDeviceInput(device: cameraDevice!)
        if session.canAddInput(captureDeviceInput) {
            session.addInput(captureDeviceInput)
        }
    }
    catch {
        print("Error occured \(error)")
        return
    }
    session.sessionPreset = .high
    let videoDataOutput = AVCaptureVideoDataOutput()
    videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "Buffer Queue", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil))
    if session.canAddOutput(videoDataOutput) {
        session.addOutput(videoDataOutput)
    }
    preview.videoPreviewLayer.videoGravity = .resize
    session.startRunning()
}
private var preview: PreviewView {
    return view as! PreviewView
}
private func isAuthorized() -> Bool {
    let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    switch authorizationStatus {
    case .notDetermined:
        AVCaptureDevice.requestAccess(for: AVMediaType.video,
                                      completionHandler: { (granted:Bool) -> Void in
                                        if granted {
                                            DispatchQueue.main.async {
                                                self.configureCamera()
                                            }
                                        }
        })
        return true
    case .authorized:
        return true
    case .denied, .restricted: return false
    }
}
private let session = AVCaptureSession()
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
// MARK: - Camera Delegate and Setup
func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    
}
}
