//
//  ReUsableViews.swift
//  Stock Jabber
//
//  Created by Pavan Maddineni on 29/08/21.
//  Copyright © 2021 sn99. All rights reserved.
//

import Foundation
import SwiftUI
import AVKit


public struct NotificationNumLabel : View {
     var number = 0
    var showValue = true
    public var body: some View {
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



public extension View {
    public func addVerifiedBadge(_ isVerified: Bool) -> some View {
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




public struct DescriptionInfoView : View {
//    @Binding var isPresented : Bool
    
    @Environment(\.presentationMode) var presentationMode
    var screenName = ""
    var desc = ""
    
    
    public var body : some View {
        InfoView
    }
    
    var InfoView : some View {
        
        VStack {
            ScrollView{
                Text(desc)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .navigationBarHidden(false)
        .navigationBarTitle(screenName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

public struct PresentDescriptionInfoView : View {
    @Binding var isPresented : Bool
    
    @Environment(\.presentationMode) var presentationMode
    var screenName = ""
    var desc = ""
    
    
    public var body : some View {
        InfoView
    }
    
    var InfoView : some View {
        
        VStack {
            Text(screenName).font(.title).foregroundColor(Color.green)
            Divider()
            ScrollView{
                Text(desc)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            
            TextButton(handler: closeButtonClicked, text: "Close", bgColor: Color.blue, txtColor: Color.white,fullWidth: true)
                
            
        }
        
        .padding()
        .navigationBarTitle(screenName)
        .navigationBarTitleDisplayMode(.inline)
        
        .navigationBarItems(trailing:
                                Button {
                                    closeButtonClicked()
                                } label: {
                                    Image(systemName:"xmark.circle").font(.title2)
                                }
        )
    }
    
    func closeButtonClicked(){
        isPresented.toggle()
        presentationMode.wrappedValue.dismiss()
    }
}


/* ---------------  Small Line for Presented Views ------------------ */
public struct ReUsableCapsule : View {
    
    let radius: CGFloat = 16
    let indicatorHeight: CGFloat = 5
    let indicatorWidth: CGFloat = 40
    let snapRatio: CGFloat = 0.25
    let minHeightRatio: CGFloat = 0.3
    
    var fillColor = Color(.lightGray)
    
    public var body : some View {
        
        Capsule()
            .fill(fillColor)
            .frame(
                width: indicatorWidth,
                height: indicatorHeight
            )
    }
}



/* ---------------  Rating view ------------------ */
//MARK:-Rating View
public struct RatingView : View {
    @Binding var rating : String
    
    var label = ""
    
    var maximumRating = 5
    
    var offImage: Image?
    var onImage = SystemImages.star_fill.toImage()
    
    
    var offColor = Color(.systemGray3)
    var onColor = Color.yellow
    
    
    
    public var body: some View {
        VStack(alignment: .leading, spacing:5) {
            if label.isEmpty == false {
                Text(label)
            }
            HStack {
                ForEach(1..<maximumRating + 1) { number in
                    self.image(for: number).font(.title)
                        
                        .foregroundColor(number > self.rating.intValue ? self.offColor : self.onColor)
                        .animation(.default)
                        .onTapGesture {
                            self.rating = number.stringValue
                        }
                }
            }
        }
    }
    
    
    public func image(for number: Int) -> Image {
        if number > rating.intValue {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}



/* ---------------  Keyboard responder ------------------ */
final public class KeyboardResponder: ObservableObject {
    @Published private(set) var currentHeight: CGFloat = 0
    
    private var notificationCenter: NotificationCenter
    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    
    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
        }
    }
    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
    }
}


public struct KeyboardManagement: ViewModifier {
    @ObservedObject var keyboard = KeyboardResponder()
    public func body(content: Content) -> some View {
        content
            .padding(.bottom,keyboard.currentHeight)
    }
}

public extension View {
    func keyboardManagement() -> some View {
        self.modifier(KeyboardManagement())
    }
}
/*  --------------------------------------------------  */


public struct VideoPlayerView : View {
    
    @State private var avPlayer : AVPlayer?
    
    var videoLink = ""
    var height : CGFloat = 250
    public var body : some View {
        if let finalUrl = videoLink.toUrl {
            
            VideoPlayer(player: avPlayer)
                
                .frame(height:height)
                .onAppear() {
                    let player = AVPlayer(url: finalUrl)
                    self.avPlayer = player
                   // player.play()
                }
                .onDisappear {
                    avPlayer?.pause()
                }
        }
    }
}
