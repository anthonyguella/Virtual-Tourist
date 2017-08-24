//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Anthony Guella on 8/19/17.
//  Copyright © 2017 Anthony Guella. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {

    
    //MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.addAnnotations(fetchPins())

    }
    
    //MARK: Methods
    
    /**
     Fetches Stored Pins
    */
    func fetchPins() -> [Pin] {
        let fr:NSFetchRequest<Pin> = Pin.fetchRequest()
        do{
            return try DatabaseController.getContext().fetch(fr) 
        } catch {
            print("Error loading pins")
        }
    }
    
    /**
     Segues to pin image collection view
    */
    func viewPin(pin: Pin) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "imagesViewController") as! ImagesViewController
        vc.pin = pin
        navigationController!.pushViewController(vc, animated: true)
    }
    
    //MARK: IBActions
    @IBAction func addAnnotation(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            let pin = Pin(latitude: coordinates.latitude, longitude: coordinates.longitude, context: DatabaseController.getContext())

            mapView.addAnnotation(pin)
        }
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        
    }
    
    //MARK: Map View Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PinAnnotation")
        pinAnnotation.animatesDrop = true
        return pinAnnotation
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pin = view.annotation as! Pin
        viewPin(pin: pin)
    }
}

