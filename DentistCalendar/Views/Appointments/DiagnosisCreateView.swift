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
    @State var isAlertPresented = false
    @State var isErrorAlertPresented = false
    @State var error = ""
    @ObservedObject var data: AppointmentCreateViewModel
    @FetchRequest(sortDescriptors: [])
    var diagnosisList: FetchedResults<Diagnosis>
    
    @State var searchText = ""
    
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
                            DiagnosisRow(diag: diag)
                                .environmentObject(data)
                        }
                        .onDelete(perform: deleteDiagnosis)
                    }
                    .listStyle(PlainListStyle())
                    
                    
                }
                if isAlertPresented {
                    AlertControlView(alerts: [
                        .init(text: $diagnosisText, placeholder: "Название услуги"),
                        .init(text: $diagnosisPrice, placeholder: "Стоимость", keyboardType: .decimalPad)
                    ], showAlert: $isAlertPresented, action: {
                        addDiagnosis()
                    }, title: "Услуга", message: "Введите данные услуги")
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
            
            .navigationBarTitle(Text("Диагноз"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss()
                }
                
            }, label: {
                Text("Готово")
            }), trailing: Button(action: {
                isAlertPresented = true
            }, label: {
                Image(systemName: "plus")
            }))
            
        }
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
        diagnosisText = diagnosisText.trimmingCharacters(in: .whitespaces)
        guard diagnosisText != "" else { return }
        guard !diagnosisList.contains(where: { (diag) -> Bool in
            self.error = "Такой диагноз уже существует"
            return diag.text == diagnosisText
        }) else {return}
        guard diagnosisText.count <= 100 else {
            self.error = "Название услуги слишком длинное"
            isErrorAlertPresented = true
            return
        }
        withAnimation{
            let newDiagnosis = Diagnosis(context: viewContext)
            

            newDiagnosis.text = diagnosisText
            newDiagnosis.price = NSDecimalNumber(string: diagnosisPrice.isEmpty ? "0" : diagnosisPrice)
            saveContext()
            diagnosisText = ""
            diagnosisPrice = ""
        }
        
    }
    private func deleteDiagnosis(at offsets: IndexSet) {
        withAnimation{
            offsets.map {diagnosisList[$0]}.forEach(viewContext.delete)
            saveContext()
        }
        
    }
}
