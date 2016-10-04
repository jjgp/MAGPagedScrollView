//
//  PagedScrollView.swift
//  MAGPagedScrollViewDemo
//
//  Created by Ievgen Rudenko on 21/08/15.
//  Copyright (c) 2015 MadAppGang. All rights reserved.
//

import UIKit

public enum PagedScrollViewTransitionType {
    case none
    case slide
    case dive
    case roll
    case cards
    case custom
}

@objc public protocol ViewProvider {
    
    /// View Provider should return the view to display
     var view: UIView! { get }
    
    /**
    Send to ViewProver, when reuse, to reset state
    */
    @objc optional func prepareForReuse()
    
}



open class PagedScrollView: UIScrollView {
    
    /// Transition type
    open var transition: PagedScrollViewTransitionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    /// currentPage Number
    open var pageNumber:Int   {
        let pageWidth = self.frame.width
        let factionalPage = self.contentOffset.x / pageWidth
        return lround(Double(factionalPage))
    }
    /// Custom transition
    open var customTransition = PagedScrollViewTransitionProperties()
    
    fileprivate var transitionProperties:[PagedScrollViewTransitionType:PagedScrollViewTransitionProperties]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    open func commonInit() {
        isPagingEnabled = true
        clipsToBounds = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        transitionProperties = [
            .none:  PagedScrollViewTransitionProperties(),
            .slide: PagedScrollViewTransitionProperties(angleRatio: 0.0, translation: CGVector(dx:0.25,dy:0.25), rotation: Rotation3D()),
            .dive:  PagedScrollViewTransitionProperties(angleRatio: 0.5, translation: CGVector(dx:0.25,dy:0.0), rotation: Rotation3D(x:-1.0,y:0.0,z:0.0)),
            .roll:  PagedScrollViewTransitionProperties(angleRatio: 0.5, translation: CGVector(dx:0.25,dy:0.25), rotation: Rotation3D(x:-1.0,y:0.0,z:0.0)),
            .cards: PagedScrollViewTransitionProperties(angleRatio: 0.5, translation: CGVector(dx:0.25,dy:0.25), rotation: Rotation3D(x:-1.0,y:-1.0,z:0.0)),
            .custom:PagedScrollViewTransitionProperties()
        ]
    }

    
    open func addSubviews(_ aSubviews: [ViewProvider]) {
        let frameI = UIEdgeInsetsInsetRect(frame, contentInset)
        let width = frameI.width
        let height = frameI.height

        var x:CGFloat = 0
        
        for view in aSubviews {
            view.view.frame = CGRect(x: x, y: 0.0, width: width, height: height)
            addSubview(view.view)
            x += width
        }
        
        contentSize = CGSize(width: x, height: height)
    }
    
    open func goNext() {
        self.goToPage(self.pageNumber + 1, animated: true)
    }
    
    open func goPrevious() {
        self.goToPage(self.pageNumber - 1, animated: true)
    }
    
    open func goToPage(_ page:Int, animated:Bool) {
        var newFrame = frame
        let newX = frame.size.width * CGFloat(page)
        newFrame.origin = CGPoint(x:newX, y:0.0)
        scrollRectToVisible(newFrame, animated: animated)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()

        let tr = transition == .custom ? customTransition : transitionProperties[transition]!
        
        //Get previous view, current view and next view
        
        
        for view in viewsOnScreen() {
            //save tramsform state
            let oldTransform = view.layer.transform
            view.layer.transform = CATransform3DIdentity
            
            let centerDX = (view.frame.origin.x - contentOffset.x) * 100 / frame.width
            view.layer.transform = oldTransform
            
            let angle = centerDX * tr.angleRatio
            let translateX = frame.width * tr.translation.dx * centerDX / 100.0
            let translateY = frame.width * tr.translation.dy * abs(centerDX) / 100.0
            let transform3D = CATransform3DMakeTranslation(translateX, translateY, 0.0)
            
            view.layer.transform = CATransform3DRotate(transform3D, angle.degreesToRadians, tr.rotation.x, tr.rotation.y, tr.rotation.z)
        }
    }
    
    open func viewsOnScreen() -> [UIView] {
        var result = [UIView]()
        let page = pageNumber
        if page > 0 && (page-1) < subviews.count {
            result.append(subviews[page-1] )
        }
        if page < subviews.count {
            result.append(subviews[page] )
        }
        if (page+1) < subviews.count {
            result.append(subviews[page+1] )
        }
        
        
        return result
    }
    
    
}

public struct PagedScrollViewTransitionProperties {
    var angleRatio:     CGFloat = 0.0
    var translation:    CGVector = CGVector(dx:0.0, dy:0.0)
    var rotation:       Rotation3D = Rotation3D()
}

public struct Rotation3D {
    var x:CGFloat = 0.0
    var y:CGFloat = 0.0
    var z:CGFloat = 0.0
}


extension CGFloat {
    
    var degreesToRadians : CGFloat {
        return CGFloat(self) * CGFloat(M_PI) / 180.0
    }
    
    var radiansToDegrees : CGFloat {
        return CGFloat(self) / CGFloat(M_PI) * 180.0
    }
}

extension UIView: ViewProvider {
    public var view: UIView! { return self }
}


// MARK: - UIViewController as View Provider
extension UIViewController: ViewProvider { }
