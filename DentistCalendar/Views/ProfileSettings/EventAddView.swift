//
//  EventAddView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 28.11.2020.
//

import SwiftUI

struct EventAddView: View {
    @StateObject var data = EventAddViewModel()
    var body: some View {
        ZStack {
            if data.isLoading {
                Color.gray
                    .edgesIgnoringSafeArea(.all)
                
                ProgressView()
            }
            Group {
                if data.eventsList.count > 0{
                    List {
                        ForEach(data.eventsList, id: \.self) { event in
                            MultipleSelectionRow(title: event.title, isSelected: self.data.selectedEvents.contains(event), action:  {
                                if self.data.selectedEvents.contains(event) {
                                    self.data.selectedEvents.removeAll(where: { $0 == event })
                                }
                                else {
                                    self.data.selectedEvents.append(event)
                                }
                            })
                        }
                        
                    }
                }
                else if !data.errorText.isEmpty {
                    Text(data.errorText)
                }
                else if data.eventsList.count == 0 && !data.isLoading {
                    Text("Нет данных")
                }
            }
            .onAppear(perform: {
                data.requestAccess { (status, err) in
                    if status && !data.wasCalled {
                        data.wasCalled = true
                        data.isSheetPresented = true
                    }
                }
            })
            .sheet(isPresented: $data.isSheetPresented, content: {
                EventCalendarChooserView(calendars: $data.calendars, eventStore: data.eventStore, fetchEvents: data.getEvents)
            })
        }
        
        //        .environment(\.editMode, $data.isEditMode)
        .navigationBarItems(trailing: Button(action: {
            data.addEvents()
        }, label: {
            data.isLoading ?  Text("Загрузка...") : Text("Добавить")
        }))
        .navigationBarTitle("Импорт записей", displayMode: .inline)
        //        .onAppear(perform: data.getEvents)
        
    }
    
}

struct EventAddView_Previews: PreviewProvider {
    static var previews: some View {
        EventAddView()
    }
}
