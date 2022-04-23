//
//  KeyboardDismissModifier.swift
//  CosmoDriver
//
//  Created by sn99 on 10/04/22.
//  Copyright © 2022 Gpinfotech. All rights reserved.
//



import SwiftUI

@available(iOS 13, *)
public struct KeyboardDismissModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        content.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

@available(iOS 13, *)
public extension TextField {
    /// Dismiss the keyboard when pressing on something different then a form field
    /// - Returns: KeyboardDismissModifier
    public func hideKeyboardOnTap() -> ModifiedContent<Self, KeyboardDismissModifier> {
        return modifier(KeyboardDismissModifier())
    }
}
