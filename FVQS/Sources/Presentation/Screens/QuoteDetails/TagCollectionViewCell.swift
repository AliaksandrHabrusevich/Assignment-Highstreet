//
//  TagCollectionViewCell.swift
//  FVQS
//
//  Created by Aliaksandr Habrusevich on 2/1/21.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell, NibReusable {

    // MARK: - Properties
    // MARK: Public
    
    // MARK: Private
    @IBOutlet private var textLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .systemBlue
        textLabel.textColor = .white
    }
    
    // MARK: - API
    
    static func width(for tag: String) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        let size = tag.size(withAttributes: fontAttributes)
        return ceil(size.width) + 32
    }
    
    func setTag(_ tag: String) {
        textLabel.text = tag
    }
    
}
