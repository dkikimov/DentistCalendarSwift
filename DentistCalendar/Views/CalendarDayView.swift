
import SwiftUI
import KVKCalendar
struct CalendarDisplayView: UIViewRepresentable {
    
    var token: String?
    var selectDate: Date?
    var toggleDetail: (Event) -> ()
    var dateFormat = Style().timeHourSystem.format
    
    public init(token: String?, selectDate: Date?, toggleDetail: @escaping (Event) -> ()) {
        self.token = token
        self.selectDate = selectDate
        self.toggleDetail = toggleDetail
    }
    public var calendar: CalendarView = {
        var style = Style()
        if UIDevice.current.userInterfaceIdiom == .phone {
            style.timeline.widthTime = 40
            style.timeline.currentLineHourWidth = 35
            style.timeline.offsetTimeX = 2
            style.timeline.offsetLineLeft = 2
        } else {
            style.timeline.widthEventViewer = 500
        }
        style.followInSystemTheme = true
        style.timeline.offsetTimeY = 80
        style.timeline.offsetEvent = 3
        style.timeline.currentLineHourWidth = 35
        style.startWeekDay = .monday
        style.timeHourSystem = .twelveHour
        style.headerScroll.colorBackground = UIColor(.blue)
        style.headerScroll.colorTitleDate = UIColor(.white)
        style.headerScroll.colorWeekendDate = UIColor(.white)
        style.headerScroll.colorCurrentDate = UIColor(.white)
        style.headerScroll.colorDate = UIColor(.white)
        style.locale = Locale.current
        style.timezone = TimeZone.current
        return CalendarView(frame: UIScreen.main.bounds, style: style)
    }()
    
    func makeUIView(context: UIViewRepresentableContext<CalendarDisplayView>) -> CalendarView {
        calendar.dataSource = context.coordinator
        calendar.delegate = context.coordinator
        calendar.scrollTo(self.selectDate ?? Date())
        calendar.reloadData()
        return calendar
    }
    
    func updateUIView(_ uiView: CalendarView, context: UIViewRepresentableContext<CalendarDisplayView>) {
        
    }
    
    func makeCoordinator() -> CalendarDisplayView.Coordinator {
        Coordinator(self, token: token, selectDate: selectDate, toggleDetail: toggleDetail)
    }
    
    class Coordinator: NSObject, CalendarDataSource, CalendarDelegate {
        private var view: CalendarDisplayView
        
        var token: String?
        var selectDate: Date?
        var toggleDetail: (Event) -> ()
        private var events = [Event]()
        @State var open = true
        
        init(_ view: CalendarDisplayView, token: String?, selectDate: Date?, toggleDetail: @escaping (Event) -> ()) {
            self.view = view
            self.token = token
            self.selectDate = selectDate
            self.toggleDetail = toggleDetail
            super.init()
            
            loadEvents { (events) in
                self.events = events
                self.view.calendar.reloadData()
            }
        }
        
        func eventsForCalendar() -> [Event] {
            return events
        }
        
        func didSelectDate(_ date: Date?, type: CalendarType, frame: CGRect?) {
            selectDate = date ?? Date()
            loadEvents { (events) in
                self.events = events
                self.view.calendar.reloadData()
            }
        }
        
        func didSelectEvent(_ event: Event, type: CalendarType, frame: CGRect?) {
            switch type {
            case .day:
                toggleDetail(event)
                break
            default:
                break
            }
        }
        func didAddNewEvent(_ event: Event, _ date: Date?) {
            var newEvent = event
            
            guard let start = date, let end = Calendar.current.date(byAdding: .minute, value: 30, to: start) else { return }
            
            let startTime = timeFormatter(date: start)
            let endTime = timeFormatter(date: end)
            newEvent.start = start
            newEvent.end = end
            newEvent.ID = "\(events.count + 1)"
            newEvent.text = "\(startTime) - \(endTime)\n new event"
            print("NEW EVENT", newEvent)
            events.append(newEvent)
            self.view.calendar.reloadData()
        }
        func loadEvents(completion: ([Event]) -> Void) {
            let decoder = JSONDecoder()
            
            guard let path = Bundle.main.path(forResource: "events", ofType: "json"),
                  let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
                  let result = try? decoder.decode(ItemData.self, from: data) else { return }
            
            let events = result.data.compactMap({ (item) -> Event in
                let startDate = self.formatter(date: item.start)
                let endDate = self.formatter(date: item.end)
                let startTime = self.timeFormatter(date: startDate)
                let endTime = self.timeFormatter(date: endDate)
                
                var event = Event()
                event.ID = item.id
                event.start = startDate
                event.end = endDate
                event.color = EventColor(item.color)
                event.isAllDay = item.allDay
                event.isContainsFile = !item.files.isEmpty
                event.textForMonth = item.title
                
                if item.allDay {
                    event.text = "\(item.title)"
                } else {
                    event.text = "\(startTime) - \(endTime)\n\(item.title)"
                }
                
                if item.id == "14" {
                    event.recurringType = .everyWeek
                }
                if item.id == "40" {
                    event.recurringType = .everyDay
                }
                return event
            })
            completion(events)
        }
        
        func timeFormatter(date: Date) -> String {
            let formatter = DateFormatter()
            return formatter.string(from: date)
        }
        
        func formatter(date: String) -> Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return formatter.date(from: date) ?? Date()
        }
        
    }
    
}

