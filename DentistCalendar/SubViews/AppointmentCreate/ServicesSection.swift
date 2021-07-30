//
//  ServicesSection.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 16.01.2021.
//

import SwiftUI
import AudioToolbox
import SwiftUIX


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
//        _ = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: textField)
//            .compactMap {
//                guard let field = $0.object as? UITextField else {
//                    return nil
//                }
//                return field.text
//            }
//            .sink {
//                self.text = $0
//            }
        return textField
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            uiView.text = text
        }
//        uiView.frame.size.width = uiView.intrinsicContentSize.width

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
            ForEach(Array(data.selectedDiagnosisList), id: \.key) { key, value in
                ServiceRow(key: key, item: value)
                    .environmentObject(data)
                    .id(key)
                        
                    
                }
            .onDelete(perform: { indexSet in
                DispatchQueue.main.async {
                    if let first = indexSet.first {
                        print("INDEX SET IS ", first)
                        let key = data.selectedDiagnosisList.keys.sorted()[first]
                        data.sumPrices -= (data.selectedDiagnosisList[key]!.price.decimalValue * Decimal(data.selectedDiagnosisList[key]!.amount))
                        data.selectedDiagnosisList.removeValue(forKey: key)
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
    
    func bindingPrice(for key: String) -> Binding<String> {
        return .init(
            get: {
                return self.data.selectedDiagnosisList[key]?.price ?? ""
            },
            set: {
                self.data.selectedDiagnosisList[key]!.price = $0
                 data.generateMoneyData.call()
            })
    }
    
    func bindingAmount(for key: String) -> Binding<Int> {
        return .init(
            get: {
                self.data.selectedDiagnosisList[key]!.amount
                
            }, set: {
                //                data.sumPrices -= Decimal(string: self.data.selectedDiagnosisList[key]!.price) ?? 0
                //                data.sumPrices += Decimal(string: $0) ?? 0
                
                
                self.data.selectedDiagnosisList[key]!.amount = $0
                
//                    let decimalNumber = Decimal($0)
//                    let amount = Decimal(data.selectedDiagnosisList[key]!.amount)
//                    let price = data.selectedDiagnosisList[key]!.price.decimalValue
//                    data.sumPrices -= (price * amount)
//                    data.sumPrices += (price * decimalNumber)
                
                                data.generateMoneyData.call()
            })
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
