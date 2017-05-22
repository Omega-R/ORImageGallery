//
//  ORImageGallery.swift
//  ORImageGallery
//
//  Created by Evgenii on 5/4/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

protocol ORImageGalleryDataSource {
    func numberOfItem() -> Int
    func item(atIndex index: Int) -> ORImageGalleryItem
    
    func topBarView() -> UIView?
    func bottomBarView() -> UIView?
}

protocol ORImageGalleryDelegate {
    
}

class ORImageGallery: UIViewController {

    var dataSource: ORImageGalleryDataSource?
    var delegate: ORImageGalleryDelegate?
    
    var collectionView: UICollectionView!
    
    // MARK: - Init methods
    
    convenience init(){
        self.init()
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
