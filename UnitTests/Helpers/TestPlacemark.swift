import CoreLocation

var testPlacemark: CLPlacemark {
    let path = NSBundle(forClass: WeatherUpdateSpec.self).pathForResource("New York", ofType: "placemark")!
    return NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! CLPlacemark
}
