//
//  ORImageGallery.swift
//  ORImageGallery
//
//  Created by Evgenii on 5/4/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SDWebImage

public protocol ORImageGalleryDataSource {
    func numberOfItems() -> Int
    func item(atIndex index: Int) -> ORImageGalleryItem
    
    func topView() -> UIView?
}

public protocol ORImageGalleryDelegate {
    func imageGalleryDidScroll(toIndex index: Int)
}

open class ORImageGallery: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var csViewBaseWidth: NSLayoutConstraint!
    @IBOutlet weak var csViewBaseHeight: NSLayoutConstraint!
    @IBOutlet weak var viewBase: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    public var dataSource: ORImageGalleryDataSource?
    public var delegate: ORImageGalleryDelegate?
    
    var lastOrientation: UIDeviceOrientation?
    public var closeBySwipe: Bool = false
    
    let cellIdentifier = "pictureCell"
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    
    // MARK: - Lifecycle
    
    public static func createFromNib() -> ORImageGallery {
        let bundle = Bundle(for: self.classForCoder())
        return bundle.loadNibNamed("ORImageGallery", owner: nil, options: nil)?.first as! ORImageGallery
        
//        return ORImageGallery(nibName: "ORImageGallery", bundle: nil)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        if let topView = dataSource?.topView() {
            viewBase.addSubview(topView)
        }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Notifications
    
    func deviceOrientationDidChange() {
        let currentOrientation = UIDevice.current.orientation
        
        if (!UIDeviceOrientationIsValidInterfaceOrientation(currentOrientation)) {
            return
        }
        
        if let lastOrientation = lastOrientation, lastOrientation == currentOrientation {
            return
        }
        
        lastOrientation = currentOrientation
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        var widthConstraintValue = width
        var heightConstraintValue = height
        var angle = CGFloat(0)
        
        switch currentOrientation {
        case .portrait:
            print("Portrait")
        case .portraitUpsideDown:
            print("PortraitUpsideDown")
        case .landscapeLeft:
            widthConstraintValue = height
            heightConstraintValue = width
            angle = CGFloat(Double.pi / 2)
        case .landscapeRight:
            widthConstraintValue = height
            heightConstraintValue = width
            angle = CGFloat(-Double.pi / 2)
        default:
            break
        }
        
//        if setPortrait {
//            setPortrait = false
//            csViewBaseWidth.constant = width
//            csViewBaseHeight.constant = height
//            lastOrientation = .portrait
//            angle = 0
//        } else {
            let index = round(collectionView.contentOffset.x / collectionView.bounds.width)
            selectedIndexPath = IndexPath(row: Int(index), section: 0)
            csViewBaseWidth.constant = widthConstraintValue
            csViewBaseHeight.constant = heightConstraintValue
//        }
        
        viewBase.transform = CGAffineTransform(rotationAngle: angle)
        view.layoutIfNeeded()
        collectionView.reloadData()
//        scrollCollectionView()
    }
    
    // MARK: - UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems() ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ORImageGalleryCVCell else {
            return UICollectionViewCell()
        }
        
        if let item = dataSource?.item(atIndex: indexPath.row) {
            switch item {
            case .itemWithImage(let image):
                cell.pictureImageView.image = image
            case .itemWithURL(let url):
                cell.pictureImageView.sd_setImage(with: url, completed: { (image, error, type, url) in
                    cell.pictureImageView.contentMode = .scaleAspectFit
                    cell.contentView.layoutIfNeeded()
                })
                break
            }
        }
        cell.updateMinZoomScaleForSize(size: self.viewBase.bounds.size)
        
        return cell
    }

    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: csViewBaseWidth.constant, height: csViewBaseHeight.constant)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ORImageGalleryCVCell {
            cell.scrollView.setZoomScale(cell.scrollView.minimumZoomScale, animated: false)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = round(scrollView.contentOffset.x / scrollView.bounds.width)
        delegate?.imageGalleryDidScroll(toIndex: Int(index))
    }
    
}
