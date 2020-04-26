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
    
    @IBOutlet weak var contentFIllButton: UIButton!
    @IBOutlet weak var contentModeButton: UIButton!
    
    @IBAction func contentFIllButton(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Content View Fill", message: "Change content view fill on the image views", preferredStyle: .actionSheet)
        
        let centerFill = UIAlertAction(title: "Center Fill", style: .default) { _ in
            self.changeFill(imageView: self.imageView1, fill: .Center)
            self.changeFill(imageView: self.imageView2, fill: .Center)
            self.changeFill(imageView: self.imageView3, fill: .Center)
            self.changeFill(imageView: self.imageView4, fill: .Center)
        }
        
        let leftFill = UIAlertAction(title: "Left Fill", style: .default) { _ in
            self.changeFill(imageView: self.imageView1, fill: .Left)
            self.changeFill(imageView: self.imageView2, fill: .Left)
            self.changeFill(imageView: self.imageView3, fill: .Left)
            self.changeFill(imageView: self.imageView4, fill: .Left)
        }
        
        let rightFill = UIAlertAction(title: "Right Fill", style: .default) { _ in
            self.changeFill(imageView: self.imageView1, fill: .Right)
            self.changeFill(imageView: self.imageView2, fill: .Right)
            self.changeFill(imageView: self.imageView3, fill: .Right)
            self.changeFill(imageView: self.imageView4, fill: .Right)
        }
        
        let topFill = UIAlertAction(title: "Top Fill", style: .default) { _ in
            self.changeFill(imageView: self.imageView1, fill: .Top)
            self.changeFill(imageView: self.imageView2, fill: .Top)
            self.changeFill(imageView: self.imageView3, fill: .Top)
            self.changeFill(imageView: self.imageView4, fill: .Top)
        }

        let bottomFill = UIAlertAction(title: "Bottom Fill", style: .default) { _ in
            self.changeFill(imageView: self.imageView1, fill: .Bottom)
            self.changeFill(imageView: self.imageView2, fill: .Bottom)
            self.changeFill(imageView: self.imageView3, fill: .Bottom)
            self.changeFill(imageView: self.imageView4, fill: .Bottom)
        }
        
        let topLeft = UIAlertAction(title: "TopLeft Fill", style: .default) { _ in
            self.changeFill(imageView: self.imageView1, fill: .TopLeft)
            self.changeFill(imageView: self.imageView2, fill: .TopLeft)
            self.changeFill(imageView: self.imageView3, fill: .TopLeft)
            self.changeFill(imageView: self.imageView4, fill: .TopLeft)
        }
        
        let topRight = UIAlertAction(title: "TopRight Fill", style: .default) { _ in
            self.changeFill(imageView: self.imageView1, fill: .TopRight)
            self.changeFill(imageView: self.imageView2, fill: .TopRight)
            self.changeFill(imageView: self.imageView3, fill: .TopRight)
            self.changeFill(imageView: self.imageView4, fill: .TopRight)
        }
        
        let bottomLeft = UIAlertAction(title: "BottomLeft Fill", style: .default) { _ in
            self.changeFill(imageView: self.imageView1, fill: .BottomLeft)
            self.changeFill(imageView: self.imageView2, fill: .BottomLeft)
            self.changeFill(imageView: self.imageView3, fill: .BottomLeft)
            self.changeFill(imageView: self.imageView4, fill: .BottomLeft)
        }
        
        let bottomRight = UIAlertAction(title: "BottomRight Fill", style: .default) { _ in
            self.changeFill(imageView: self.imageView1, fill: .BottomRight)
            self.changeFill(imageView: self.imageView2, fill: .BottomRight)
            self.changeFill(imageView: self.imageView3, fill: .BottomRight)
            self.changeFill(imageView: self.imageView4, fill: .BottomRight)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(centerFill)
        alertController.addAction(leftFill)
        alertController.addAction(rightFill)
        alertController.addAction(topFill)
        alertController.addAction(bottomFill)
        alertController.addAction(topLeft)
        alertController.addAction(topRight)
        alertController.addAction(bottomLeft)
        alertController.addAction(bottomRight)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func contentModeButton(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Content View Mode", message: "Change content view mode on the image views", preferredStyle: .actionSheet)

        let fill = UIAlertAction(title: "Fill Mode", style: .default) { _ in
            self.changeMode(imageView: self.imageView1, mode: .fill)
            self.changeMode(imageView: self.imageView2, mode: .fill)
            self.changeMode(imageView: self.imageView3, mode: .fill)
            self.changeMode(imageView: self.imageView4, mode: .fill)
        }
        
        let aspectFit = UIAlertAction(title: "Aspect Fit Mode", style: .default) { _ in
            self.changeMode(imageView: self.imageView1, mode: .aspectFit)
            self.changeMode(imageView: self.imageView2, mode: .aspectFit)
            self.changeMode(imageView: self.imageView3, mode: .aspectFit)
            self.changeMode(imageView: self.imageView4, mode: .aspectFit)
        }
        
        let aspectFill = UIAlertAction(title: "Aspect Fill Mode", style: .default) { _ in
            self.changeMode(imageView: self.imageView1, mode: .aspectFill)
            self.changeMode(imageView: self.imageView2, mode: .aspectFill)
            self.changeMode(imageView: self.imageView3, mode: .aspectFill)
            self.changeMode(imageView: self.imageView4, mode: .aspectFill)
        }
        
        let originalSize = UIAlertAction(title: "Original Image Size", style: .default) { _ in
            self.changeMode(imageView: self.imageView1, mode: .originalSize)
            self.changeMode(imageView: self.imageView2, mode: .originalSize)
            self.changeMode(imageView: self.imageView3, mode: .originalSize)
            self.changeMode(imageView: self.imageView4, mode: .originalSize)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(fill)
        alertController.addAction(aspectFit)
        alertController.addAction(aspectFill)
        alertController.addAction(originalSize)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set capacity
        NFImageCacheAPI.shared.setCapacity(memoryCapacity: 200 * 1024 * 1024, preferredMemoryUsageAfterPurge: 80 * 1024 * 1024)
                
        setupImageView(imageView: imageView1)
        setupImageView(imageView: imageView2)
        setupImageView(imageView: imageView3)
        setupImageView(imageView: imageView4)
        
        // NOTE: Test with network conditioner to fully see the effect.
        // Delete app after first load if you want to retest or image from cache will be used.
        
        // let placeholder = UIImage(named: "placeholder")
        
        // used for image view with blur effect
        let thumbnail = "https://images8.alphacoders.com/687/687125.jpg"
        let largeImage = "https://images2.alphacoders.com/704/704946.jpg"
        
        let largeImageSpinner = "https://images2.alphacoders.com/100/1002628.png"
        let largeImageProgress = "https://images.alphacoders.com/747/747289.jpg"
        
        imageView1.loadingType = .spinner
        imageView1.setImage(fromURLString: largeImageSpinner)
        
        imageView2.loadingType = .progress
        imageView2.setImage(fromURLString: largeImageProgress)
        
        // using highlighted image and setting 'contentViewMode' and 'contentViewFill'
        
        imageView3.loadingEnabled = false
        imageView3.image = UIImage(named: "music")
        
        // highlighted after 3s delay
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.imageView3.highlighted = true
            self.imageView3.tintColor = .red
            self.imageView3.highlightedImage = UIImage(named: "music") // UIImage(named: "TestImage")
        }*/

        imageView4.loadingType = .progress
        imageView4.setThumbImageAndLargeImage(fromURLString: thumbnail, largeURLString: largeImage)
        // imageView4.setThumbImageAndLargeImage(fromURLString: thumbnail, largeURLString: largeImage, placeholder: placeholder)
        
        /*
        imageView1.setImage(fromURL: <#T##URL#>)
        imageView1.setImage(fromURL: <#T##URL#>, completion: <#T##NFImageViewRequestCompletion?##NFImageViewRequestCompletion?##(NFImageViewRequestCode, NSError?) -> Void#>)
        
        imageView1.setImage(fromURLString: <#T##String#>)
        imageView1.setImage(fromURLString: <#T##String#>, completion: <#T##NFImageViewRequestCompletion?##NFImageViewRequestCompletion?##(NFImageViewRequestCode, NSError?) -> Void#>)
        
        imageView1.setThumbImageAndLargeImage(fromURL: <#T##URL#>, largeURL: <#T##URL#>)
        imageView1.setThumbImageAndLargeImage(fromURL: <#T##URL#>, largeURL: <#T##URL#>, completion: <#T##NFImageViewRequestCompletion?##NFImageViewRequestCompletion?##(NFImageViewRequestCode, NSError?) -> Void#>)
        
        imageView1.setThumbImageAndLargeImage(fromURLString: <#T##String#>, largeURLString: <#T##String#>)
        imageView1.setThumbImageAndLargeImage(fromURLString: <#T##String#>, largeURLString: <#T##String#>, completion: <#T##NFImageViewRequestCompletion?##NFImageViewRequestCompletion?##(NFImageViewRequestCode, NSError?) -> Void#>)
        */
    }
    
    func setupImageView(imageView: NFImageView) {
        
        imageView.image = nil
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 1.0
        
        imageView.contentViewMode = .aspectFit
        imageView.contentViewFill = .Center
    }
    
    func changeMode(imageView: NFImageView, mode: NFImageView.ContentMode) {
        
        imageView.contentViewMode = mode
    }
    
    func changeFill(imageView: NFImageView, fill: NFImageView.ContentFill) {
        
        imageView.contentViewFill = fill
    }
    
}

