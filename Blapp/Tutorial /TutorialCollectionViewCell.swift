//
//  CollectionViewCell.swift
//  Blapp
//
//  Created by Peter Byström on 2024-04-30.
//

import UIKit

class TutorialCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var slideTitleLb1: UILabel!
    @IBOutlet weak var slideDescriptionLb1: UILabel!
    
    func setup(_ slide: TutorialSlides){
        slideTitleLb1.text = slide.title
        slideDescriptionLb1.text = slide.description
    }
}
