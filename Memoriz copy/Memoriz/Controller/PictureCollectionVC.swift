//
//  PictureCollectionViewController.swift
//  Memoriz
//
//  Created by Oladele Abimbola on 7/9/22.
//

import UIKit
import MapKit
import CoreData

class PictureCollectionViewController: UIViewController {

//MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
//MARK: Variables
    var dataController:DataController!
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var pinPosition: PinPosition!
    var userData: UserData!
    var fetchedResultsController:NSFetchedResultsController<UserData>!
//    var imageData:[Data?] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFetchedResultsController()
        setUpMapview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpFetchedResultsController()
        self.collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
    }
    
    @IBAction func addImagesToCollection(_ sender: Any) {
        pickImage(sourceType: .photoLibrary)
    }
}

//MARK: ImagePickerController
extension PictureCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func pickImage(sourceType: UIImagePickerController.SourceType){
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = sourceType
        present(controller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{

            let userDataContext = UserData(context: dataController.viewContext)
            let data = image.pngData()
            guard let data = data else{return}
            userDataContext.image = data
            userDataContext.pin = pinPosition
            
            do{
                try  dataController.viewContext.save()
                debugPrint("successful")
            }catch{
                print(error.localizedDescription)
            }
            do{
                try fetchedResultsController.performFetch()
            }catch{
                print(error.localizedDescription)
            }
           

        }
        
        self.collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

//MARK: FetchedResultsController
extension PictureCollectionViewController:NSFetchedResultsControllerDelegate{
    
    fileprivate func setUpFetchedResultsController() {
        let fetchRequest:NSFetchRequest<UserData> = UserData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "image", ascending: false)
        let predicate = NSPredicate(format: "pin == %@", pinPosition)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do{
            try fetchedResultsController.performFetch()
        }catch{
            fatalError("Unable to perform fetch: \(error.localizedDescription)")
        }
    }
}

//MARK: Mapview & Delegate
extension PictureCollectionViewController: MKMapViewDelegate{
    
    func setUpMapview(){
        mapView.delegate = self
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        annotation.coordinate = coordinate
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.animatesDrop = true
        }else{
            pinView?.annotation = annotation
        }
        return pinView
    }
}

//MARK: CollectionViewDelegate
extension PictureCollectionViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        setUpFetchedResultsController()
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseId = "PictureCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! PictureCollectionViewCell
        let anImage = fetchedResultsController.object(at: indexPath)
        if let someData = anImage.image{
            cell.collectionImageView.image = UIImage(data: someData)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 182, height: 196)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let animage = fetchedResultsController.object(at: indexPath)
//        guard let someData = animage.image else{return}
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "SingleImageViewController") as! SingleImageViewController
//        controller.imageData = someData
        controller.userData = fetchedResultsController.object(at: indexPath)
        controller.dataController = dataController
        if let navigationController = navigationController{
            navigationController.pushViewController(controller, animated: true)
        }
    }
}
