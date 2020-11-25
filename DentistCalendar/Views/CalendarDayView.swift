
import SwiftUI
import Amplify

struct CalendarDayView: View {
    var body: some View {
            TabView {
                CalendarKitView().tabItem({
                        Image(systemName: "calendar")
                        Text("Календарь")
                        
                    })
                
                PatientsListView().tabItem({
                    Image(systemName: "person.3.fill")
                    Text("Пациенты")
                })
            }
            
        
        
    }
}

