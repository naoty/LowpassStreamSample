//
//  ViewController.swift
//  StreamSample
//
//  Created by Naoto Kaneko on 2014/09/28.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, JBLineChartViewDataSource, JBLineChartViewDelegate {
    let data: [CGFloat] = [0, 40, 20, 59, 98, 21, 53, 56, 89, 75, 45, 23, 2, 33]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lineChartView = JBLineChartView()
        lineChartView.frame = CGRectInset(view.frame, 20, 50)
        lineChartView.dataSource = self
        lineChartView.delegate = self
        view.addSubview(lineChartView)
        
        lineChartView.reloadData()
    }
    
    // MARK: - JBLineChartViewDataSource
    
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return 1
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        return UInt(data.count)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, widthForLineAtLineIndex lineIndex: UInt) -> CGFloat {
        return 2
    }
    
    // MARK: - JBLineChartViewDelegate
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        return data[Int(horizontalIndex)]
    }
}
