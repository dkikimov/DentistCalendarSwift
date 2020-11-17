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
                                if data.selectedDiagnosisList.contains(diag) {
                                    data.selectedDiagnosisList.remove(at: data.selectedDiagnosisList.firstIndex(of: diag)!)
                                } else {
                                    data.selectedDiagnosisList.append(diag)
                                }
                            },label: {
                                Text(diag.text ?? "Error").foregroundColor(data.selectedDiagnosisList.contains(diag) ? .blue : .black)
                            })
                        }
                        .onDelete(perform: deleteDiagnosis)
                        
                        
                        
                    }
                                        .listStyle(PlainListStyle())
                    
                    
                }
                if isAlertPresented {
                    AlertControlView(textString: $diagnosisText, showAlert: $isAlertPresented, action: {
                        addDiagnosis()
                    }, title: "Диагноз", message: "Введите название диагноза")
                }
            }
            
            .navigationBarTitle(Text("Диагноз"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Готово").foregroundColor(.blue)
            }), trailing: Button(action: {
                isAlertPresented = true
            }, label: {
                Image(systemName: "plus").foregroundColor(.blue)
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
                saveContext()
                diagnosisText = ""
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
