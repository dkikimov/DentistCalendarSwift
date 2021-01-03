
import SwiftUI
import Amplify

struct CalendarDayView: View {
    @State var tabSelection: Tabs = .tab1
    
    var body: some View {
            TabView(selection: $tabSelection) {
                CalendarKitView()
                    .tag(Tabs.tab1)
                    .tabItem({
                        Image(systemName: "calendar")
                        Text("Календарь")
                        
                    }).toolbar(content: {
                        ToolbarItem(placement: .status, content: {})
                    })
                
                
                PatientsListView()
                    .tag(Tabs.tab2)
                    .tabItem({
                        Image(systemName: "person.3.fill")
                        Text("Пациенты")
                    })
                
            }

//            .navigationBarTitle(returnNaviBarTitle(tabSelection: self.tabSelection))//add the
//            .navigationBarTitleDisplayMode(returnDisplayMode(tabSelection: self.tabSelection))
//            .navigationBarColor(backgroundColor: UIColor(named: "Blue")!, tintColor: .white)
//            .navigationBarItems(leading: tabSelection == .tab1 ? NavigationLink(destination: ProfileSettingsView(), label: {
//                Image(systemName: "gearshape.fill").font(.title3)
//            }) : nil)
            
        
        
        
        
    }
}
func returnNaviBarTitle(tabSelection: Tabs) -> String{//this function will return the correct NavigationBarTitle when different tab is selected.
    switch tabSelection{
    case .tab1: return "Календарь"
    case .tab2: return "Пациенты"
    }
}
func returnDisplayMode(tabSelection: Tabs) -> NavigationBarItem.TitleDisplayMode{//this function will return the correct NavigationBarTitle when different tab is selected.
    switch tabSelection{
    case .tab1: return .inline
    case .tab2: return .large
    }
}
//func returnBarItems(tabSelection: Tabs) ->  View? {
//    switch tabSelection{
//    case .tab1: return NavigationLink(destination: ProfileSettingsView(), label: {
//        Image(systemName: "gearshape.fill").font(.title3)
//    })
//    default: return nil
//    }
//}
