//
//  TextFields.swift
//  Event Management
//
//  Created by sn99 on 17/07/21.
//

import Foundation
import SwiftUI




struct LabelTextField : View {
    
    @Binding var text: String
    var placeHolder: String
    
    var keyboardType = UIKeyboardType.default
    
    @State var errorText = ""
    
    var body: some View {
        
        VStack(alignment: .leading,spacing:5) {
            Text(placeHolder)
                .font(.headline).foregroundColor(Color.black)
            TextField(placeHolder, text: $text.onChange(onChangeText))
                .keyboardType(keyboardType)
                .disableAutocorrection(true)
                .padding(10)
                .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                .cornerRadius(5)
            
            
            if !errorText.isEmpty {
                ValidatorMessageInline(message: errorText)
            }
        }
        //.padding(.horizontal, 15)
    }
    
    func onChangeText(to value: String){
        if text.isEmpty {
            errorText = "\(placeHolder) can not be empty"
        }else {
            errorText = ""
        }
    }
}


struct PasswordTextField : View {
    
    @Binding var text: String
    var placeHolder: String
    @State var isSecured = true
    
    @State var errorText = ""
    
    var body: some View {
        
        VStack(alignment: .leading,spacing:5) {
            Text(placeHolder)
                .font(.headline).foregroundColor(Color.black)
            HStack {
                if isSecured {
                    SecureField(placeHolder, text: $text.onChange(onChangeText))
                        .padding(10).textContentType(.password)
                }else{
                    TextField(placeHolder, text: $text.onChange(onChangeText))
                        .padding(10)
                }
                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                    .accentColor(.gray).onTapGesture {
                        isSecured.toggle()
                    }.padding(.trailing,5)
            }
                .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                .cornerRadius(5)
            
            if !errorText.isEmpty {
                ValidatorMessageInline(message: errorText)
            }
        }
        //.padding(.horizontal, 15)
    }
    
    func onChangeText(to value: String){
        if text.isEmpty {
            errorText = "\(placeHolder) can not be empty"
        }else {
            errorText = ""
        }
    }
}




struct ExpandTextField : View {
    
    @Binding var text: String
    @Binding var isExpand : Bool
    var placeHolder: String
    
    var body: some View {
        
        VStack(alignment: .leading,spacing:5) {
            Text(placeHolder)
                .font(.headline).foregroundColor(Color.black).disabled(false)
            HStack {
                TextField(placeHolder, text: $text).disabled(true).ignoresSafeArea(.keyboard, edges: .bottom)
                Image(systemName: isExpand ? "chevron.up" : "chevron.down").resizable().frame(width: 13, height: 6)
            }
            .padding(10)
            .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
            .cornerRadius(5)
        }
        .padding(.horizontal, 15)
    }
}


struct DropdownTextLabel : View {
    
    var text: String
    var isSelected : Bool
    var bgColor = Color.white
    var body: some View {
        
        HStack(spacing:10) {
            Text(text).multilineTextAlignment(.leading).font(.subheadline).lineLimit(2).frame(maxWidth:.infinity)
            // Spacer().background(Color.green).frame(height:1)
            // if isSelected {
            Image(systemName: "checkmark").resizable().frame(width: 16, height: 13).foregroundColor(isSelected ? Color.blue : Color.clear).padding(.trailing,5)
            // }
        }
        .padding([.top,.bottom],5)
        .background(bgColor)
        
        Divider()
    }
}




struct ValidatorMessageInline: View {
    
    var message:String?
    
    var body: some View {
        HStack {
            Text( message ?? "")
            .fontWeight(.light)
            .font(.footnote)
            .foregroundColor(Color.red)
            
            if message != nil  {
                Image( systemName: "exclamationmark.triangle")
                    .foregroundColor(Color.red)
                    .font(.footnote)
            }
            
        }
    }
}



struct CustomTextEditor: View {
   let placeholder: String
   @Binding var text: String
   let internalPadding: CGFloat = 5
   var body: some View {
       ZStack(alignment: .topLeading) {
           if text.isEmpty  {
               Text(placeholder)
                   .foregroundColor(Color.primary.opacity(0.25))
                   .padding(EdgeInsets(top: 7, leading: 4, bottom: 0, trailing: 0))
                   .padding(internalPadding)
           }
           TextEditor(text: $text)
               .padding(internalPadding)
       }.onAppear() {
           UITextView.appearance().backgroundColor = .clear
       }.onDisappear() {
           UITextView.appearance().backgroundColor = nil
       }
      
   }
    
   
}

struct HomePageTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
           
    }
}



//struct SearchBar: View {
//
//    @Binding var searchText: String
//    @Binding var searching: Bool
//
//    var body: some View {
//        ZStack {
//            Rectangle()
//                .foregroundColor(Color("LightGray"))
//            HStack {
//                Image(systemName: "magnifyingglass")
//                TextField("Search ..", text: $searchText) { startedEditing in
//                    if startedEditing {
//                        withAnimation {
//                            searching = true
//                        }
//                    }
//                } onCommit: {
//                    withAnimation {
//                        searching = false
//                    }
//                }
//            }
//            .foregroundColor(.gray)
//            .padding(.leading, 13)
//        }
//            .frame(height: 40)
//            .cornerRadius(13)
//            .padding()
//    }
//}


struct SearchBar: View {
    @Binding var text: String

    @State private var isEditing = false
        
    var body: some View {
        HStack {
            
            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing {
                            Button(action: {
                                self.text = ""
                                
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    
                    // Dismiss the keyboard
                    UIApplication.shared.endEditing()
                   // sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}
