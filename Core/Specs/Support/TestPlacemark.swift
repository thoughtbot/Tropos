import CoreLocation

var testPlacemark: CLPlacemark {
    let path = Bundle(for: WeatherUpdateSpec.self).path(forResource: "New York", ofType: "placemark")!
    return NSKeyedUnarchiver.unarchiveObject(withFile: path) as! CLPlacemark
}
