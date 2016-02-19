//
//  TimerViewController.swift
//  OneHourWalker
//
//  Created by Matthew Maher on 2/18/16.
//  Copyright © 2016 Matt Maher. All rights reserved.
//

import UIKit
import CoreLocation

class TimerViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    
    var zeroTime = NSTimeInterval()
    var timer : NSTimer = NSTimer()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var lastLocation: CLLocation!
    var distanceTraveled = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization();
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            distanceTraveled = 0.0
            currentLocation = nil
            lastLocation = nil
            
        }
        else {
            print("Location service disabled");
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func startTimer(sender: AnyObject) {
        if (!timer.valid) {
            let aSelector : Selector = "updateTime"
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            zeroTime = NSDate.timeIntervalSinceReferenceDate()
            
            distanceTraveled = 0.0
            currentLocation = nil
            lastLocation = nil
            
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func stopTimer(sender: AnyObject) {
        timer.invalidate()
        locationManager.stopUpdatingLocation()
        distanceTraveled = 0.0
        currentLocation = nil
        lastLocation = nil
    }
    
    @IBAction func share(sender: AnyObject) {
        
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
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentLocation == nil {
            currentLocation = locations.first as CLLocation!
            lastLocation = locations.last as CLLocation!
        } else {
            let distance = currentLocation.distanceFromLocation(locations.last as CLLocation!)
            let lastDistance = lastLocation.distanceFromLocation(locations.last as CLLocation!)
            distanceTraveled += lastDistance * 0.000621371
            
            let trimmedDistance = String(format: "%.2f", distanceTraveled)
            
            print( "\(currentLocation)")
            print( "\(locations.last!)")
            print("FULL DISTANCE: \(trimmedDistance)")
//            print("FULL DISTANCE MILES: \(distanceTraveled)")
            print("STRAIGHT DISTANCE: \(distance)")
            
            milesLabel.text = "\(trimmedDistance) Miles"
        }
        lastLocation = locations.last as CLLocation!
    }

}
