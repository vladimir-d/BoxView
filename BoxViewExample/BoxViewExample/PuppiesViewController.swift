//
//  PuppiesViewController.swift
//  BoxViewExample
//
//  Created by Vlad on 6/8/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

class PuppiesViewController: BaseViewController {
            
    struct AlbumItem {
        
        var title = ""
        
        var imageNames = [String]()
    }
    
    let items = [
        AlbumItem(title: "Maremma", imageNames: ["p1_02", "p1_03", "p1_04", "p1_07"]),
        AlbumItem(title: "Husky", imageNames: ["hp04", "hp05", "hp11", "hp12"]),
        AlbumItem(title: "Malinois", imageNames: ["hp04", "hp05", "hp11", "hp12"]),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Puppies"
        for item in items {
            let itemView = AlbumItemView()
            itemView.titleLabel.text = item.title
            for name in item.imageNames {
                let imageView = UIImageView.alAspectFitWithImageName(name)
                itemView.imagesBoxView.items.append(imageView.boxZero)
            }
            boxView.addItem(itemView.boxBottom(>=0.0))
        }

        boxView.insets = .zero
        boxView.spacing = 4.0
        
    }
}

class AlbumItemView: BoxView {
    
    let titleLabel = UILabel.alWithText("")
    
    let imagesBoxView = BoxView(axis: .x, spacing: 8.0, insets: .zero)
    
    var imagesHeight: NSLayoutConstraint?
    
    override func setup() {
        titleLabel.font = UIFont.systemFont(ofSize: 22)
        backgroundColor = .grayScale(0.9)
        setBorder(color: .grayScale(0.8), width: 1.0)
        layer.cornerRadius = 8.0
        addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(onTap)))
        insets = .all(12.0)
        spacing = 8.0
        items = [
            titleLabel.boxZero,
            imagesBoxView.boxRight(>=0.0)
        ]
        imagesHeight = imagesBoxView.alHeightPin(==50.0)
    }
    
    @objc func onTap(sender: UITapGestureRecognizer) {
        imagesBoxView.axis = imagesBoxView.axis.other
        imagesHeight?.isActive = (imagesBoxView.axis == .x)
        (self.superview as? BoxView)?.animateChangesWithDurations(0.5)
    }
}

