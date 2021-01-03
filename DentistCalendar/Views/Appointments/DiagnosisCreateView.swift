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
    @ObservedObject var data: AppointmentCreateViewModel
    @FetchRequest(sortDescriptors: [])
    var diagnosisList: FetchedResults<Diagnosis>
    
    @State var searchText = ""
    
    var body: some View {
        NavigationView{
            ZStack {
                VStack {
                    SearchBarTest(text: $searchText, placeholder: "Поиск")
                    List {
                        ForEach(diagnosisList.filter {
                            searchText.isEmpty ||
                                $0.text!.localizedStandardContains(searchText)
                        }, id: \.self) { (diag) in
                            Button (action:{
                                if data.selectedDiagnosisList[diag.text!] != nil {
                                    data.selectedDiagnosisList.removeValue(forKey: diag.text!)
                                    data.generateMoneyData()
                                } else {
                                    data.selectedDiagnosisList[diag.text!] = Favor(price: diag.price, prePayment: "")
                                    data.generateMoneyData()
                                    print("SELECTED DIAGNOSIS LIST", data.selectedDiagnosisList)
                                }
                            },label: {
                                HStack {
                                    Text(diag.text ?? "Error").foregroundColor(data.selectedDiagnosisList[diag.text!] != nil ? .blue : Color("Black1"))
                                    Spacer()
                                    Text("Цена: " + String(diag.price))
                                        .foregroundColor(data.selectedDiagnosisList[diag.text!] != nil ? .blue : Color("Black1")).multilineTextAlignment(.trailing)
                                }
                            })
                        }
                        .onDelete(perform: deleteDiagnosis)
                    }
                    .listStyle(PlainListStyle())
                    
                    
                }
                if isAlertPresented {
                    AlertControlView(textString: $diagnosisText, priceString: $diagnosisPrice, showAlert: $isAlertPresented, action: {
                        addDiagnosis()
                    }, title: "Услуга", message: "Введите данные услуги")
                }
            }
            
            .navigationBarTitle(Text("Диагноз"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Готово")
            }), trailing: Button(action: {
                isAlertPresented = true
            }, label: {
                Image(systemName: "plus")
            }))
            
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
            
        } catch(let error) {
            print("Error when saving CoreData ", error)
        }
    }
    private func addDiagnosis() {
        if diagnosisText != "" {
            withAnimation{
                let newDiagnosis = Diagnosis(context: viewContext)
                newDiagnosis.text = diagnosisText.trimmingCharacters(in: .whitespaces)
                newDiagnosis.price = Int32(diagnosisPrice) ?? 0
                saveContext()
                diagnosisText = ""
                diagnosisPrice = ""
            }
        }
    }
    private func deleteDiagnosis(at offsets: IndexSet) {
        withAnimation{
            offsets.map {diagnosisList[$0]}.forEach(viewContext.delete)
            saveContext()
        }
        
    }
}
