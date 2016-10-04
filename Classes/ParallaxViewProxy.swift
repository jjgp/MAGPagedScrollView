//
//  ParallaxViewProxy.swift
//  MAGPagedScrollViewDemo
//
//  Created by Ievgen Rudenko on 26/08/15.
//  Copyright (c) 2015 MadAppGang. All rights reserved.
//

import UIKit

open class ParallaxViewProxy: UIView, PagedScrollViewParallaxDelegate {


    @IBOutlet open weak var parallaxController:PagedScrollViewParallaxDelegate? = nil
    
    open func parallaxProgressChanged(_ progress:Int) {
        if let pc = parallaxController {
            pc.parallaxProgressChanged(progress)
        }
    }
}
