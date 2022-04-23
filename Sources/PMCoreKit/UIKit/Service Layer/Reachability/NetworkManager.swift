//
//  NetworkManager.swift
//  EveryBooking
//
//  Created by sn99 on 22/02/20.
//

import Foundation


public class NetworkManager : NSObject {
    static let shared = NetworkManager()
    var reachability: Reachability!
    
    override init() {
        super.init()
        
        reachability = try! Reachability()
        
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(networkStatusChanged(_:)),
                    name: .reachabilityChanged,
                    object: reachability
                )
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
        // print("Network status changed")
    }
    
    static func stopNotifier() -> Void {
        do {
            try (NetworkManager.shared.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
    static func isReachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.shared.reachability).connection != .unavailable {
            completed(NetworkManager.shared)
        }
    }
    
    static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.shared.reachability).connection == .unavailable {
            completed(NetworkManager.shared)
        }
    }
    
    static func isReachableViaWWAN(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.shared.reachability).connection == .cellular {
            completed(NetworkManager.shared)
        }
    }
    
    static func isReachableViaWiFi(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.shared.reachability).connection == .wifi {
            completed(NetworkManager.shared)
        }
    }
    
    
    func isReachable() -> Bool{
        do
        {
            let reachability = try Reachability()
            return reachability.connection != .unavailable
        }catch _ {
            return false
        }
    }
    
    
}
