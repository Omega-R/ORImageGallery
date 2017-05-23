//
//  ORImageGallery.swift
//  ORImageGallery
//
//  Created by Evgenii on 5/4/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SDWebImage
import PureLayout

public protocol ORImageGalleryDataSource {
    func numberOfItems() -> Int
    func item(atIndex index: Int) -> ORImageGalleryItem
    
    func topView() -> UIView?
}

public protocol ORImageGalleryDelegate {
    func imageGalleryDidScroll(toIndex index: Int)
}

open class ORImageGallery: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, ORImageGalleryCVCellDelegate {

    @IBOutlet weak var csViewBaseWidth: NSLayoutConstraint!
    @IBOutlet weak var csViewBaseHeight: NSLayoutConstraint!
    @IBOutlet weak var viewBase: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topSpaceCollectionView: NSLayoutConstraint!
    @IBOutlet weak var bottomCollectionView: NSLayoutConstraint!
    @IBOutlet weak var viewForTopView: UIView!
    
    public var dataSource: ORImageGalleryDataSource?
    public var delegate: ORImageGalleryDelegate?
    public var closeBySwipe = false
    public var selectedIndex = 0
    public var rotation = false
    
    let cellIdentifier = "pictureCell"
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    var lastOrientation: UIDeviceOrientation?
    var firstOrientationChange = true
    var topView: UIView?
    
    var pan: UIPanGestureRecognizer!
    var panDistanceX: CGFloat = 0
    var panDistanceY: CGFloat = 0
    var pointPreviousPan = CGPoint(x: 0, y: 0)
    var previousAllInfoHeight: CGFloat = 0
    
    // MARK: - Lifecycle
    
    public static func createFromNib() -> ORImageGallery {
        let bundle = Bundle(for: self.classForCoder())
        let controller = bundle.loadNibNamed("ORImageGallery", owner: nil, options: nil)?.first as! ORImageGallery
        controller.modalPresentationStyle = .overCurrentContext
        return controller
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        let bundle = Bundle(for: self.classForCoder)
        let nib = UINib(nibName: "ORImageGalleryCVCell", bundle: bundle)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topView = dataSource?.topView()
        selectedIndexPath = IndexPath(row: selectedIndex, section: 0)
        deviceOrientationDidChange()
        
        if rotation {
            NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        }
        
        if closeBySwipe {
            pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            view.addGestureRecognizer(pan)
        }
        
        if topView != nil {
            viewForTopView.addSubview(topView!)
            topView!.autoPinEdgesToSuperviewEdges()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func scrollCollectionView() {
        if selectedIndexPath == IndexPath(row: 0, section: 0) {
            return
        }
        collectionView.scrollToItem(at: selectedIndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
    }
    
    fileprivate func closeViewController() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIGestureRecognizer methods
    
    func handlePan(_ recognizaer: UIPanGestureRecognizer) {
        let point = recognizaer.location(in: view)
        
        if pointPreviousPan == .zero {
            pointPreviousPan = point
        }
        
        var yDiff = point.y - pointPreviousPan.y;
        var xDiff = point.x - pointPreviousPan.x
        
        if lastOrientation == .landscapeLeft || lastOrientation == .landscapeRight {
            swap(&xDiff, &yDiff)
            yDiff = lastOrientation == .landscapeLeft ? -yDiff : yDiff
        }
        
        if fabs(xDiff) > fabs(yDiff) {
            return
        }
        
        pointPreviousPan = point;
        
        let isLastPanGesture = recognizaer.state == .ended
        
        var nextYConst = topSpaceCollectionView.constant + yDiff
        nextYConst = nextYConst < 0 ? 0 : nextYConst
        
        topSpaceCollectionView.constant = nextYConst
        bottomCollectionView.constant = -nextYConst
        let maxOffset = collectionView.bounds.height
        let alpha = 1 - abs(nextYConst) / maxOffset
        updateMainViewAlpha(alpha: alpha)
        
        if isLastPanGesture {
            if alpha < 1 {
                needCloseCollectionView()
            }
            pointPreviousPan = .zero
        }
    }
    
    // MARK: - Notifications
    
    func deviceOrientationDidChange() {
        let currentOrientation = UIDevice.current.orientation
        
        if (!UIDeviceOrientationIsValidInterfaceOrientation(currentOrientation)) && !firstOrientationChange {
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
        
        if firstOrientationChange {
            firstOrientationChange = false
            csViewBaseWidth.constant = width
            csViewBaseHeight.constant = height
            lastOrientation = .portrait
            angle = 0
        } else {
            let index = round(collectionView.contentOffset.x / collectionView.bounds.width)
            selectedIndexPath = IndexPath(row: Int(index), section: 0)
            csViewBaseWidth.constant = widthConstraintValue
            csViewBaseHeight.constant = heightConstraintValue
        }
        
        viewBase.transform = CGAffineTransform(rotationAngle: angle)
        view.layoutIfNeeded()
        collectionView.reloadData()
        scrollCollectionView()
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
                cell.updateMinZoomScaleForSize(size: self.viewBase.bounds.size)
            case .itemWithURL(let url):
                cell.pictureImageView.sd_setImage(with: url, completed: { (image, error, type, url) in
                    cell.pictureImageView.contentMode = .scaleAspectFit
                    cell.contentView.layoutIfNeeded()
                    cell.updateMinZoomScaleForSize(size: self.viewBase.bounds.size)
                })
                break
            }
        }
        
        cell.delegate = self
        cell.contentView.layoutIfNeeded()
        cell.scrollView.setZoomScale(cell.scrollView.minimumZoomScale, animated: false)
        
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
    
    // MARK: - ORImageGalleryCVCellDelegate
    
    func doSingleTap() {
        topView?.isHidden = !(topView?.isHidden ?? false)
    }
    
    func doDoubleTap(showBars: Bool) {
        topView?.isHidden = !showBars
    }
    
    func updateMainViewAlpha(alpha: CGFloat) {
        if closeBySwipe {
            view.alpha = alpha
        }
    }
    
    func needCloseCollectionView() {
        if closeBySwipe {
            closeViewController()
        }
    }
    
}
