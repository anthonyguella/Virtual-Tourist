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
    @IBOutlet weak var deleteAlert: UILabel!
    
    
    //MARK: Variables
    var editMode: Bool = false
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.addAnnotations(fetchPins())
        deleteAlert.isHidden = true
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
            return []
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
            DatabaseController.saveContext()
            mapView.addAnnotation(pin)
        }
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        let editButton = sender as! UIBarButtonItem
        editMode = !editMode
        if editMode == false {
            editButton.title = "Edit"
            deleteAlert.isHidden = true
        } else {
            editButton.title = "Done"
            deleteAlert.isHidden = false
        }
    }
    
    //MARK: Map View Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PinAnnotation")
        pinAnnotation.animatesDrop = true
        return pinAnnotation
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pin = view.annotation as! Pin
        if !editMode {
            viewPin(pin: pin)
            mapView.deselectAnnotation(view.annotation, animated: false)
        } else {
            DatabaseController.getContext().delete(pin)
            mapView.removeAnnotation(view.annotation!)
        }
    }
}

