//
//  LocationManager.swift
//  BMS
//
//  Created by pavan M. on 1/21/19.
//  Copyright © 2019 Sekhar n. All rights reserved.
//

import UIKit
import CoreLocation


class MyAddressModel {
    var name = ""
    var address1 = ""
    var address2 = ""
    var streetName = ""
    var city = ""
    var state = ""
    var country = ""
    var zipCode = ""
    var isoCountryCode = ""
    var coordinate = CLLocationCoordinate2D()
    
    
    
    func getCompleteAddress() -> String{
        var finalAddress = address1 + "," + address2 + "," + streetName + "," + city + "," + state + "," + country + "," + zipCode
        repeat {
            finalAddress = finalAddress.replace(",,", ",")

        } while finalAddress.contains(",,")
        
        if let first = finalAddress.first, first == "," {
            finalAddress.removeFirst()
        }
        
        return finalAddress
    }
    
}

protocol LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: NSError)
    func tracingEnteredRegion(currentLocation: CLRegion)
    func tracingExitedRegion(currentLocation: CLRegion)
}

class LocationService: NSObject {
    var locationManager = CLLocationManager()
    var lastLocation: CLLocation?
    var addressModel : MyAddressModel?
    
    var delegate: LocationServiceDelegate?
    static let shared = LocationService()
    var enablePopup = false
    
    override init() {
        super.init()
        // self.enablelocation()
    }
    
    func enablelocation(_ isMandatory:Bool = false){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.distanceFilter = 0.1
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        
        // locationManager.allowsBackgroundLocationUpdates = true
        
        if getPermission() == false {
            displayAlertWithTitleMessageAndTwoButtons(isMandatory)
        }
    }
    
    
    
    /// Get Permission from User
    func getPermission() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways:
            return true
        case .authorizedWhenInUse:
            return true
        case .notDetermined :
            return true
        case .denied, .restricted:
            return false
        @unknown default:
            return false
        }
    }
    
    func displayAlertWithTitleMessageAndTwoButtons(_ isMandatory:Bool){
        var actions = [UIAlertAction]()
        
        let settingsAction = UIAlertAction(title: "Settings", style: .destructive, handler: { (action) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        })
        

        if !isMandatory {
             let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            actions.append(cancelAction)
        }
        actions.append(settingsAction)
       
        CommonAlertView.shared.showAlert("Enable Location", "The location permission was not authorized. Please enable it in Settings to continue.", .Normal,actions)
    }
}

extension LocationService : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        getAddressFromLatLon(location: location)
        self.lastLocation = location
        self.stopUpdatingLocation()
        updateLocation(currentLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion){
        if Device.isDebuggerAttached() {
            print("The monitored regions are: \(manager.monitoredRegions)")
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered")
        if let region = region as? CLCircularRegion {
            // your logic to handle region-entered notification
            delegate?.tracingEnteredRegion(currentLocation: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited")
        if let region = region as? CLCircularRegion {
            // your logic to handle region-entered notification
            delegate?.tracingExitedRegion(currentLocation: region)
        }
    }
    
    @nonobjc func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }
    
    // Private function
    private func updateLocation(currentLocation: CLLocation){
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    private func updateLocationDidFailWithError(error: NSError) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocationDidFailWithError(error: error)
    }
    
    func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
    }
    
    func startMonitoringSignificantLocationChanges() {
        self.locationManager.startMonitoringSignificantLocationChanges()
    }
}


//MARK: Calculate Distance
extension LocationService {
    
    func deg2rad(deg:Double) -> Double {
        return deg * Double.pi / 180
    }
    
    func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / Double.pi
    }
    
    func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double, unit:String) -> Double {
        let theta = lon1 - lon2
        var dist = sin(deg2rad(deg: lat1)) * sin(deg2rad(deg: lat2)) + cos(deg2rad(deg: lat1)) * cos(deg2rad(deg: lat2)) * cos(deg2rad(deg: theta))
        dist = acos(dist)
        dist = rad2deg(rad: dist)
        dist = dist * 60 * 1.1515
        if (unit == "K") {
            dist = dist * 1.609344
        }
        else if (unit == "N") {
            dist = dist * 0.8684
        }
        return dist
    }
    
    
    func distance(_ lat:Double,_ long:Double) -> String{
        
        //        if let fromLocation = self.lastLocation {
        //            let meterDistance = fromLocation.distance(from: toLocation)
        //          //  let mileDistance = meterDistance / 1609.344
        //            let kmDistance = meterDistance / 1000
        //
        //            //  let distanceInMeters = meterDistance.rounded(toPlaces: 2)
        //            let distanceInKiloMeters = kmDistance.rounded(toPlaces: 2)
        //            // let distanceInMiles = mileDistance.rounded(toPlaces: 2)
        //
        //            return "\(distanceInKiloMeters) km"
        //        }else{
        //            self.startUpdatingLocation()
        //        }
        
        let distanceInKm = calculateDistanceInKm(lat, long)
        
        if distanceInKm > 0 {
            return "\(distanceInKm) km"
        }
        return ""
    }
    
    func calculateDistanceInKm(_ lat:Double,_ long:Double) -> Double{
       
            let toLocation = CLLocation(latitude: lat, longitude: long)
            
            if let fromLocation = self.lastLocation {
                let meterDistance = fromLocation.distance(from: toLocation)
                //  let mileDistance = meterDistance / 1609.344
                let kmDistance = meterDistance / 1000
                
                //  let distanceInMeters = meterDistance.rounded(toPlaces: 2)
                let distanceInKiloMeters = kmDistance.rounded(2)
                // let distanceInMiles = mileDistance.rounded(toPlaces: 2)
                
                return distanceInKiloMeters
            }
        
        return 0.0
    }
    
    
    
    
    func getAddressFromLatLon(location:CLLocation){
        
       
        
        let geoCoder = CLGeocoder()
        let currentAddress = MyAddressModel()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error == nil {
                if let placeMark = placemarks?.first {
                    // Location name
                    
                    
                    currentAddress.name = placeMark.name ?? ""
                    currentAddress.address1 = placeMark.thoroughfare ?? ""
                    currentAddress.address2 = placeMark.subThoroughfare ?? ""
                    currentAddress.streetName = placeMark.subLocality ?? ""
                    currentAddress.city = placeMark.locality ?? ""
                    currentAddress.state = placeMark.administrativeArea ?? ""
                    currentAddress.country = placeMark.country ?? ""
                    currentAddress.zipCode = placeMark.postalCode ?? ""
                    currentAddress.isoCountryCode = placeMark.isoCountryCode ?? ""
                    currentAddress.coordinate = location.coordinate
                    
                    self.addressModel = currentAddress
                    
                }
            }
        }
        
    }
    
    
}
