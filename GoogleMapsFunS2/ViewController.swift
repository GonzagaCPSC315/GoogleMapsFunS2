//
//  ViewController.swift
//  GoogleMapsFunS2
//
//  Created by Gina Sprint on 11/20/20.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController, GMSMapViewDelegate {

    // challenge task #1
    var placesClient: GMSPlacesClient!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // challenge task #1
        placesClient = GMSPlacesClient.shared()
        
        // setup a map to be zoomed into the GU campus
        let guLatitude = 47.6670357
        let guLongitude = -117.403623
        // we need a "camera" to zoom into these coordinates
        let guCamera = GMSCameraPosition.camera(withLatitude: guLatitude, longitude: guLongitude, zoom: 15.0)
        // zoom level 1.0 "world view" 20.0 "building view"
        // now we need a map view!!
        let mapView = GMSMapView.map(withFrame: view.bounds, camera: guCamera)
        
        // change the map type
        mapView.mapType = .hybrid
        
        // add a marker for GU
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: guLatitude, longitude: guLongitude)
        // if the marker has a title or snippet, when the user taps on the marker a small info window will show up
        marker.title = "Gonzaga University"
        marker.snippet = "Go Zags!"
        marker.icon = GMSMarker.markerImage(with: .green)
        marker.map = mapView
        
        // enable the my location feature (the blue dot)
        mapView.isMyLocationEnabled = true // shows the blue dot
        mapView.settings.myLocationButton = true // shows the zoom to my location button
        // the above require user authorization
        // add the appropriate key value pair to Info.plist
        
        // challenge tasks
        // 1. set up map view delegation so your view controller knows when the user taps their my location blue dot
        mapView.delegate = self
        // 2. use the Google Places SDK for iOS, when the user taps their blue dot, show an alert with the current place name and address
        
        view = mapView
    }

    // challenge task #1
    func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {
        print("tapped")
        // challenge task #2
        getPlace()
    }
    
    // challenge task #2
    func getPlace() {
        let placeFields: GMSPlaceField = [.name, .formattedAddress]
            placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields) { (placeLikelihoods, error) in


              guard error == nil else {
                print("Current place error: \(error?.localizedDescription ?? "")")
                return
              }

                guard let place = placeLikelihoods?.first?.place, let name = place.name, let address = place.formattedAddress else {
                print("error")
                return
              }

            let alert = UIAlertController(title: "My Location Tapped", message: "You are at \(name) \(address)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}

