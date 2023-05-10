
import SwiftUI
import Amplify
import ApphudSDK
import Appodeal

struct CalendarDayView: View {
    @State var tabSelection: Tabs = .tab1
    @StateObject var modalManager = ModalManager()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State var activeView: DestinationTypes = .calendar
    @AppStorage("introductionInstruction") var isWalkthroughPresented = true
    
    var body: some View {
        TabView(selection: $tabSelection) {
            
            CalendarKitView()
                .tag(Tabs.tab1)
                .tabItem({
                    Image(systemName: "calendar")
                    Text("Календарь")
                    
                })
                .environmentObject(modalManager)
            
            PatientsListView()
                .tag(Tabs.tab2)
                .tabItem({
                    Image(systemName: "person.3.fill")
                    Text("Пациенты")
                })
        }
        .slideOverCard(isPresented: $modalManager.isDatePickerPresented, content: {
            DatePicker("", selection: $modalManager.selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
        })
        .transition(.opacity)
        .fullScreenCover(isPresented: $isWalkthroughPresented, content: {
            WalktroughView(isWalkthroughViewShowing: $isWalkthroughPresented)
        })
        .onAppear {
            let userID = Amplify.Auth.getCurrentUser()!.userId
            
            Apphud.updateUserID(userID)
            if Apphud.hasActiveSubscription() {
                Appodeal.setAutocache(false, types: .interstitial)
            }
        }
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
