//
//  View+Modifier.swift
//  GPKit
//
//  Created by sn99 on 28/03/22.
//

import Foundation
import SwiftUI




extension View {
    /// - Corner radius to any view
    public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    /// - To Appear only one time - View Did Load
    public func onFirstAppear( perform: @escaping () -> Void ) -> some View {
        return self.modifier(OnFirstAppearModifier(perform: perform))
    }
   
    /// - Hide keyboard when tap around the screen
    public func hideKeyboardWhenTappedAround() -> some View  {
        return self.onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
    /// - Skelton animation
    @ViewBuilder public func unredacted(when condition: Bool) -> some View {
        if condition {
            unredacted()
        } else {
            // Use default .placeholder or implement your custom effect
            redacted(reason: .placeholder)
        }
    }
    
    /// - Present Half Screen
    @ViewBuilder public func halfModel(offSet: CGSize) -> some View {
        let fullScreen = UIScreen.main.bounds
        var offSet1 = offSet
        self.animation(.spring())
            .gesture(
                DragGesture()
                    .onChanged{ gesture in
                        offSet1.height = gesture.translation.height
                        
                    }
                    .onEnded {
                        if $0.translation.height < fullScreen.size.height * 0.8 {
                            offSet1.height = fullScreen.size.height * 0.5
                        }else{
                            offSet1.height = fullScreen.size.height * 0.9
                        }
                    }
            )
    }
    
}

/// - To apply corner radius
public struct RoundedCorner: Shape {
    
    public var radius: CGFloat = .infinity
    public var corners: UIRectCorner = .allCorners
    
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

/// - Hide keyboard when tap around the screen
 struct OnFirstAppearModifier: ViewModifier {
    let perform:() -> Void
    @State private var firstTime: Bool = true
    
    func body(content: Content) -> some View {
        content
            .onAppear{
                if firstTime{
                    firstTime = false
                    self.perform()
                }
            }
    }
}


/// - Skelton animation
extension RedactionReasons {
    public static let text = RedactionReasons(rawValue: 1 << 2)
    public static let images = RedactionReasons(rawValue: 1 << 4)
}


/* -------------  Border  -------------- */
extension View {
    public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
        return overlay(RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(content, lineWidth: width))
    }
}
/* -------------  Border  -------------- */


extension View {
    public func makeButtonPadding() -> some View {
        return self
            .padding([.leading,.trailing],20)
            .padding([.top,.bottom],10)
    }
}
