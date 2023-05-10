import Foundation

public struct ICSEvent {
    public var subComponents: [CalendarComponent] = []
    public var otherAttrs = [String:String]()

    public var uid: String!
    public var dtstamp: Date!

    public var location: String?
    public var summary: String?
    public var descr: String?
    public var dtstart: Date?
    public var dtend: Date?

    public init(uid: String? = NSUUID().uuidString, dtstamp: Date? = Date()) {
        self.uid = uid
        self.dtstamp = dtstamp
    }
}

extension ICSEvent: CalendarComponent {
    public func toCal() -> String {
        var str: String = "BEGIN:VEVENT\n"

        if let uid = uid {
            str += "UID:\(uid)\n"
        }
        if let dtstamp = dtstamp {
            str += "DTSTAMP:\(dtstamp.toString())\n"
        }
        if let summary = summary {
            str += "SUMMARY:\(summary)\n"
        }
        if let descr = descr {
            str += "DESCRIPTION:\(descr)\n"
        }
        if let dtstart = dtstart {
            str += "DTSTART:\(dtstart.toString())\n"
        }
        if let dtend = dtend {
            str += "DTEND:\(dtend.toString())\n"
        }

        for (key, val) in otherAttrs {
            str += "\(key):\(val)\n"
        }

        for component in subComponents {
            str += "\(component.toCal())\n"
        }

        str += "END:VEVENT"
        return str
    }
}

extension ICSEvent: IcsElement {
    public mutating func addAttribute(attr: String, _ value: String) {
        switch attr {
        case "UID":
            uid = value
        case "DTSTAMP":
            dtstamp = value.toDate()
        case "DTSTART":
            dtstart = value.toDate()
        case "DTEND":
            dtend = value.toDate()
        case "SUMMARY":
            summary = value
        case "DESCRIPTION":
            descr = value
        default:
            otherAttrs[attr] = value
        }
    }
}

extension ICSEvent: Equatable { }

public func ==(lhs: ICSEvent, rhs: ICSEvent) -> Bool {
    return lhs.uid == rhs.uid
}

extension ICSEvent: CustomStringConvertible {
    public var description: String {
        return "\(dtstamp.toString()): \(summary ?? "")"
    }
}


