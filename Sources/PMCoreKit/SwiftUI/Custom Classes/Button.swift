//
//  Button.swift
//  Event Management
//
//  Created by sn99 on 06/07/21.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    var bgColor = Color.white
    var textColor = Color.black
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .padding([.leading,.trailing], 15)
            .padding([.top,.bottom], 5)
            .background(bgColor)
            .foregroundColor(textColor)
            .opacity(configuration.isPressed ? 0.7 : 1)
           // .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.easeInOut(duration: 0.2))
            .cornerRadius(5)
    }
}




struct TextButton : View {
    var handler: () -> Void
    var text = ""
    
    var bgColor = Color.black
    
    var body: some View {
        
        HStack {
            Spacer()
            Button {
                handler()
            } label: {
                Text(text).foregroundColor(.white)
                    .makeButtonPadding()
                    //.padding([.leading,.trailing],20).padding([.top,.bottom],10)
            }.background(bgColor).cornerRadius(5)
        }
        
    }
}

struct PlainTextButton : View {
    var text = ""
    
    var bgColor = Color.black
    
    var body: some View {
            
            Text(text).foregroundColor(.white)
            .padding([.leading,.trailing],20)
            .padding([.top,.bottom],10)
            background(bgColor).cornerRadius(5)
    }
}
