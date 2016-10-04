//
//  ParralaxCardViewController.swift
//  MAGPagedScrollViewDemo
//
//  Created by Ievgen Rudenko on 26/08/15.
//  Copyright (c) 2015 MadAppGang. All rights reserved.
//

import UIKit

class ParralaxCardViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var detailsCentralConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageCentralConstraint: NSLayoutConstraint!
    
    var imageName: String? = nil {
        didSet {
            if let imageName = imageName {
                self.imageView?.image = UIImage(named: imageName)
            } else {
                self.imageView?.image = nil
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageName = imageName {
            self.imageView?.image = UIImage(named: imageName)
        } else {
            self.imageView?.image = nil
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func loadView() {
        Bundle.main.loadNibNamed("ParralaxCardViewController", owner: self, options: nil)
        if let view = view as? ParallaxViewProxy {
            view.parallaxController = self
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("\(self) viewWillTransitionToSize: \(size)  with coordinator: \(coordinator)")
    }

}


extension ParralaxCardViewController: PagedScrollViewParallaxDelegate {
    
    func parallaxProgressChanged(_ progress:Int) {
        self.imageView.bounds = CGRect(x: CGFloat(progress), y: 0, width: imageView.bounds.size.width, height: imageView.bounds.size.height)
        detailsCentralConstraint.constant = CGFloat(-progress*4)
        imageCentralConstraint.constant = CGFloat(-progress)
        titleTopConstraint.constant = CGFloat(abs(progress))
    }

}
