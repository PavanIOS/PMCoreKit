//
//  Toast.swift
//  GPDoctorPlus
//
//  Created by sn99 on 20/06/20.
//  Copyright © 2020 sn99. All rights reserved.
//



import Foundation
import UIKit

class PriorityQueue {
  lazy var queue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    queue.name = "Toast queue"
    return queue
  }()
}

class Toast: Operation {
  
  let toast:ToastView
  let delay:TimeInterval
  let position:ToastPosition
  

  init(view: ToastView, duration: TimeInterval, position:ToastPosition) {
    self.toast = view
    self.position = position
    self.delay = duration
  }
  
  override open func main() {
    
    DispatchQueue.main.async {
      do {
        guard let window = UIApplication.shared.keyWindow else { throw ToastError.windowNotLoaded }
        window.addSubview(self.toast)
        self.toast.setupViewLayout(self.toast, window, self.position)
      } catch ToastError.windowNotLoaded {
        print("Window not loaded yet")
      } catch {}
    }
    
    sleep(UInt32(self.delay))
    
    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.5, delay: self.delay, options: .curveEaseOut, animations: {
        self.toast.alpha = 1.0
      }, completion: { _ in
        self.toast.alpha = 0.0
        self.toast.removeFromSuperview()
      })
    }

  }
  
}
