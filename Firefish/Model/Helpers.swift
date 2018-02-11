//
//  Helpers.swift
//  Firefish
//
//  Created by Brigitte on 2/10/18.
//  Copyright © 2018 Nativapps. All rights reserved.
//

import Foundation
import UIKit

extension UIResponder {
    
    private struct CurrentFirstResponder {
        weak static var currentFirstResponder: UIResponder?
    }
    private class var currentFirstResponder: UIResponder? {
        get { return CurrentFirstResponder.currentFirstResponder }
        set(newValue) { CurrentFirstResponder.currentFirstResponder = newValue }
    }
    
    class func getCurrentFirstResponder() -> UIResponder? {
        currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder), to: nil, from: nil, for: nil)
        return currentFirstResponder
    }
    
    @objc func findFirstResponder() {
        UIResponder.currentFirstResponder = self
    }
}

public func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
    URLSession.shared.dataTask(with: url) {
        (data, response, error) in
        completion(data, response, error)
        }.resume()
}
public func dateToString(format: String, fromDate: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.timeZone = NSTimeZone(abbreviation: "EST") as TimeZone!
    var weekday = String()
    var mes = String()
    if let date = dateFormatter.date(from: fromDate) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year, .weekday], from: date)
        
        switch components.weekday! {
        case 2:
            weekday = "Monday"
        case 3:
            weekday = "Tuesday"
        case 4:
            weekday = "Wednesday"
        case 5:
            weekday = "Thursday"
        case 6:
            weekday = "Friday"
        case 7:
            weekday = "Saturday"
        case 1:
            weekday = "Sunday"
        default:
            break;
        }
        
        switch components.month! {
        case 1:
            mes = "January"
        case 2:
            mes = "February"
        case 3:
            mes = "March"
        case 4:
            mes = "April"
        case 5:
            mes = "May"
        case 6:
            mes = "June"
        case 7:
            mes = "July"
        case 8:
            mes = "August"
        case 9:
            mes = "September"
        case 10:
            mes = "October"
        case 11:
            mes = "November"
        case 12:
            mes = "December"
        default:
            break;
        }
        return "\(weekday), \(mes)\(components.day!) "
    }else{
        return ""
    }
}

public func dateComments(format: String, fromDate: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.timeZone = NSTimeZone(abbreviation: "EST") as TimeZone!
    var weekday = String()
    var mes = String()
    if let date = dateFormatter.date(from: fromDate) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: date)
        
        switch components.month! {
        case 1:
            mes = "Jan."
        case 2:
            mes = "Feb."
        case 3:
            mes = "March"
        case 4:
            mes = "April"
        case 5:
            mes = "May"
        case 6:
            mes = "June"
        case 7:
            mes = "July"
        case 8:
            mes = "Aug."
        case 9:
            mes = "Sept."
        case 10:
            mes = "Oct."
        case 11:
            mes = "Nov."
        case 12:
            mes = "Dec."
        default:
            break;
        }
        return "\(mes)\(components.day!)"
    }else{
        return ""
    }
}

