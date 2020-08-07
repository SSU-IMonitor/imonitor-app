//
//  ExamViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/08/07.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit
import SeeSo
import AVFoundation

class ExamViewController: UIViewController {
    var tracker: GazeTracker? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        if AVCaptureDevice .authorizationStatus(for: .video) == .authorized{
            GazeTracker.initGazeTracker(license: "dev_zjr3b5ffioy6jiynqtv99txxoi5dswqo6nukescw", delegate: self)
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: {
                response in
                if response{
                    GazeTracker.initGazeTracker(license: "dev_zjr3b5ffioy6jiynqtv99txxoi5dswqo6nukescw", delegate: self)
                }
            })
        }
        
    }
}

extension ExamViewController: InitializationDelegate{
    func onInitialized(tracker: GazeTracker?, error: InitializationError) {
        if(tracker != nil){
            self.tracker = tracker
            print("initialized Gaze Tracker")
            self.tracker?.statusDelegate = self
            self.tracker?.gazeDelegate = self
            self.tracker?.startTracking()
        } else {
            print("init failed: \(error.description)")
        }
    }
}

extension ExamViewController: StatusDelegate{
    func onStarted() {
        print("tracker starts tracking")
    }
    func onStopped(error: StatusError) {
        print("stop error: \(error.description)");
    }
}

extension ExamViewController: GazeDelegate{
    func onGaze(timestamp: Double, x: Float, y: Float, state: TrackingState) {
        print("timestamp: \(timestamp), (x, y): (\(x), \(y), state: \(state.description)")
    }
    func onFilteredGaze(timestamp: Double, x: Float, y: Float, state: TrackingState) {
        
    }
}
