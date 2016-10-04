//
//  PagedScrollViewContainerViewController.swift
//  MAGPagedScrollViewDemo
//
//  Created by Ievgen Rudenko on 28/08/15.
//  Copyright (c) 2015 MadAppGang. All rights reserved.
//

import UIKit


/// Base class for implementing ViewController as container
/// If you want owner (ViewController) of PagedScrollView to be a container
/// just make your view controller subclass of PagedScrollViewContainerViewController

open class PagedScrollViewContainerViewController: UIViewController, PagedReusableScrollViewDataSource {

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - PagedReusableScrollViewDataSource
    open func scrollView(_ scrollView: PagedReusableScrollView, viewIndex index: Int) -> ViewProvider {
        assertionFailure("have to be implemented in subclass")
        //just have to return something
        return self
    }
    
    open func numberOfViews(forScrollView scrollView: PagedReusableScrollView) -> Int {
        assertionFailure("have to be implemented in subclass")
        return 0
    }
    
    open func scrollView(scrollView: PagedReusableScrollView, willShowView view:ViewProvider) {
        if let vc = view as? UIViewController {
            self.addChildViewController(vc)
        }
    }
    
    open func scrollView(scrollView: PagedReusableScrollView, willHideView view:ViewProvider) {
        if let vc = view as? UIViewController {
            vc.willMove(toParentViewController: nil)
        }
    }
    
    open func scrollView(scrollView: PagedReusableScrollView, didShowView view:ViewProvider) {
        if let vc = view as? UIViewController {
            vc.didMove(toParentViewController: self)
        }
    }
    
    open func scrollView(scrollView: PagedReusableScrollView, didHideView view:ViewProvider) {
        if let vc = view as? UIViewController {
            vc.removeFromParentViewController()
        }
    }

    

}
