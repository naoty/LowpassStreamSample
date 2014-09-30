//
//  ViewController.swift
//  StreamSample
//
//  Created by Naoto Kaneko on 2014/09/28.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import UIKit
import CoreMotion
import Stream

class ViewController: UIViewController, JBLineChartViewDataSource, JBLineChartViewDelegate {
    let lineChartView = JBLineChartView()
    let motionManager = CMMotionManager()
    
    var x: [CGFloat] = []
    var filteredX: [CGFloat] = []
    let xStream = Stream<CGFloat>()
    
    private let bufferSize = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(lineChartView)
        lineChartView.frame = CGRectInset(view.frame, 20, 50)
        lineChartView.dataSource = self
        lineChartView.delegate = self
        
        xStream.subscribe { [unowned self] message in
            self.x.append(message)
        }
        
        let filteredStream: Stream<CGFloat> = xStream.map { message in
            return message * 2
        }.scan(0) { previousMessage, message in
            return previousMessage * 0.9 + message * 0.1
        }.subscribe { [unowned self] message in
            self.filteredX.append(message)
            
            if self.filteredX.count > self.bufferSize {
                self.x.removeAtIndex(0)
                self.filteredX.removeAtIndex(0)
            }
            
            self.lineChartView.reloadData()
        }
        
        motionManager.accelerometerUpdateInterval = 1 / 10 // 10Hz
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler: acceselerometerHandler)
    }
    
    private func acceselerometerHandler(data: CMAccelerometerData!, error: NSError!) {
        xStream.publish(CGFloat(data.acceleration.x))
    }
    
    // MARK: - JBLineChartViewDataSource
    
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return 2
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        switch lineIndex {
        case 0:
            return UInt(x.count)
        case 1:
            return UInt(filteredX.count)
        default:
            return 0
        }
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        switch lineIndex {
        case 0:
            return UIColor(red: 26 / 255, green: 188 / 255, blue: 156 / 255, alpha: 1)
        case 1:
            return UIColor(red: 52 / 255, green: 152 / 255, blue: 219 / 255, alpha: 1)
        default:
            return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func lineChartView(lineChartView: JBLineChartView!, widthForLineAtLineIndex lineIndex: UInt) -> CGFloat {
        return 2
    }
    
    // MARK: - JBLineChartViewDelegate
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        var value: CGFloat
        switch lineIndex {
        case 0:
            value = x[Int(horizontalIndex)]
        case 1:
            value = filteredX[Int(horizontalIndex)]
        default:
            value = 0
        }
        return abs(value)
    }
}
