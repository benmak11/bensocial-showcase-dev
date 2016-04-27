//
//  FeedVC.swift
//  bensocial-showcase-dev
//
//  Created by Baynham Makusha on 4/23/16.
//  Copyright © 2016 Ben Makusha. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postField: MaterialTextField!
    @IBOutlet weak var imageSelectorImg: UIImageView!
    
    
    var posts = [Post]()
    
    // one instance of it in memory
    static let imageCache = NSCache()
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 355
        imageSelectorImg.layer.cornerRadius = 2.0
        imageSelectorImg.clipsToBounds = true
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        initObservers()
        
    }
    
    func initObservers() {
        
        //Downloading the data from Firebase
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            
            // Test printing data
            print(snapshot.value)
            
            
            self.posts = []    // Clearing the post data
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    
                    //Parsing the data out of the Dictionary and into the post object
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        //print(post.postDescription)
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell{
            
            //Cancel the image request when cellForRowAtIndexPath is called because it means
            //we need to recycle the cell and we need the old request to stop downloading the image
            cell.request?.cancel()
            
            //Declare an empty image variable
            var img: UIImage?
            
            //If there is a url for an image, try and get it from the local cache first
            //before we attempt to download it
            if let url = post.imageUrl {
                img = FeedVC.imageCache.objectForKey(url) as? UIImage
            }
            
            cell.configureCell(post, img: img)
            
            return cell
        } else{
            return PostCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let post = posts[indexPath.row]
        
        if post.imageUrl == nil {
            return 150
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageSelectorImg.image = image
    }
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func makePost(sender: AnyObject) {
        
        if let txt = postField.text where txt != "" {
            
            if let img = imageSelectorImg.image {
                
                let urlStr = "https://post.imageshack.us/upload_api.php"
                let url = NSURL(string: urlStr)!
                let imgData = UIImageJPEGRepresentation(img, 0.2)!
                let keyData = "07BDENRW9e6fd50c983ce6e1f3e12183cb725aec".dataUsingEncoding(NSUTF8StringEncoding)!  //Using personal API Key from ImageShack: Trial account
                let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                
                Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
                    
                    multipartFormData.appendBodyPart(data: imgData, name: "fileupload", fileName: "image", mimeType: "image/jpg")
                    multipartFormData.appendBodyPart(data: keyData, name: "key")
                    multipartFormData.appendBodyPart(data: keyJSON, name: "format")
                    
                }) { encodingResult in
                    
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        
                        upload.responseJSON(completionHandler: { response in
                            
                            print(response.result.value)
                            if let info = response.result.value as? Dictionary<String, AnyObject> {
                                
                                if let links = info["links"] as? Dictionary<String, String> {
                                    if let imgLink = links["image_link"] as String! {
                                        print("LINK: \(imgLink)")
                                        //self.postToFirebase(imgLink)
                                    }
                                }
                            }
                        })
                    case .Failure(let error):
                        print(error)
                    }
                
                }
            }
        }
    }
    
    func postToFirebase(imgUrl: String?) {
        
    }

}
