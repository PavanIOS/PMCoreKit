//
//  Button.swift
//  Event Management
//
//  Created by sn99 on 06/07/21.
//

import SwiftUI

public struct CustomButtonStyle: ButtonStyle {
    var bgColor = Color.white
    var textColor = Color.black
    public func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .padding([.leading,.trailing], 15)
            .padding([.top,.bottom], 8)
            .background(bgColor)
            .foregroundColor(textColor)
            .opacity(configuration.isPressed ? 0.7 : 1)
           // .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.easeInOut(duration: 0.2))
            .cornerRadius(10)
    }
}

public struct TextButton : View {
    var handler: () -> Void
    var text = ""
    var bgColor = Color.green
    var txtColor = Color.white
    var fullWidth = false
    
    
    public var body: some View {
        
        Button {
            handler()
        } label: {
            if fullWidth {
                Text(text).foregroundColor(txtColor)
                    .padding([.leading,.trailing],20)
                    .padding([.top,.bottom],5).font(.headline)
                    .frame(maxWidth:.infinity,minHeight: 44)
            }
            else{
                Text(text).foregroundColor(txtColor)
                    .padding([.leading,.trailing],20)
                    .padding([.top,.bottom],5).font(.headline)
            }
        }
        .background(bgColor).cornerRadius(8)
        
    }
}



public struct ImageButton : View {
    var handler: (() -> Void?)? = nil
    var image : Image
    var bgColor = Color.green
    var color : Color? = nil
    
    public var body: some View {
        
        HStack {
            Spacer()
            Button {
                handler?()
            } label: {
                image
            }.background(bgColor).cornerRadius(5)
        }
    }
}
