//
//  OnboardingCollectionViewCell.swift
//  Memoriz
//
//  Created by Oladele Abimbola on 7/6/22.
//

import Foundation
import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var slideImageView: UIImageView!
    
    @IBOutlet weak var slideTitle: UILabel!
    
    @IBOutlet weak var slideDescription: UILabel!
    
    func setUp(_ slide:OnboardingSlide){
        slideImageView.image = slide.image
        slideTitle.text = slide.title
        slideDescription.text = slide.description
    }
}
