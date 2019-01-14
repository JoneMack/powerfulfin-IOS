//
//  DSLoactionManager.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/14.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
import CoreLocation

@objc protocol DSLocationDelegate {
    func userLocationDidUpdate(_ success:Bool,error:Error?)
}

class DSLocationManager: NSObject {
    
    fileprivate(set) var longitude: String = ""
    fileprivate(set) var latitude: String = ""
    
    let listeners:NSHashTable<DSLocationDelegate> = NSHashTable<DSLocationDelegate>(options: [.weakMemory,.objectPersonality])
    
    
    static let manager = DSLocationManager()
    
    override init() {
        super.init()
        BMKLocationAuth.sharedInstance()?.checkPermision(withKey: "qP6Ofv37A0Zv4CHNKHnh5F7XWdkFxsuS", authDelegate: self)        
    }
    var authStatus:CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    fileprivate lazy var locService:BMKLocationManager  = {
        var service = BMKLocationManager()
        service.coordinateType = .BMK09LL
        service.distanceFilter = kCLDistanceFilterNone
        service.desiredAccuracy = kCLLocationAccuracyBest
        service.activityType = .fitness
        service.pausesLocationUpdatesAutomatically = false
        service.locationTimeout =  10
        service.reGeocodeTimeout = 10
        service.locatingWithReGeocode = true
        return service
    }()
    
    func updateUserLoaction() {
        self.locService.requestLocation(withReGeocode: false, withNetworkState: true) { (location, networkState:BMKLocationNetworkState, error) in
            if let loca :BMKLocation = location {
                let longNum = NSNumber(value: loca.location?.coordinate.longitude ?? 0)
                let latNum = NSNumber(value: loca.location?.coordinate.latitude ?? 0)
                self.longitude = longNum.stringValue
                self.latitude = latNum.stringValue
                
                for delegate in self.listeners.allObjects {
                    delegate.userLocationDidUpdate(true, error: nil)
                }
            }else{
                for delegate in self.listeners.allObjects {
                    delegate.userLocationDidUpdate(false, error: error)
                }
            }
        }
    }
    func addListener(listen:DSLocationDelegate) {
        self.listeners.add(listen)
    }
    func removeListenner(listen:DSLocationDelegate) {
        if self.listeners.contains(listen) {
            self.listeners.remove(listen)
        }
    }
}
extension DSLocationManager:BMKLocationAuthDelegate {
    func onCheckPermissionState(_ iError: BMKLocationAuthErrorCode) {
    }
}
