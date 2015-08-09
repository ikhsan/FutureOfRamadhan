
import UIKit

class SummaryCell: UICollectionViewCell {
    
    let dateLabel = UILabel()
    let durationLabel = UILabel()
    let startLabel = UILabel()
    let iftharLabel = UILabel()
    var durationRange = (0.0, 0.0)
    
    var dateFormatter: NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }
    
    var hourFormatter: NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    var summary: RamadhanSummary? {
        didSet {
            
            guard let summary = summary,
            let start = summary.prayerTime?.fajrTime,
            let ifthar = summary.prayerTime?.maghribTime else {
                return
            }
            
            dateLabel.text = "\(dateFormatter.stringFromDate(summary.firstDay)) \n\(dateFormatter.stringFromDate(summary.lastDay))"
            durationLabel.text = String(format: "%.2f hours", summary.duration)
            startLabel.text = hourFormatter.stringFromDate(start)
            iftharLabel.text = hourFormatter.stringFromDate(ifthar)
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLabels()
        backgroundColor = UIColor(white: 1.0, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabels() {
        dateLabel.font = UIFont.systemFontOfSize(16)
        dateLabel.numberOfLines = 2
        dateLabel.textAlignment = NSTextAlignment.Right
        contentView.addSubview(dateLabel)
        
        durationLabel.font = UIFont.boldSystemFontOfSize(14)
        durationLabel.textAlignment = NSTextAlignment.Center
        contentView.addSubview(durationLabel)
        
        startLabel.font = UIFont.systemFontOfSize(14)
        startLabel.textAlignment = NSTextAlignment.Center
        contentView.addSubview(startLabel)
        
        iftharLabel.font = UIFont.systemFontOfSize(14)
        iftharLabel.textAlignment = NSTextAlignment.Center
        contentView.addSubview(iftharLabel)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        dateLabel.frame = CGRect(x: 0, y: 0, width: 100.0, height: 40.0)
        
        // draw one day as a bar
        let context = UIGraphicsGetCurrentContext()
        let dayFrame = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(5.0, 120.0, 5.0, 10.0))
        
        CGContextSetFillColorWithColor(context, UIColor(white: 0.1, alpha: 0.1).CGColor)
        CGContextFillRect(context, dayFrame)
        
        // ifthar bar
        guard let summary = summary,
            let fajr = summary.prayerTime?.fajrTime,
            let ifthar = summary.prayerTime?.maghribTime else {
            return
        }
        
        let dayDuration: Double = 60 * 60 * 24
        let fajrDuration = fajr.timeIntervalSinceDate(summary.firstDay) / dayDuration
        let iftharDuration = ifthar.timeIntervalSinceDate(summary.firstDay) / dayDuration
        
        let x = Double(dayFrame.minX) + (fajrDuration * Double(dayFrame.width))
        let width = (iftharDuration * Double(dayFrame.width)) - (fajrDuration * Double(dayFrame.width))
        let iftharFrame = CGRect(x: x, y: Double(dayFrame.minY), width: width, height: Double(dayFrame.height))
        
        let color = UIColor.colorForDuration(summary.duration, range: durationRange)
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, iftharFrame)
        
        // tickers
        
        let interval = 12.0
        let tickLength = Double(dayFrame.width) / interval
        for hour in 0...Int(interval) {
            let x = Double(dayFrame.minX) + (tickLength * Double(hour)) - 1.0
            let y = Double(contentView.frame.maxY) - 3.0
            let tickRect = CGRect(x: x, y: y, width: 2.0, height: 3.0)
            CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
            CGContextFillRect(context, tickRect)
        }
        
        // layouting duration
        durationLabel.sizeToFit()
        durationLabel.center = CGPoint(x: iftharFrame.midX, y: iftharFrame.midY)
        
        startLabel.sizeToFit()
        startLabel.center = CGPoint(x: x + Double(startLabel.frame.width * 0.6), y: Double(dayFrame.midY))
        
        iftharLabel.sizeToFit()
        iftharLabel.center = CGPoint(x: x + width - Double(iftharLabel.frame.width * 0.6), y: Double(dayFrame.midY))
    }
    
}

extension UIColor {
    class func colorForDuration(duration: Double, range: (min: Double, max: Double)) -> UIColor {
        let minColor: (Double, Double, Double) = (46, 204, 113)
        let maxColor: (Double, Double, Double) = (243, 156, 18)

        let r = minColor.0 + ((maxColor.0 - minColor.0) * ((duration - range.min) / (range.max - range.min)))
        let g = minColor.1 + ((maxColor.1 - minColor.1) * ((duration - range.min) / (range.max - range.min)))
        let b = minColor.2 + ((maxColor.2 - minColor.2) * ((duration - range.min) / (range.max - range.min)))

        return UIColor(
            colorLiteralRed: Float(r / 255.0),
            green: Float(g / 255.0),
            blue: Float(b / 255.0),
            alpha: 1.0
        )
    }
}
