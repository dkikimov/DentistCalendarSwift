//
//  CodeInputView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 28.02.2021.
//

import SwiftUI

struct CodeInputView: View {
    @ObservedObject var inputModel: PassCodeInputModel
    var body: some View {
        HStack(spacing: 15){
            
            ForEach(0..<6,id: \.self){index in
                
                // displaying code....
                
                CodeView(code: getCodeAtIndex(index: index))
            }
            TextField("", text: $inputModel.code)
                .frame(width: 0, height: 0)
                .keyboardType(.numberPad)
            .introspectTextField { textField in
                textField.becomeFirstResponder()
            }
        }
        .padding()
        .padding(.horizontal,20)
    }
    func getCodeAtIndex(index: Int)->String{
        if inputModel.code.count > index{
            
            let start = inputModel.code.startIndex
            
            let current = inputModel.code.index(start, offsetBy: index)
            
            return String(inputModel.code[current])
        }
        
        return ""
    }
}
