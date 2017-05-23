//
//  ORImageGalleryCVCell.swift
//  Recall
//
//  Created by Evgeny Ivanov on 03.03.17.
//  Copyright © 2017 Omega-R. All rights reserved.
//

import UIKit

protocol ORImageGalleryCVCellDelegate {
    func doSingleTap()
    func doDoubleTap(showBars: Bool)
    func updateMainViewAlpha(alpha: CGFloat)
    func needCloseCollectionView()
}

class ORImageGalleryCVCell: UICollectionViewCell, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    enum PanMode {
        case panModeUndefined
        case panModeLeftRight
        case panModeOnlyUp
        case panModeUpBottom
    }
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    var singleTap: UITapGestureRecognizer!
    var doubleTap: UITapGestureRecognizer!
    var delegate: ORImageGalleryCVCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        doubleTap = UITapGestureRecognizer(target: self, action: #selector(doDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
        
        singleTap = UITapGestureRecognizer(target: self, action: #selector(doSingleTap))
        singleTap.numberOfTapsRequired = 1
        addGestureRecognizer(singleTap)
        singleTap.require(toFail: doubleTap)
    }
    
    func updateMinZoomScaleForSize(size: CGSize) {
        let widthScale = size.width / pictureImageView.bounds.width
        let heightScale = size.height / pictureImageView.bounds.height
        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        updateConstraintsForSize(size: size)
    }
    
    private func updateConstraintsForSize(size: CGSize) {
        let yOffset = max(0, (size.height - pictureImageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - pictureImageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        layoutIfNeeded()
        scrollViewDidScroll(scrollView)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return pictureImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(size: bounds.size)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            let alpha = 1 - abs(scrollView.contentOffset.y) / scrollView.bounds.height
            delegate?.updateMainViewAlpha(alpha: alpha)
        } else {
            delegate?.updateMainViewAlpha(alpha: 1)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < -40 {
            delegate?.needCloseCollectionView()
        }
    }
    
    // MARK: - UIGestureRecognizer methods
    
    func doSingleTap() {
        delegate?.doSingleTap()
    }
    
    func doDoubleTap() {
        if let scrollView = scrollView {
            let zoomScale: CGFloat = scrollView.zoomScale > scrollView.minimumZoomScale ? scrollView.minimumZoomScale : scrollView.minimumZoomScale * 2
            delegate?.doDoubleTap(showBars: false)
            scrollView.setZoomScale(zoomScale, animated: true)
        }
    }
}
