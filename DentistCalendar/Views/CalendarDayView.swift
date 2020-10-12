
import SwiftUI
struct CalendarDayView: View {
    var body: some View {
            TabView {
                CalendarDisplayDayView().tabItem({
                        Image(systemName: "calendar")
                        Text("Календарь")
                        
                    }).tabViewStyle(PageTabViewStyle())
                
                PatientsListView().tabItem({
                    Image(systemName: "person.3.fill")
                    Text("Пациенты")
                })
            }
            
        
        
    }
}

