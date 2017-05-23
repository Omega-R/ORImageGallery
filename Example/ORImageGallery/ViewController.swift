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
    
    let pictures = ["https://www.grumpycats.com/images/about/tardar.jpg",
                    "https://yt3.ggpht.com/-V92UP8yaNyQ/AAAAAAAAAAI/AAAAAAAAAAA/zOYDMx8Qk3c/s900-c-k-no-mo-rj-c0xffffff/photo.jpg",
                    "https://cdn5.thr.com/sites/default/files/imagecache/scale_crop_768_433/2014/09/too_good_for_grumpy_cat.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showGalleryTouched(_ sender: Any) {
        let galleryController = ORImageGallery.createFromNib()
        galleryController.dataSource = self
        galleryController.delegate = self
        galleryController.selectedIndex = 1
        galleryController.rotation = true
        galleryController.closeBySwipe = true
        present(galleryController, animated: true, completion: nil)
    }
    
    func closePressed() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - ORImageGalleryDataSource
    
    func numberOfItemsInOrGallery(_ gallery: ORImageGallery) -> Int {
        return pictures.count
    }
    
    func orGallery(_ gallery: ORImageGallery, itemAt index: Int) -> ORImageGalleryItem {
        let picture = pictures[index]
        return ORImageGalleryItem.itemWithURL(url: URL(string: picture)!)
    }
    
    func orGallery(_ gallery: ORImageGallery, topView: UIView) {
        let b = UIButton(frame: CGRect(x: 16, y: 16, width: 44, height: 44))
        b.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        b.setTitle("Close", for: .normal)
        b.sizeToFit()
        topView.addSubview(b)
    }
    
    // MARK: - ORImageGalleryDelegate
    
    func imageGalleryDidScroll(toIndex index: Int) {
        print(index)
    }
    
}

