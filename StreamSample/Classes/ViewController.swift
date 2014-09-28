//
//  ViewController.swift
//  StreamSample
//
//  Created by Naoto Kaneko on 2014/09/28.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController, JBLineChartViewDataSource, JBLineChartViewDelegate {
    let lineChartView = JBLineChartView()
    let motionManager = CMMotionManager()
    var x: [CGFloat] = []
    var y: [CGFloat] = []
    var z: [CGFloat] = []
    
    private let bufferSize = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lineChartView.frame = CGRectInset(view.frame, 20, 50)
        lineChartView.dataSource = self
        lineChartView.delegate = self
        view.addSubview(lineChartView)
        
        lineChartView.reloadData()
        
        motionManager.accelerometerUpdateInterval = 1 / 10 // 10Hz
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler: acceselerometerHandler)
    }
    
    private func acceselerometerHandler(data: CMAccelerometerData!, error: NSError!) {
        x.append(CGFloat(data.acceleration.x))
        y.append(CGFloat(data.acceleration.y))
        z.append(CGFloat(data.acceleration.z))
        
        if x.count > bufferSize {
            x.removeAtIndex(0)
            y.removeAtIndex(0)
            z.removeAtIndex(0)
        }
        
        lineChartView.reloadData()
    }
    
    // MARK: - JBLineChartViewDataSource
    
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return 3
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        switch lineIndex {
        case 0:
            return UInt(x.count)
        case 1:
            return UInt(y.count)
        case 2:
            return UInt(z.count)
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
        case 2:
            return UIColor(red: 230 / 255, green: 126 / 255, blue: 34 / 255, alpha: 1)
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
            value = y[Int(horizontalIndex)]
        case 2:
            value = z[Int(horizontalIndex)]
        default:
            value = 0
        }
        return abs(value)
    }
}
