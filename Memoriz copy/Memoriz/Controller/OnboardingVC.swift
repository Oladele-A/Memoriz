//
//  ViewController.swift
//  Memoriz
//
//  Created by Oladele Abimbola on 7/6/22.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides:[OnboardingSlide] = []
    
    // use the didSet property to know when the value has changed
    var currentPage = 0{
        didSet{
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextButton.setTitle("Get Started", for: .normal)
            }else{
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        slides = [
            OnboardingSlide(title: " Some moments only come once.", description: "Preserve them forever!", image: UIImage(named: "slide1")!),
            OnboardingSlide(title: "We didn’t realize we were making memories", description: "We just knew we were having fun.", image: UIImage(named: "slide2")!),
            OnboardingSlide(title: "A photograph keeps a moment from running away.", description: "Because every picture has a story to tell.", image: UIImage(named: "slide4")!)
        ]
    }

    @IBAction func nextButtonAction(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "HomeNC") as! UINavigationController
//            controller.modalPresentationStyle = .fullScreen
//            controller.modalTransitionStyle = .partialCurl
            UserDefaults.standard.set(true, forKey: "hasOnboarded")
            present(controller, animated: true, completion: nil)

        }else{
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseID = "OnboardingCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! OnboardingCollectionViewCell
        cell.setUp(slides[indexPath.row])
        return cell
    }
    
    // set the size of the collection view instead of using flowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    //Know when the scroll has finished and then update the pageControl
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x/width)
    }
}
