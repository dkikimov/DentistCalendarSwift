
import SwiftUI
import Amplify

struct CalendarDayView: View {
    let user: AuthUser
    var body: some View {
            TabView {
                CalendarKitView(user: user).tabItem({
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

