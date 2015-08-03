
import Foundation
import CoreLocation
import BAPrayerTimes

struct RamadhanSummary {
    let method = BAPrayerMethod.MCW
    let madhab = BAPrayerMadhab.Hanafi
    
    let firstDay: NSDate
    let lastDay: NSDate
    let placemark: CLPlacemark
    
    var prayerTime: BAPrayerTimes? { return prayerTimesForDate(firstDay) }
    var duration: Double { return getDuration(firstDay) }
}

// MARK: Private methods

private extension RamadhanSummary {

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

// MARK: Create summaries

extension RamadhanSummary {

    static func summariesForCity(city: String, initialYear: Int, durationInYears: Int, completionHandler: ([RamadhanSummary]) -> Void) {
        CLGeocoder().geocodeAddressString(city) { p, error in
            guard let placemark = p?.first else {
                completionHandler([])
                return
            }

            let summaries = (initialYear..<(initialYear + durationInYears)).flatMap { year -> RamadhanSummary? in
                let dates = NSDate.rmdn_ramadhanDaysForHijriYear(year)
                guard let firstDay = dates.first, let lastDay = dates.last else { return nil }
                return RamadhanSummary(firstDay: firstDay, lastDay: lastDay, placemark: placemark)
            }

            completionHandler(summaries)
        }
    }

}