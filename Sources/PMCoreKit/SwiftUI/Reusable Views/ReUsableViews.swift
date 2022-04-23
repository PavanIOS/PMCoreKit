//
//  ReUsableViews.swift
//  Stock Jabber
//
//  Created by Pavan Maddineni on 29/08/21.
//  Copyright © 2021 sn99. All rights reserved.
//

import Foundation
import SwiftUI


struct NotificationNumLabel : View {
     var number = 0
    var showValue = true
    var body: some View {
        ZStack {
            
            if showValue {
            Capsule().fill(Color.red).frame(width: 30 * CGFloat(numOfDigits()), height: 45, alignment: .topTrailing).position(CGPoint(x: 150, y: 0))
            Text("\(number)")
                .foregroundColor(Color.white)
                .font(Font.system(size: 35).bold()).position(CGPoint(x: 150, y: 0))
            }else{
                Capsule().fill(Color.red).frame(width: 15, height: 15, alignment: .topTrailing)
                    //.position(CGPoint(x: 150, y: 0))
            }
        }
    }
    func numOfDigits() -> Float {
        let numOfDigits = Float(String(number).count)
        return numOfDigits == 1 ? 1.5 : numOfDigits
    }
}



extension View {
    func addVerifiedBadge(_ isVerified: Bool) -> some View {
        ZStack(alignment: .topTrailing) {
            self
            if isVerified {
                Image(systemName: "circlebadge.fill")
                    .foregroundColor(Color.red)
                    .font(.system(size: 15))
                    .offset(x: 2, y: -2)
            }
        }
    }
}

