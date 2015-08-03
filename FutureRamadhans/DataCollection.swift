
import Foundation
import CoreLocation
import BAPrayerTimes

extension NSDate {
    
    static func ramadhanDaysForHijriYear(year: Int) -> [NSDate] {
        
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

struct RamadhanSummary {
    
    let method = BAPrayerMethod.MCW
    let madhab = BAPrayerMadhab.Hanafi
    
    let firstDay: NSDate
    let lastDay: NSDate
    let placemark: CLPlacemark
    
    var prayerTime: BAPrayerTimes? { return prayerTimesForDate(firstDay) }
    var duration: Double { return getDuration(firstDay) }
    
    private func prayerTimesForDate(date: NSDate) -> BAPrayerTimes? {
        
        guard let latitude = placemark.location?.coordinate.latitude,
            let longitude = placemark.location?.coordinate.longitude,
            let timezone = placemark.timeZone else {
                return nil
        }
        
        return BAPrayerTimes(
            date: firstDay,
            latitude: latitude,
            longitude: longitude,
            timeZone: timezone,
            method: method,
            madhab: madhab
        )
    }
    
    private func getDuration(date: NSDate) -> Double {
        guard let prayerTime = prayerTimesForDate(date) else {
            return 0
        }
        
        let duration = prayerTime.maghribTime.timeIntervalSinceReferenceDate - prayerTime.fajrTime.timeIntervalSinceReferenceDate
        return (duration / 3600.0)
    }
    
}

func createRamadhanSummariesForCity(city: String, initialYear: Int, durationInYears: Int, completionHandler: ([RamadhanSummary]) -> Void) {
    
    CLGeocoder().geocodeAddressString(city) { p, error in
        guard let placemark = p?.first else {
            completionHandler([])
            return
        }
        
        let summaries = (initialYear..<(initialYear + durationInYears)).flatMap { year -> RamadhanSummary? in
            let dates = NSDate.ramadhanDaysForHijriYear(year)
            guard let firstDay = dates.first, let lastDay = dates.last else { return nil }
            return RamadhanSummary(firstDay: firstDay, lastDay: lastDay, placemark: placemark)
        }
        
        completionHandler(summaries)
    }

}