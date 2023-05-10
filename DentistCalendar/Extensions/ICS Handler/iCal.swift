import Foundation

public enum iCal {
    public static func load(string: String) -> [ICSCalendar] {
        let icsContent = string.components(separatedBy: "\n")
        return parse(icsContent)
    }
    public static func load(url: URL, encoding: String.Encoding = .utf8) throws -> [ICSCalendar] {
        let data = try Data(contentsOf: url)
        guard let string = String(data: data, encoding: encoding) else { throw iCalError.encoding }
        return load(string: string)
    }

    private static func parse(_ icsContent: [String]) -> [ICSCalendar] {
        let parser = Parser(icsContent)
        do {
            return try parser.read()
        } catch let error {
            print(error)
            return []
        }
    }

    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }()
}
