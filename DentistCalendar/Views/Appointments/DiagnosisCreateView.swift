//
//  DiagnosisCreateView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 11/12/20.
//

import SwiftUI
struct DiagnosisCreateView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @State var diagnosisText = ""
    @State var diagnosisPrice = ""
    @State var diagnosisID = ""
    @State var isAlertPresented = false
    @State var isErrorAlertPresented = false
    @State var error = ""
    @ObservedObject var data: AppointmentCreateViewModel
    @FetchRequest(sortDescriptors: [])
    var diagnosisList: FetchedResults<Diagnosis>
    
    @State var searchText = ""
    @State var selectedDiagnosis: Diagnosis?
    @State var selectedDiagnosisItem: DiagnosisItem?
    var body: some View {
        NavigationView{
            ZStack {
                VStack {
                    SearchBarTest(text: $searchText, placeholder: "Поиск".localized)
                    List {
                        ForEach(diagnosisList.filter {
                            searchText.isEmpty ||
                                $0.text!.localizedStandardContains(searchText)
                        }, id: \.self) { (diag) in
                            DiagnosisRow(selectedDiagnosis: $selectedDiagnosis, selectedDiagnosisItem: $selectedDiagnosisItem, diag: diag)
                                .environmentObject(data)
                        }
                        .onDelete(perform: deleteDiagnosis)
                    }
                    .listStyle(PlainListStyle())
                    
                    
                }
                if isAlertPresented {
                    AlertControlView(fields: [
                        .init(text: $diagnosisText, placeholder: "Название услуги"),
                        .init(text: $diagnosisPrice, placeholder: "Стоимость", keyboardType: .decimalPad)
                    ], showAlert: $isAlertPresented, action: {
                        addDiagnosis()
                    }, cancelAction: {
                        print("CANCEL")
//                        if selectedDiagnosisItem != nil {
//                            data.selectedDiagnosisList.append(selectedDiagnosisItem
//                        }
                        selectedDiagnosisItem = nil
                        selectedDiagnosis = nil
                    } ,title: "Услуга", message: "Введите данные услуги", selectedDiagnosis: $selectedDiagnosis, data: ObservedObject.init(wrappedValue: data))
                    //                    AlertControlView(textString: $diagnosisText, priceString: $diagnosisPrice, showAlert: $isAlertPresented, action: {
                    //                        addDiagnosis()
                    //                    }, title: "Услуга", message: "Введите данные услуги")
                }
            }
            .onDisappear(perform: {
                DispatchQueue.main.async {
                    data.generateMoneyDataFunc()
                }
            })
            .onChange(of: selectedDiagnosis, perform: { newValue in
                if let newValue = newValue {
                    self.diagnosisText = newValue.text ?? ""
                    self.diagnosisPrice = newValue.price!.description(withLocale: Locale.current)
                    self.isAlertPresented = true
                }
            })
            .navigationBarTitle(Text("Диагноз"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                           presentationMode.wrappedValue.dismiss()
                   }, label: {
                       Text("Готово")
                        .bold()
                   })
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        isAlertPresented = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())

        .alert(isPresented: $isErrorAlertPresented, content: {
            Alert(title: Text("Ошибка"), message: Text(error), dismissButton: .cancel())
        })
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
            
        } catch(let error) {
            print("Error when saving CoreData ", error)
        }
    }
    private func addDiagnosis() {
        let decimalString = diagnosisPrice.decimalValue.stringValue
        
        diagnosisText = diagnosisText.trimmingCharacters(in: .whitespaces)
        guard !diagnosisText.isEmpty else { return }
        guard diagnosisText.count <= serviceNameMaxLength else {
            self.error = "Название услуги слишком длинное"
            isErrorAlertPresented = true
            diagnosisError()
            return
        }
        guard decimalString.count <= priceMaxLength else {
            self.error = "Цена слишком большая"
            isErrorAlertPresented = true
            diagnosisError()
            
            return
        }
        let diagnosis: Diagnosis
        var isUpdating = false
        if let selDiagnosis = selectedDiagnosis {
            diagnosis = selDiagnosis
            isUpdating = true
        } else {
            guard !diagnosisList.contains(where: { (diag) -> Bool in
                let res = (diag.text == diagnosisText)
                return res
            }) else {
                self.error = "Такой диагноз уже существует"
                diagnosisError()
                return
            }
            
            diagnosis = Diagnosis(context: viewContext)
        }
        withAnimation{
            if isUpdating {
                if let item = data.selectedDiagnosisList.first(where: {
                    $0.key == diagnosis.text
                }) {
                    let tempIndex = data.selectedDiagnosisList.firstIndex { $0.key == item.key}
                    if tempIndex != nil {
                        data.selectedDiagnosisList.remove(at: tempIndex!)
                    }
                }
                
                data.selectedDiagnosisList.append(DiagnosisItem(key: diagnosisText, amount: (selectedDiagnosisItem?.amount ?? 1), price: decimalString))
            }
            diagnosis.text = diagnosisText
            diagnosis.price = NSDecimalNumber(string: decimalString.isEmpty ? "0" : decimalString, locale: Locale.current)
            saveContext()
            diagnosisError()
        }
        
    }
    private func diagnosisError() {
        diagnosisText = ""
        diagnosisPrice = ""
        selectedDiagnosis = nil
        selectedDiagnosisItem = nil
    }
    private func deleteDiagnosis(at offsets: IndexSet) {
        withAnimation{
            offsets.map {diagnosisList[$0]}.forEach(viewContext.delete)
            saveContext()
        }
        
    }
}
