import Foundation

/// TODO add documentation
internal class Parser {
    let icsContent: [String]

    init(_ ics: [String]) {
        icsContent = ics
    }

    func read() throws -> [ICSCalendar] {
        var completeCal = [ICSCalendar?]()

        // Such state, much wow
        var inCalendar = false
        var currentCalendar: ICSCalendar?
        var inEvent = false
        var currentEvent: ICSEvent?
        var inAlarm = false
        var currentAlarm: Alarm?

        for (_ , line) in icsContent.enumerated() {
            switch line {
            case "BEGIN:VCALENDAR":
                inCalendar = true
                currentCalendar = ICSCalendar(withComponents: nil)
                continue
            case "END:VCALENDAR":
                inCalendar = false
                completeCal.append(currentCalendar)
                currentCalendar = nil
                continue
            case "BEGIN:VEVENT":
                inEvent = true
                currentEvent = ICSEvent()
                continue
            case "END:VEVENT":
                inEvent = false
                currentCalendar?.append(component: currentEvent)
                currentEvent = nil
                continue
            case "BEGIN:VALARM":
                inAlarm = true
                currentAlarm = Alarm()
                continue
            case "END:VALARM":
                inAlarm = false
                currentEvent?.append(component: currentAlarm)
                currentAlarm = nil
                continue
            default:
                break
            }

            guard let (key, value) = line.toKeyValuePair(splittingOn: ":") else {
                // print("(key, value) is nil") // DEBUG
                continue
            }

            if inCalendar && !inEvent {
                currentCalendar?.addAttribute(attr: key, value)
            }

            if inEvent && !inAlarm {
                currentEvent?.addAttribute(attr: key, value)
            }

            if inAlarm {
                currentAlarm?.addAttribute(attr: key, value)
            }
        }

        return completeCal.flatMap{ $0 }
    }
}
