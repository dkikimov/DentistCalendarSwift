//
//  ServicesSection.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 16.01.2021.
//

import SwiftUI


struct BottomLinedTextField: UIViewRepresentable {
    @Binding var text: String
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
    
    func makeUIView(context: Context) -> some UITextField {
        let textField = UITextField(frame: .zero)
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textField.frame.height - 1, width: textField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        textField.borderStyle = UITextField.BorderStyle.none
        textField.layer.addSublayer(bottomLine)
        textField.text = text
        textField.placeholder = "0"
        textField.keyboardType = .decimalPad
        textField.delegate = context.coordinator
        return textField
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            uiView.text = text
        }
    }
    
}

extension BottomLinedTextField {
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.text = textField.text ?? ""
            }
            
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                       replacementString string: String) -> Bool
        {
            if text.count > priceMaxLength {
                let currentText = text
                guard let stringRange = Range(range, in: currentText) else { return false }
                let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
                return updatedText.count <= priceMaxLength
            } else {
                return true
            }
        }
    }
}

struct ServicesSection: View {
    @AppStorage("dontShowAlert") var dontShownAlert = false
    @EnvironmentObject var data: AppointmentCreateViewModel
    @State var error = ""
    @State var isAlertPresented = false
    @State var wasAlertChecked = false
    @State var isEditing = false
    var body: some View {
        Section(header: Text("Услуги")) {
            HStack {
                Text("Номер зуба") + Text(":")
                
                TextField("15", text: $data.toothNumber)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            
            ForEach(data.selectedDiagnosisList) { diag in
                ServiceRow(item: diag)
                    .environmentObject(data)
                }
            .onDelete(perform: { indexSet in
                DispatchQueue.main.async {
                    if let first = indexSet.first {
                        print("INDEX SET IS ", first)
                        data.sumPrices -= (data.selectedDiagnosisList[first].price.decimalValue * Decimal(data.selectedDiagnosisList[first].amount))
                        data.selectedDiagnosisList.remove(at: first)
                    }
                    
                }
            })
            Button(action: {
                data.isDiagnosisCreatePresented.toggle()
            }, label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Добавить услугу")
                }
            })
            .disabled(data.selectedDiagnosisList.count >= servicesMaxCount)
        }
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text("Ошибка"), message: Text(error), primaryButton: .cancel(Text("OK")), secondaryButton: .default(Text("Больше не показывать")) {
                dontShownAlert = true
            })
        }
    }
}

struct ServicesSection_Previews: PreviewProvider {
    static var previews: some View {
        ServicesSection()
            .environmentObject(AppointmentCreateViewModel(patient: Patient(id: "", fullname: "", phone: ""), viewType: .editCalendar, appointment: Appointment(id: "", title: "", patientID: "", toothNumber: "", diagnosis: "Пульпит:2000*2;Игра:1000*3", dateStart: "100", dateEnd: "200", payments: nil), dateStart: Date(), dateEnd: Date(), group: nil))
    }
}
//let decimalString = $0.decimalValue
//                let amount = Decimal(data.selectedDiagnosisList[key]!.amount)
//                let price = data.selectedDiagnosisList[key]!.price.decimalValue
//                //                guard $0.count < 15   else {
//                //                    AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { return }
//                //                    if !wasAlertChecked && !dontShownAlert {
//                //                        error = "Цена слишком большая"
//                //                        isAlertPresented = true
//                //                    }
//                //                    return
//                //                }
//                data.sumPrices -= (price * amount)
//                data.sumPrices += (decimalString * amount)
