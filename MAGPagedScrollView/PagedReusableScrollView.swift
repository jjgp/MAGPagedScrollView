//
//  MAGPagedReusableScrollView.swift
//  MAGPagedScrollViewDemo
//
//  Created by Ievgen Rudenko on 21/08/15.
//  Copyright (c) 2015 MadAppGang. All rights reserved.
//

import UIKit

@objc public protocol PagedReusableScrollViewDataSource {
    func scrollView(_ scrollView: PagedReusableScrollView, viewIndex index: Int) -> ViewProvider
    func numberOfViews(forScrollView scrollView: PagedReusableScrollView) -> Int
    
    @objc optional func scrollView(scrollView: PagedReusableScrollView, willShowView view:ViewProvider)
    @objc optional func scrollView(scrollView: PagedReusableScrollView, willHideView view:ViewProvider)
    @objc optional func scrollView(scrollView: PagedReusableScrollView, didShowView view:ViewProvider)
    @objc optional func scrollView(scrollView: PagedReusableScrollView, didHideView view:ViewProvider)

}

open class PagedReusableScrollView: PagedScrollView {
    
    @IBOutlet open weak var dataSource:PagedReusableScrollViewDataSource! {
        didSet {
            reload()
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        reload()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        reload()
    }

    
    open func reload() {
        clearAllViews()
        if let ds = dataSource {
            viewsCount = ds.numberOfViews(forScrollView: self)
            resizeContent()
            reloadVisisbleViews()
        }
        setNeedsLayout()
    }
    

    open var visibleIndexes:[Int] {
        if let viewsCount = viewsCount {
            var result = [Int]()
            //Add previous page
            if pageNumber > 0 && (pageNumber-1) < viewsCount {
                result.append(pageNumber-1)
            }
            //Add curent page
            if pageNumber < viewsCount {
                result.append(pageNumber)
            }
            //Add next page
            if (pageNumber+1) < viewsCount {
                result.append(pageNumber+1)
            }
            return result
        } else {
            return []
        }
    }
    
    override open func viewsOnScreen() -> [UIView] {
        return visibleIndexes.sorted{ $0 > $1 }.map{ self.activeViews[$0]!.view }
    }

    
    open func dequeueReusableView(tag:Int) -> ViewProvider? {
        for (index, view) in dirtyViews.enumerated() {
            if view.view.tag == tag {
                dirtyViews.remove(at: index)
                view.prepareForReuse?()
                return view
            }
        }
        return nil
    }
    
    open func dequeueReusableView(viewClass:AnyClass) -> ViewProvider? {
        for (index, view) in dirtyViews.enumerated() {
            if view.view.isKind(of: viewClass) {
                dirtyViews.remove(at: index)
                view.prepareForReuse?()
                return view
            }
        }
        return nil
    }

  
    override open func didMoveToSuperview() {
        super.didMoveToSuperview();
        if superview != nil {
            reload()
        }
    }
    
    //MARK: private data
    fileprivate(set) open var activeViews:[Int:ViewProvider] = [:]
    fileprivate var dirtyViews:[ViewProvider] = []
    fileprivate var viewsCount:Int?
    fileprivate var itemSize:CGSize = CGSize.zero
    
    fileprivate func reloadVisisbleViews() {
        let visibleIdx  = visibleIndexes.sorted{ $0 > $1 }
        let activeIdx = activeViews.keys.sorted{ $0 > $1 }
        if visibleIdx != activeIdx {
            //get views to make them dirty
            _ = activeIdx.substract(visibleIdx).map { self.makeViewDirty(index:$0) }
            // add new views
            _ = visibleIdx.substract(activeIdx).map { self.addView(index:$0) }
            setNeedsLayout()
        }
    }
    
    override open func layoutSubviews() {
        if itemSize != UIEdgeInsetsInsetRect(frame, contentInset).size {
            reload()
            return
        }
        reloadVisisbleViews()
        super.layoutSubviews()
    }

    
    fileprivate func makeViewDirty(index:Int) {
        if let view = activeViews[index] {
            dataSource?.scrollView?(scrollView: self, willHideView: view)
            view.view.removeFromSuperview()
            dataSource?.scrollView?(scrollView: self, didHideView: view)
            view.view.layer.transform = CATransform3DIdentity
            dirtyViews.append(view)
            activeViews.removeValue(forKey: index)
        }
    }
    
    fileprivate func addView(index:Int) {
        
        if let view = dataSource?.scrollView(self, viewIndex: index) {
            view.view.removeFromSuperview()
            let frameI = UIEdgeInsetsInsetRect(frame, contentInset)
            let width = frameI.width
            let height = frameI.height
            let x:CGFloat = CGFloat(index) * width
            view.view.frame = CGRect(x: x, y: 0, width: width, height: height)
            dataSource?.scrollView?(scrollView: self, willShowView: view)
            addSubview(view.view)
            dataSource?.scrollView?(scrollView: self, didShowView: view)
            view.view.layer.transform = CATransform3DIdentity
            activeViews[index] = view
        }
    }
    
    fileprivate func clearAllViews () {
        for (_ , value) in activeViews {
            dataSource?.scrollView?(scrollView: self, willHideView: value)
            value.view.removeFromSuperview()
            dataSource?.scrollView?(scrollView: self, didHideView: value)
        }
        activeViews = [:]
        dirtyViews = []
        viewsCount = nil
        itemSize = CGSize.zero
        resizeContent()
    }

    fileprivate func resizeContent() {
        if let viewsCount = viewsCount {
            let frameI = UIEdgeInsetsInsetRect(frame, contentInset)
            let width = frameI.width
            let height = frameI.height
            let x:CGFloat = CGFloat(viewsCount) * width
            contentSize = CGSize(width: x, height: height)
            itemSize = frameI.size
        } else {
            contentSize = CGSize.zero
            itemSize = CGSize.zero
        }
        contentOffset = CGPoint.zero
    }
}



extension Array {
    
    func substract <T: Equatable> (_ values: [T]...) -> [T] {
        var result = [T]()
        elements: for e in self {
            if let element = e as? T {
                for value in values {
                    //if our internal element is present in substract array
                    //exclude it from result
                    if value.contains(element) {
                        continue elements
                    }
                }
                
                //  element it's only in self, so return it
                result.append(element)
            }
        }
        return result
    }
    
}
