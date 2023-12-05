//
//  WhiskeyEditTextField.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 10/31/23.
//

import SwiftUI

struct WhiskeyEditTextField: View {
    
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        TextField(placeholder, text: $text, prompt: Text(placeholder))
            .font(.customRegular(size: 20))
    }
}

#Preview {
    WhiskeyEditTextField(text: .constant("Label"), placeholder: "Pikesville")
}
