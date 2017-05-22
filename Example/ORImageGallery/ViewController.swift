//
//  ViewController.swift
//  ORImageGallery
//
//  Created by Evgeny Ivanov on 05/04/2017.
//  Copyright (c) 2017 Evgeny Ivanov. All rights reserved.
//

import UIKit
import ORImageGallery

class ViewController: UIViewController, ORImageGalleryDataSource, ORImageGalleryDelegate {

    let pictures = ["https://i2.kym-cdn.com/photos/images/newsfeed/000/406/325/b31.jpg",
                    "https://yt3.ggpht.com/-V92UP8yaNyQ/AAAAAAAAAAI/AAAAAAAAAAA/zOYDMx8Qk3c/s900-c-k-no-mo-rj-c0xffffff/photo.jpg",
                    "https://cdn5.thr.com/sites/default/files/imagecache/scale_crop_768_433/2014/09/too_good_for_grumpy_cat.jpg"]
    
    let galleryController = ORImageGallery.createFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showGalleryTouched(_ sender: Any) {
        galleryController.dataSource = self
        galleryController.delegate = self
        present(galleryController, animated: true, completion: nil)
    }
    
    // MARK: - ORImageGalleryDataSource
    
    func numberOfItems() -> Int {
        return pictures.count
    }
    
    func item(atIndex index: Int) -> ORImageGalleryItem {
        let picture = pictures[index]
        return ORImageGalleryItem.itemWithURL(url: URL(string: picture)!)
    }
    
    func topView() -> UIView? {
        return nil
    }
    
    // MARK: - ORImageGalleryDelegate
    
    func imageGalleryDidScroll(toIndex index: Int) {
        
    }
    
}

