/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreLocation

enum PriceGuide : Int {
  case Unknown = 0
  case Low = 1
  case Medium = 2
  case High = 3
}

extension PriceGuide : CustomStringConvertible {
  var description : String {
    switch self {
    case .Unknown:
      return "?"
    case .Low:
      return "$"
    case .Medium:
      return "$$"
    case .High:
      return "$$$"
    }
  }
}

enum PancakeRating {
  case Unknown
  case Rating(Int)
}

extension PancakeRating {
  init?(value: Int) {
    if value > 0 && value <= 5 {
      self = .Rating(value)
    } else {
      self = .Unknown
    }
  }
}

extension PancakeRating {
  var ratingImage : UIImage? {
    guard let baseName = ratingImageName else {
      return nil
    }
    return UIImage(named: baseName)
  }
  
  var smallRatingImage : UIImage? {
    guard let baseName = ratingImageName else {
      return nil
    }
    return UIImage(named: "\(baseName)_small")
  }
  
  private var ratingImageName : String? {
    switch self {
    case .Unknown:
      return nil
    case .Rating(let value):
      return "pancake_rate_\(value)"
    }
  }
}



struct PancakeHouse {
  let name: String
  let photo: UIImage?
  let thumbnail: UIImage?
  let priceGuide: PriceGuide
  let location: CLLocationCoordinate2D?
  let details: String
  let rating: PancakeRating
  let city: String
}

extension PancakeHouse {
   init?(dict: [String : AnyObject]) {
    guard let name = dict["name"] as? String,
      let priceGuideRaw = dict["priceGuide"] as? Int,
      let priceGuide = PriceGuide(rawValue: priceGuideRaw),
      let details = dict["details"] as? String,
      let ratingRaw = dict["rating"] as? Int,
      let rating = PancakeRating(value: ratingRaw),
      let city = dict["city"] as? String else {
        return nil
    }

    self.name = name
    self.priceGuide = priceGuide
    self.details = details
    self.rating = rating
    self.city = city
    
    if let imageName = dict["imageName"] as? String where !imageName.isEmpty {
      photo = UIImage(named: imageName)
    } else {
      photo = nil
    }
    
    if let thumbnailName = dict["thumbnailName"] as? String where !thumbnailName.isEmpty {
      thumbnail = UIImage(named: thumbnailName)
    } else {
      thumbnail = nil
    }
    
    if let latitude = dict["latitude"] as? Double,
      let longitude = dict["longitude"] as? Double {
        location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    } else {
      location = nil
    }
  }
}

extension PancakeHouse {
  static func loadDefaultPancakeHouses() -> [PancakeHouse]? {
    return self.loadPancakeHousesFromPlistNamed("pancake_houses")
  }
  
  static func loadPancakeHousesFromPlistNamed(plistName: String) -> [PancakeHouse]? {
    guard let path = NSBundle.mainBundle().pathForResource(plistName, ofType: "plist"),
      let array = NSArray(contentsOfFile: path) as? [[String : AnyObject]] else {
        return nil
    }
    
    return array.map { PancakeHouse(dict: $0) }
                .filter { $0 != nil }
                .map { $0! }
  }
}

extension PancakeHouse : CustomStringConvertible {
  var description : String {
    return "\(name) :: \(details)"
  }
}



