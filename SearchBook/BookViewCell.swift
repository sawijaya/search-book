//
//  BookViewCell.swift
//  SearchBook
//
//  Created by sawijaya on 7/17/18.
//  Copyright © 2018 sawijaya. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher

class BookViewCell: UITableViewCell {
    static let identifier = "BookViewCellIdentifier"
    
    @IBOutlet weak var imgvw: UIImageView!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwRating: CosmosView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwRating.isUserInteractionEnabled = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.reset()
    }
    
    func reset(){
        self.imgvw.image = nil
        self.lblTitle.text = nil
        self.lblAuthor.text = nil
        self.vwRating.rating = 0
        self.vwRating.isHidden = true
    }
    
    var data:[String:Any]! {
        willSet{
            let volumeInfo:[String:Any] = newValue["volumeInfo"] as? [String:Any] ?? [:]
            self.lblTitle.text = volumeInfo["title"] as? String ?? ""
            let authors:[String] = volumeInfo["authors"] as? [String] ?? ["-"]
            self.lblAuthor.text = authors.joined(separator: ", ")
            if let averageRating: Double  = volumeInfo["averageRating"] as? Double {
                self.vwRating.isHidden = false
                self.vwRating.rating = averageRating
            }
            
            if let imageLinks:[String:Any] = volumeInfo["imageLinks"] as? [String:Any] {
                if let thumbnail: String = imageLinks["thumbnail"] as? String {
                    let url = URL(string: thumbnail)
                    self.imgvw.kf.setImage(with: url)
                }
            }
        }
        didSet{
            
        }
    }
}
