//
//  ViewController.swift
//  NFImageView
//
//  Created by Neil Francis Ramirez Hipona on 07/23/2016.
//  Copyright (c) 2016 Neil Francis Ramirez Hipona. All rights reserved.
//

import UIKit
import NFImageView


class ViewController: UIViewController {
    
    @IBOutlet weak var imageView1: NFImageView!
    @IBOutlet weak var imageView2: NFImageView!
    @IBOutlet weak var imageView3: NFImageView!
    @IBOutlet weak var imageView4: NFImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
        imageView1.contentMode = .scaleAspectFill
        imageView2.contentMode = .scaleAspectFill
        imageView3.contentMode = .scaleAspectFill
        imageView4.contentMode = .scaleAspectFill
        
        imageView1.clipsToBounds = true
        imageView2.clipsToBounds = true
        imageView3.clipsToBounds = true
        imageView4.clipsToBounds = true
        
        // NOTE: Test with network conditioner to fully see the effect.
        
        // used for image view with blur effect
        let thumbnail = "https://scontent.fmnl4-4.fna.fbcdn.net/v/t1.0-9/13529069_10202382982213334_6754953260473113193_n.jpg?oh=28c0f3e751a9177e5ca0afaf23be919e&oe=57F9EEF9"
        let largeImage = "https://scontent.fmnl4-4.fna.fbcdn.net/t31.0-8/13584845_10202382982333337_2990050100601729771_o.jpg"
        
        let thumbnail2 = "https://scontent.fmnl4-4.fna.fbcdn.net/v/t1.0-9/13599954_10202383100616294_8094668176870097608_n.jpg?oh=a97f20061fdd8f90c19fe027119f399e&oe=57F2623E"
        let largeImage2 = "https://scontent.fmnl4-4.fna.fbcdn.net/t31.0-8/13559093_10202383101056305_5896200803868079783_o.jpg"
        
        let largeImageSpinner = "https://scontent.fmnl4-4.fna.fbcdn.net/v/t1.0-0/p206x206/13438921_10202383108576493_2344489318373614654_n.jpg?oh=f2dd51ffa63c2d1f1a91de2b231ebd46&oe=57E9AA07"
        let largeImageProgress = "https://scontent.fmnl4-4.fna.fbcdn.net/t31.0-8/13613290_10202383101656320_342503551114701717_o.jpg"
        
//        imageView1.loadingEnabled = false
        imageView1.loadingType = .spinner
        imageView1.contentViewMode = .aspectFit
//        imageView1.setImageFromURLString(largeImageSpinner)
        
//        imageView2.loadingEnabled = false
        imageView2.loadingType = .progress
        imageView2.contentViewMode = .aspectFit
        imageView2.contentViewFill = .TopRight
//        imageView2.setImageFromURLString(largeImageProgress)
        
        // using highlighted image and setting 'contentViewMode' and 'contentViewFill'
        
        imageView3.loadingType = .progress
        imageView3.contentViewMode = .aspectFit
        imageView3.contentViewFill = .Center
        imageView3.highlighted = true
        imageView3.tintColor = .red
        imageView3.highlightedImage = UIImage(named: "smartphone") // UIImage(named: "TestImage")

//        imageView4.loadingEnabled = false
        imageView4.loadingType = .progress
        imageView4.contentViewMode = .aspectFit
        imageView4.contentViewFill = .Center
        imageView4.setThumbImageAndLargeImage(fromURLString: thumbnail2, largeURLString: largeImage2)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

