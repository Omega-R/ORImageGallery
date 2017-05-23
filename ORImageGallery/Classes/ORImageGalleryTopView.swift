//
//  ORImageGalleryTopView.swift
//  Pods
//
//  Created by Evgenii on 5/23/17.
//
//

import UIKit

class ORImageGalleryTopView: UIView {

    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let v = super.hitTest(point, with: event) else {
            return nil
        }
        
        let needToIgnoreHit = v == self
        return needToIgnoreHit ? nil : v
    }

}
