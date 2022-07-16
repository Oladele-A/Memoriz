//
//  MapVC.swift
//  Memoriz
//
//  Created by Oladele Abimbola on 7/7/22.
//

import Foundation
import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var pinPosition: PinPosition!
    var fetchedResultsController: NSFetchedResultsController<PinPosition>!
    
    var dataController: DataController!{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.dataController
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFetchedResultsController()
        mapView.delegate = self
        addGestureRecognizer()
        getCoreDataLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpFetchedResultsController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pictureCollectionVC"{
            let controller = segue.destination as? PictureCollectionViewController
            controller?.latitude = latitude
            controller?.longitude = longitude
            controller?.pinPosition = pinPosition
            controller?.dataController = dataController
        }
    }
}

//MARK: Setup FetchedResultsController
extension MapViewController: NSFetchedResultsControllerDelegate{
    
    fileprivate func setUpFetchedResultsController() {
        let fetchRequest:NSFetchRequest<PinPosition> = PinPosition.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "latitude", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do{
            try fetchedResultsController.performFetch()
        }catch{
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
}

//MARK: Gesture Recognizer
extension MapViewController: UIGestureRecognizerDelegate{
    
   @objc func mapViewTapped(gestureRecognizer:UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began{
            let pinContext = PinPosition(context: dataController.viewContext)
            let touchpoint = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(touchpoint, toCoordinateFrom: mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            pinContext.latitude = annotation.coordinate.latitude
            pinContext.longitude = annotation.coordinate.longitude
            mapView.addAnnotation(annotation)
            
            do{
                try dataController.viewContext.save()
            }catch{
                print(error.localizedDescription)
            }
            do{
                try fetchedResultsController.performFetch()
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func addGestureRecognizer(){
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(mapViewTapped(gestureRecognizer:)))
        longPressGestureRecognizer.minimumPressDuration = 1
        longPressGestureRecognizer.delegate = self
        mapView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    func getCoreDataLocation(){
        for location in fetchedResultsController.fetchedObjects!{
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = location.latitude
            annotation.coordinate.longitude = location.longitude
            mapView.addAnnotation(annotation)
        }
    }
}

//MARK: Mapview Delegate
extension MapViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "myPin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.animatesDrop = true
            pinView?.canShowCallout = true
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }else{
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: false)
        
        var selectedAnnotation: MKPointAnnotation!
        selectedAnnotation = view.annotation as? MKPointAnnotation
        
        latitude = selectedAnnotation.coordinate.latitude
        longitude = selectedAnnotation.coordinate.longitude
        
        let pins = fetchedResultsController.fetchedObjects! as [PinPosition]
        pinPosition = pins.filter({ $0.latitude == view.annotation?.coordinate.latitude && $0.longitude == view.annotation?.coordinate.longitude}).first
        mapView.deselectAnnotation(view.annotation, animated: true)
        performSegue(withIdentifier: "pictureCollectionVC", sender: self)
    }
}
