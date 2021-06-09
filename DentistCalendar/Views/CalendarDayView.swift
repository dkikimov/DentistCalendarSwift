
import SwiftUI
import Amplify

struct CalendarDayView: View {
    @State var tabSelection: Tabs = .tab1
    @EnvironmentObject var modalManager: ModalManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State var activeView: DestinationTypes = .calendar
    var body: some View {
        //        VStack {
//        if UIDevice.current.userInterfaceIdiom == .phone {
            
            
            TabView(selection: $tabSelection) {
                
                CalendarKitView()
                    .tag(Tabs.tab1)
                    .tabItem({
                        Image(systemName: "calendar")
                        Text("Календарь")
                        
                    })
                
                PatientsListView()
                    .tag(Tabs.tab2)
                    .tabItem({
                        Image(systemName: "person.3.fill")
                        Text("Пациенты")
                    })
            }
            .transition(.opacity)
//        } else {
//            NavigationView {
//                List(DestinationTypes.allCases) { item in
////                    NavigationLink(destination: view(for: item)) {
//                        Label(item.title, systemImage: item.systemImageName)
//                            .onTapGesture {
//                                self.activeView = item
//                            }
////                    }
//                }.listStyle(SidebarListStyle())
//                view(for: activeView)
//            }
//
//        }
//
        
        //        BannerVC()
        //            .frame(width: 320, height: 50, alignment: .center)
        //        }
        //        }
        
        //            .navigationBarTitle(returnNaviBarTitle(tabSelection: self.tabSelection))//add the
        //            .navigationBarTitleDisplayMode(returnDisplayMode(tabSelection: self.tabSelection))
        //            .navigationBarColor(backgroundColor: UIColor(named: "Blue")!, tintColor: .white)
        //            .navigationBarItems(leading: tabSelection == .tab1 ? NavigationLink(destination: ProfileSettingsView(), label: {
        //                Image(systemName: "gearshape.fill").font(.title3)
        //            }) : nil)
    }
    @ViewBuilder
    func view(for destination: DestinationTypes) -> some View {
        switch destination {
        case .calendar:
            CalendarKitView()
        case .patients:
            PatientsListView()
        case .settings:
            ProfileSettingsView()
        }
    }
}
//func returnNaviBarTitle(tabSelection: Tabs) -> String{//this function will return the correct NavigationBarTitle when different tab is selected.
//    switch tabSelection{
//    case .tab1: return "Календарь"
//    case .tab2: return "Пациенты"
//    }
//}
//func returnDisplayMode(tabSelection: Tabs) -> NavigationBarItem.TitleDisplayMode{//this function will return the correct NavigationBarTitle when different tab is selected.
//    switch tabSelection{
//    case .tab1: return .inline
//    case .tab2: return .large
//    }
//}
//func returnBarItems(tabSelection: Tabs) ->  View? {
//    switch tabSelection{
//    case .tab1: return NavigationLink(destination: ProfileSettingsView(), label: {
//        Image(systemName: "gearshape.fill").font(.title3)
//    })
//    default: return nil
//    }
//}
