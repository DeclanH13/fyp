//
//  StoreLocatorViewController.swift
//  product-recommender-system
//
//  Created by Declan Holland on 27/03/2020.
//  Copyright © 2020 Declan Holland. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class StoreLocatorViewController: UIViewController, UISearchBarDelegate,CLLocationManagerDelegate, MKMapViewDelegate{
    var storeName: String!
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet var searchBar: UISearchBar!
    var matchingItems: [MKMapItem] = [MKMapItem]()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.requestAlwaysAuthorization()
       // locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        searchBar.delegate = self
        searchBar.text = storeName
        performSearch()
       // self.mapView.reloadInputViews()

        // Do any additional setup after loading the view.
    }
    


//   func getAddress() {
//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString(storeName) { (placemarks, error) in
//            guard let placemarks = placemarks, let location = placemarks.first?.location
//                else {
//                    print("No Location Found")
//                    return
//            }
//            print(location)
//            self.mapThis(destinationCord: location.coordinate)
//
//        }
//    }
    
     func performSearch() {
         
        matchingItems.removeAll()
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBar.text! + " Store"
         request.region = mapView.region
    
         let search = MKLocalSearch(request: request)
         
         search.start(completionHandler: {(response, error) in
             
             if let results = response {
             
                 if let err = error {
                     print("Error occurred in search: \(err.localizedDescription)")
                 } else if results.mapItems.count == 0 {
                     print("No matches found")
                 } else {
                     print("Matches found")
                     
                     for item in results.mapItems {
                         print("Name = \(item.name ?? "No match")")
                         print("Phone = \(item.phoneNumber ?? "No Match")")
                         
                         self.matchingItems.append(item as MKMapItem)
                         print("Matching items = \(self.matchingItems.count)")
                         
                         let annotation = MKPointAnnotation()
                         annotation.coordinate = item.placemark.coordinate
                         annotation.title = item.name
                     
                        self.mapView.addAnnotation(annotation)
                            
                        
                       // self.tableView.reloadData()
                         
                        
                     }
                    //self.mapView.reloadInputViews()
                 }
             }
           
         })
     }
        
//    func mapThis(destinationCord : CLLocationCoordinate2D) {
//
//        let souceCordinate = (locationManager.location?.coordinate)!
//
//        let soucePlaceMark = MKPlacemark(coordinate: souceCordinate)
//        let destPlaceMark = MKPlacemark(coordinate: destinationCord)
//
//        let sourceItem = MKMapItem(placemark: soucePlaceMark)
//        let destItem = MKMapItem(placemark: destPlaceMark)
//
//        let destinationRequest = MKDirections.Request()
//        destinationRequest.source = sourceItem
//        destinationRequest.destination = destItem
//        destinationRequest.transportType = .automobile
//        destinationRequest.requestsAlternateRoutes = true
//
//        let directions = MKDirections(request: destinationRequest)
//        directions.calculate { (response, error) in
//            guard let response = response else {
//                if let error = error {
//                    print("Something is wrong :(")
//                }
//                return
//            }
//
//          let route = response.routes[0]
//          self.mapView.addOverlay(route.polyline)
//          self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
//
//        }
        
        
 //   }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        return render
    }
   
    /*
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
