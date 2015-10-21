//
//  CreationProfileCustomCell.swift
//  Orphee
//
//  Created by Jeromin Lebon on 06/09/2015.
//  Copyright © 2015 __ORPHEE__. All rights reserved.
//

import Foundation
import UIKit

class CreationProfileCustomCell: UITableViewCell {
    
    @IBOutlet var imgCreation: UIImageView!
    @IBOutlet var nameCreation: UILabel!
    @IBOutlet var nbLikesCreation: UILabel!
    @IBOutlet var nbCommentsCreation: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var commentButton: UIButton!
    
    func putInGraphic(creation: Creation){
        if let nameCreation = creation.name{
            self.nameCreation.text = nameCreation.substringWithRange(
                Range<String.Index>(start: nameCreation.startIndex.advancedBy(0),
                    end: nameCreation.endIndex.advancedBy(-4)))
        }
        if let nbComments = creation.nbCommments{
            self.nbCommentsCreation.text = String(nbComments)
        }
        if let nbLikes = creation.nbLikes{
            self.nbLikesCreation.text = String(nbLikes)
        }
        setLayout()
    }
    
    func setLayout(){
        self.layer.shadowOffset = CGSizeMake(-0.2, 0.2)
        self.layer.shadowRadius = 1
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).CGPath
        self.layer.shadowOpacity = 0.2
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = false;
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
}