//
//  SingleImageViewController.swift
//  Memoriz
//
//  Created by Oladele Abimbola on 7/12/22.
//

import UIKit
import CoreData

class SingleImageViewController: UIViewController {

    @IBOutlet weak var imageBox: UIImageView!
    @IBOutlet weak var quoteTextView: UITextView!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var userData: UserData!
    var dataController: DataController!
    var fetchedResultsController:NSFetchedResultsController<SingleView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captionTextField.delegate = self
        setUpFetchedResultsController()
        getQuote()
        getCoreDataCaption()
        
        if let imageData = userData.image{
            imageBox.image = UIImage(data: imageData)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpFetchedResultsController()
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
        unsubscribeFromKeyboardNotification()
    }
}

//MARK: FetchedRequestController
extension SingleImageViewController: NSFetchedResultsControllerDelegate{
    
    fileprivate func setUpFetchedResultsController() {
        let fetchRequest:NSFetchRequest<SingleView> = SingleView.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "captionText", ascending: false)
        let predicate = NSPredicate(format: "user == %@", userData)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do{
            try fetchedResultsController.performFetch()
        }catch{
            fatalError("unable to perform fetch: \(error.localizedDescription)")
        }
    }
}

//MARK: TextField Delegate
extension SingleImageViewController: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let myContext = SingleView(context: dataController.viewContext)
        myContext.captionText = textField.text
        myContext.randomQuote = nil
        myContext.image = nil
        myContext.user = userData
        
        do{
            try dataController.viewContext.save()
            debugPrint("successful")
        }catch{
            print(error)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func getKeyboardHeight(_ notification : Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardHeight = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardHeight.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification:Notification){
        if captionTextField.isFirstResponder{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func subscribeToKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotification(){
        NotificationCenter.default.removeObserver(self)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        if view.frame.origin.y != 0{
            view.frame.origin.y = 0
        }
    }
}

extension SingleImageViewController{
    
    func getCoreDataCaption(){
        for caption in fetchedResultsController.fetchedObjects!{
            captionTextField.text = caption.captionText
        }
    }
    
    func getQuote(){
        quoteLoading(true)
        ZenQuoteClient.getRandomQuote { quote, error in
            if let quote = quote {
                self.quoteTextView.text = "\n \(quote.quote) \n\n Author: \(quote.author)"
                self.quoteLoading(false)
            }else{
                self.getQuoteFailure(message: error?.localizedDescription ?? "The internet connection appears to be offline")
                self.quoteLoading(false)
            }
        }
    }
    
    func quoteLoading(_ gettingQuote: Bool){
        if gettingQuote{
            activityIndicator.startAnimating()
        }else{
            activityIndicator.stopAnimating()
        }
    }
    
    func getQuoteFailure(message: String){
        let alertVC = UIAlertController(title: "Cannot fetch quote", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "try again", style: .cancel)
        alertVC.addAction(alertAction)
        present(alertVC, animated: true)
    }
    
    
// MARK: Another Method (first approach)
//    func getQuote(){
//        quoteLoading(true)
//        ZenQuoteClient.getRandomQuote { quote, error in
//            guard let quote = quote else {return}
//            if error != nil{
//                self.getQuoteFailure(message: error?.localizedDescription ?? "The internet connection appears to be offline")
//                self.quoteLoading(true)
//            }else{
//                self.quoteTextView.text = "\n \(quote.quote) \n\n Author: \(quote.author) "
//                self.quoteLoading(false)
//            }
//        }
//    }
    
    
//MARK: Another method
//    func unsubscribeFromKeyboardNotification(){
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
    
}
