//
//  ViewController.swift
//  SortML
//
<<<<<<< HEAD
//  Created by Brendon Ho on 4/21/18.
//  Copyright © 2018 ARgon. All rights reserved.
=======
//  Created by Brendon Ho on 2/5/18.
//  Copyright © 2018 Mengo. All rights reserved.
>>>>>>> 10f3e36dd855ef45d13b0eb9a1022401132281e1
//

import UIKit
import Vision
import CoreMedia

class ViewController: UIViewController {
    @IBOutlet weak var videoPreview: UIView!
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
<<<<<<< HEAD
    @IBOutlet weak var blue: UILabel!
=======
>>>>>>> 10f3e36dd855ef45d13b0eb9a1022401132281e1
    
    let model = Inceptionv3()
    
    var videoCapture: VideoCapture!
    var request: VNCoreMLRequest!
    var startTimes: [CFTimeInterval] = []
    
    var framesDone = 0
    var frameCapturingStartTime = CACurrentMediaTime()
    let semaphore = DispatchSemaphore(value: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        predictionLabel.text = ""
        
<<<<<<< HEAD
        blue.layer.cornerRadius = 15
        
=======
>>>>>>> 10f3e36dd855ef45d13b0eb9a1022401132281e1
        setUpVision()
        setUpCamera()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(#function)
    }
    
    // MARK: - Initialization
    
    func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.fps = 50
        videoCapture.setUp { success in
            if success {
                // Add the video preview into the UI.
                if let previewLayer = self.videoCapture.previewLayer {
                    self.videoPreview.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                self.videoCapture.start()
            }
        }
    }
    
    func setUpVision() {
        guard let visionModel = try? VNCoreMLModel(for: model.model) else {
            print("Error: could not create Vision model")
            return
        }
        
        request = VNCoreMLRequest(model: visionModel, completionHandler: requestDidComplete)
        request.imageCropAndScaleOption = .centerCrop
    }
    
    // MARK: - UI stuff
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        resizePreviewLayer()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = videoPreview.bounds
    }
    
    // MARK: - Doing inference
    
    typealias Prediction = (String, Double)
    
    func predict(pixelBuffer: CVPixelBuffer) {
        // Measure how long it takes to predict a single video frame. Note that
        // predict() can be called on the next frame while the previous one is
        // still being processed. Hence the need to queue up the start times.
        startTimes.append(CACurrentMediaTime())
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }
    
    func requestDidComplete(request: VNRequest, error: Error?) {
        if let observations = request.results as? [VNClassificationObservation] {
            
            // The observations appear to be sorted by confidence already, so we
            // take the top 5 and map them to an array of (String, Double) tuples.
            let top5 = observations.prefix(through: 4)
                .map { ($0.identifier, Double($0.confidence)) }
            
            DispatchQueue.main.async {
                self.show(results: top5)
                self.semaphore.signal()
            }
        }
    }
    
    func show(results: [Prediction]) {
        var s: [String] = []
        for (i, pred) in results.enumerated() {
            s.append(String(format: "%d: %@ (%3.2f%%)", i + 1, pred.0, pred.1 * 100))
        }
        print(s.joined(separator: "\n\n"))
        itemLabel.text = s[0]
        if s[0].contains("bottle") || s[0].contains("can") || s[0].contains("paper") || s[0].contains("notebook") || s[0].contains("envelope") || s[2].contains("envelope") || s[0].contains("packet") || s[0].contains("binder"){
            self.predictionLabel.text = "RECYCLE"
            self.predictionLabel.textColor = UIColor(red:0.21, green:0.58, blue:1.00, alpha:1.0)
        }else{
            self.predictionLabel.text = "TRASH"
            self.predictionLabel.textColor = UIColor(red:0.00, green:0.78, blue:0.37, alpha:1.0)
        }
    }
    
}

extension ViewController: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        if let pixelBuffer = pixelBuffer {
            // For better throughput, perform the prediction on a background queue
            // instead of on the VideoCapture queue. We use the semaphore to block
            // the capture queue and drop frames when Core ML can't keep up.
            semaphore.wait()
            DispatchQueue.global().async {
                self.predict(pixelBuffer: pixelBuffer)
            }
        }
    }
}

