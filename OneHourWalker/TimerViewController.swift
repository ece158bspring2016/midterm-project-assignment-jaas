//
//  TimerViewController.swift
//  OneHourWalker
//
//  Created by Matthew Maher on 2/18/16.
//  Copyright © 2016 Matt Maher. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    
    var zeroTime = NSTimeInterval()
    
    var timer : NSTimer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func startTimer(sender: AnyObject) {
        if (!timer.valid) {
            let aSelector : Selector = "updateTime"
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            zeroTime = NSDate.timeIntervalSinceReferenceDate()
        }
    }
    
    @IBAction func stopTimer(sender: AnyObject) {
        timer.invalidate()
    }
    
    @IBAction func resetTimer(sender: AnyObject) {
    }
    
    func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //
        //Find the difference between current time and start time.
        var elapsedTime: NSTimeInterval = currentTime - zeroTime
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        timerLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        
        if timerLabel.text == "60:00:00" {
            timer.invalidate()
        }
    }

}
