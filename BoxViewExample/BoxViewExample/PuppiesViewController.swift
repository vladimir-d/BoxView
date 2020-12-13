//
//  PuppiesViewController.swift
//  BoxViewExample
//
//  Created by Vlad on 6/8/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

class PuppiesViewController: BaseViewController {
            
    struct Album {
        var title = ""
        var text = ""
        var imageNames = [String]()
    }
    
    let albums = [
        Album(title: "Maremma", text: "Maremma and the Abruzzes sheepdog is ideal breed for country house. It is magnificent dog, with inborn guarding instinct.  Maremma always ready to defend family and  property from any predators and intruders. At the same time it is dignified, intelligent and loyal to family friends and livestock.",
            imageNames: (1...5).map{"maremma image \($0)"}),
        Album(title: "Husky", text: "The Siberian Husky is a beautiful dog breed with a thick coat that comes in a multitude of colors and markings. Their blue or multi-colored eyes and striking facial masks only add to the appeal of this breed, which originated in Siberia.", imageNames: (1...5).map{"husky image \($0)"}),
        Album(title: "Malinois", text: "The Belgian Malinois is a diligent, loyal, and highly intelligent dog breed. Large in size with a very streamlined, athletic build, this breed is both strong and agile. The intense and hard-working Belgian Malinois is extremely well-suited to become a working dog, especially in police and military operations. This breed can also make an excellent companion for the right person.", imageNames: (1...8).map{"malinois image \($0)"})
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Puppies"
        for album in albums {
            let itemView = AlbumView()
            itemView.titleLabel.text = album.title
            itemView.textLabel.text = album.text
            itemView.imagesBoxView.items = album.imageNames.map({ PhotoView(imageName: $0) }).boxed
            boxView.addItem(itemView.boxed)
        }
        boxView.spacing = 4.0
    }
}

class AlbumView: BoxView {
    
    let titleLabel = UILabel.alWithText("", textColor: UIColor.brown, font: .boldSystemFont(ofSize: 24))
    
    let textLabel = UILabel.alWithText("", font: UIFont.systemFont(ofSize: 14), numberOfLines: 2)
    
    let imagesBoxView = BoxView(axis: .x, spacing: 6.0, insets: .zero)
    
    let imagesScrollView = UIScrollView()
    
    var expandSwitch = ConstraintSwitch()
    
    override func setup() {
        backgroundColor = .grayScale(0.9)
        setBorder(color: .grayScale(0.8))
        imagesScrollView.showsHorizontalScrollIndicator = false
        imagesScrollView.addBoxItem(imagesBoxView.boxed)
        layer.cornerRadius = 8.0
        addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(onTap)))
        insets = .all(12.0)
        spacing = 8.0
        items = [
            titleLabel.boxed,
            textLabel.boxed.bottom(4.0),
            imagesScrollView.boxed
        ]
        expandSwitch.offSet = [imagesBoxView.pinHeight(50.0)]
        imagesScrollView.pinHeight(to: imagesBoxView)
        expandSwitch.onSet = [imagesBoxView.pinWidth(to: imagesScrollView)]
        self.pinWidth(to: imagesScrollView, offset: insets.left + insets.right)
    }
    
    @objc func onTap(sender: UITapGestureRecognizer) {
        let isExpanded = (imagesBoxView.axis == .x)
        imagesBoxView.axis = imagesBoxView.axis.other
        imagesBoxView.managedViews.forEach { ($0 as? PhotoView)?.setLabelsShown(isExpanded)}
        expandSwitch.state = isExpanded
        textLabel.numberOfLines = isExpanded ? 0 : 2
        (self.superview as? BoxView)?.animateChangesWithDurations(0.5)
    }
}

class PhotoView: BoxView {
    
    var imageView = UIImageView()
    
    let titleLabel = UILabel.alWithText("", font: .boldSystemFont(ofSize: 16))
    
    let sizeLabel = UILabel.alWithText("", font: .systemFont(ofSize: 14))
    
    convenience init(imageName: String?) {
        self.init()
        imageView.setAspectFitImageWithName(imageName)
        titleLabel.text = imageName
        if let imgSize = imageView.image?.size {
        sizeLabel.text = "Size: \(String(format: "%.0f", imgSize.width)) x \(String(format: "%.0f", imgSize.height)) px"
        }
        setLabelsShown(false)
    }
    
    func setLabelsShown(_ shown: Bool) {
        self.optItems = [
            imageView.boxed,
            titleLabel.boxed.top(4.0).useIf(shown),
            sizeLabel.boxed.bottom(16.0).useIf(shown)
        ]
    }
}
