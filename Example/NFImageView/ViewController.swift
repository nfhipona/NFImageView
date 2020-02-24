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
        
        // set capacity
        NFImageCacheAPI.shared.setCapacity(memoryCapacity: 200 * 1024 * 1024, preferredMemoryUsageAfterPurge: 80 * 1024 * 1024)
                
        imageView1.image = nil
        imageView2.image = nil
        imageView3.image = nil
        imageView4.image = nil
        
        imageView1.contentMode = .scaleAspectFill
        imageView2.contentMode = .scaleAspectFill
        imageView3.contentMode = .scaleAspectFill
        imageView4.contentMode = .scaleAspectFill
        
        imageView1.clipsToBounds = true
        imageView2.clipsToBounds = true
        imageView3.clipsToBounds = true
        imageView4.clipsToBounds = true
        
        // NOTE: Test with network conditioner to fully see the effect.
        // Delete app after first load if you want to retest or image from cache will be used.
        
        // used for image view with blur effect
        let thumbnail = "https://images8.alphacoders.com/687/687125.jpg"
        let largeImage = "https://images2.alphacoders.com/704/704946.jpg"
        
        let largeImageSpinner = "https://images2.alphacoders.com/100/1002628.png"
        let largeImageProgress = "https://images.alphacoders.com/747/747289.jpg"
        
//        imageView1.loadingEnabled = false
        imageView1.loadingType = .spinner
        imageView1.contentViewMode = .aspectFit
        imageView1.setImage(fromURLString: largeImageSpinner)
        
//        imageView2.loadingEnabled = false
        imageView2.loadingType = .progress
        imageView2.contentViewMode = .aspectFit
        imageView2.contentViewFill = .TopRight
        imageView2.setImage(fromURLString: largeImageProgress)
        
        // using highlighted image and setting 'contentViewMode' and 'contentViewFill'
        
        imageView3.loadingType = .progress
        imageView3.contentViewMode = .aspectFit
        imageView3.contentViewFill = .Center
        imageView3.image = UIImage(named: "smartphone")
        
        // highlighted after 3s delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.imageView3.highlighted = true
            self.imageView3.tintColor = .red
            self.imageView3.highlightedImage = UIImage(named: "smartphone") // UIImage(named: "TestImage")
        }

//        imageView4.loadingEnabled = false
        imageView4.loadingType = .progress
        imageView4.contentViewMode = .aspectFit
        imageView4.contentViewFill = .Center
        imageView4.setThumbImageAndLargeImage(fromURLString: thumbnail, largeURLString: largeImage)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

