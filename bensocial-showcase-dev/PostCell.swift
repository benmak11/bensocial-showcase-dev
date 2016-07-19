//
//  PostCell.swift
//  bensocial-showcase-dev
//
//  Created by Baynham Makusha on 4/23/16.
//  Copyright © 2016 Ben Makusha. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    var post: Post!
    var request: Request?
    var likeRef: Firebase!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PostCell.likeTapped(_:)))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.userInteractionEnabled = true
        
    }
    
    override func drawRect(rect: CGRect) {
    
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        
        showcaseImg.clipsToBounds = true
    }
    
    func configureCell(post: Post, img: UIImage?) {
        self.post = post
        
        likeRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        
        
        self.descriptionText.text = post.postDescription
        self.likesLbl.text = "\(post.likes)"
        
        if post.imageUrl != nil {
            
            if img != nil {
                self.showcaseImg.image = img
            } else {
                
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
                
                    if err == nil {
                        let img = UIImage(data: data!)!
                        self.showcaseImg.image = img
                        FeedVC.imageCache.setObject(img, forKey: self.post.imageUrl!)
                    }
                
                })
            }
            
        } else {
            self.showcaseImg.hidden = true
        }
        
        //How to manage showing of the correct image
        // 1st: Get a reference to the the current user  -> Done in DataService.swift
        // 2nd: Get a reference to the like
        
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if (snapshot.value as? NSNull) != nil {
                
                //This means we have not liked this specific post
                self.likeImage.image = UIImage(named: "heart-empty")
            } else {
                self.likeImage.image = UIImage(named: "heart-full")
            }
        
        })

    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if (snapshot.value as? NSNull) != nil {
                
                self.likeImage.image = UIImage(named: "heart-full")
                self.post.adjustLikes(true)
                self.likeRef.setValue(true)
                
            } else {
                self.likeImage.image = UIImage(named: "heart-empty")
                self.post.adjustLikes(false)
                self.likeRef.removeValue()
                
            }
            
        })
    }


}
