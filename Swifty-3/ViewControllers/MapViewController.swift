//
//  MapViewController.swift
//  Swifty-3
//
//  Created by Yuki Miyazawa on 2020-07-11.
//  Copyright © 2020 Yuki Miyazawa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData
import FirebaseAuth

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    //Connect each element to code
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var searchBox: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var historyTextField: UITextField!
    
    //this array is for storing users search history
    var history:[String] = []
    
    //Get CLLocationManager to get users location
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
           // having data for Annotations - using Dictionary
            let locations = [
                ["title": "New York, NY",  "description":"" , "latitude": 40.713054, "longitude": -74.007228],
                ["title": "Chicago, IL",  "description":"",   "latitude": 41.883229, "longitude": -87.632398],
                ["title": "Georgian College, ON", "description":"Our School" ,   "latitude": 44.4074, "longitude": -79.6567],
            ]
            
            // then iterating each annotaton
            for location in locations {
                //declare annotation object
                let annotation = MKPointAnnotation()
                //storing data
                annotation.title = location["title"] as? String
                annotation.subtitle = location["description"] as? String
                annotation.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! Double, longitude: location["longitude"] as! Double)
                //then display annotation at once
                myMapView.addAnnotation(annotation)
            }
             
            //Display the user location (Default is: Apple HQ)
            myMapView.showsUserLocation = true
            
            //Set up MapKit
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //Asking user the app will use your location to navigate you
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            //update user's location as they move
            locationManager.startUpdatingLocation()
        
            //VERY IMPORTANT. make function inside mapView available to use
            myMapView.delegate = self
        
    }

    
    @IBAction func searchButtonTapped(_ sender: Any) {
        //getAddress function get destination data
        getAddress()
        //everytime user serarch place, the input will be stored into history array
        self.history.append(searchBox.text!)

    }
    
    @IBAction func historyButtonTapped(_ sender: Any) {
        
    }
    
    //this happens after segue navigates user from MapView -> HistoryView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(self.history.isEmpty){
                    //Is the history array was empty, Simply show the error alert
                    let alert = UIAlertController(title: "Oops", message: "No history found.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
            return
        }
        
        //setting up the route
        let vc = segue.destination as! HistoryController
        //let value = self.history
        
        //iterating anydata inside history array, and pass the data into vc.finalHistory which is declared in
        // HistoryController.
        for data in 0...self.history.count-1{
            vc.finalHistory.append(self.history[data])
        }
        //just to pprint out what is inside finalHistory array
        print("final: \(vc.finalHistory)")
          
    }
    
     //getAddres function converts Text that user typed in to Coordinate
        func getAddress(){
            //Every before showing the navigation result, remove the previous result
            myMapView.removeOverlays(myMapView.overlays)
            //Get Geocoder to get cordinate from a place
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(searchBox.text!) { (result, error) in
                guard let result = result, let location = result.first?.location else{
                    print("No Location Found")
                    //if no location found, show the error alert
                    let alert = UIAlertController(title: "Error", message: "Location could not found.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                        //if no place found, navigatio will not run, just return nil
                    return
                }
                self.mapNavigation(destinationCord: location.coordinate)
            }
        }
        
        //
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         //   print("User Location \(locations)")
        }
        
        //mapNavigation function get the current location and destination, then highlight the route uoto the destination
        func mapNavigation(destinationCord:CLLocationCoordinate2D){
            //Get cordinate, startPoint(user location) and endPoint(Destination)
            let cordinate = (locationManager.location?.coordinate)!
            let startPoint = MKPlacemark(coordinate: cordinate)
            let endPoint = MKPlacemark(coordinate: destinationCord)
            //Store any data regarding to StartPoint and EndPoint
            let startItem = MKMapItem(placemark: startPoint)
            let endItem = MKMapItem(placemark: endPoint)
            //Request Route and Navigation to Destination
            let destinationRequest = MKDirections.Request()
            destinationRequest.source = startItem
            destinationRequest.destination = endItem
            //set transportation mode (here is set as car)
            destinationRequest.transportType = .automobile
            //can get multiple routes to get to the destionation
            destinationRequest.requestsAlternateRoutes = true
            
            //calculate the route based on the destination request
            let direction = MKDirections(request: destinationRequest)
            direction.calculate { (result, error) in
                guard let result = result else{
                    if let error = error {
                        print(error)
                        //if any error happened, show the error alert
                        let alert = UIAlertController(title: "Error", message: "Could not find the way to get there (Maybe the destination is somewwhere you can not reach by car.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)

                    }
                    return
                }
                //display the first result the MKDirection get
                let route = result.routes[0]
                //now add overlay on the route and make it visible
                self.myMapView.addOverlay(route.polyline)
                self.myMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
                    
        }
        
        // final set up to use navigation overlay
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
            render.strokeColor = .blue
            return render
        }
            
}
