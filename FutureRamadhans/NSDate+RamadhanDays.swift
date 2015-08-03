
import Foundation

extension NSDate {

    static func rmdn_ramadhanDaysForHijriYear(year: Int) -> [NSDate] {

        guard let hijriCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierIslamic) else {
            return []
        }

        let components = NSDateComponents()
        components.month = 9 // ramadhan
        components.year = year

        return (1..<30).flatMap { day in
            components.day = day
            return hijriCalendar.dateFromComponents(components)
        }

    }

}