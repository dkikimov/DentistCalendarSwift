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
        Group {
            if data.eventsList.count > 0{
                List( selection: $data.selectedEvents) {
                    ForEach(data.eventsList, id: \.self) { event in
                        Text(event.title).id(UUID().uuidString)
                    }.id(UUID().uuidString)
                }.id(UUID().uuidString)
                
            }
            
            else {
                Text("Нет данных")
            }
        }
        .sheet(isPresented: $data.isSheetPresented, content: {
            EventCalendarChooserView(calendars: $data.calendars, eventStore: data.eventStore, fetchEvents: data.getEvents)
        })
        .environment(\.editMode, $data.isEditMode)
        .navigationBarItems(trailing: Button(action: {
            data.addEvents()
        }, label: {
            data.isLoading ? Text("Загрузка").disabled(true) as! Text : Text("Добавить")
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
