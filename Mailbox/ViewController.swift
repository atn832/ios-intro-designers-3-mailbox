//
//  ViewController.swift
//  Mailbox
//
//  Created by Anh Tuan on 9/16/14.
//  Copyright (c) 2014 Anh Tuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mail: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onMessagePan(panGestureRecognizer: UIPanGestureRecognizer) {
        let maxY = view.frame.height
        var point = panGestureRecognizer.locationInView(view)
        var velocity = panGestureRecognizer.velocityInView(view)
        var translation = panGestureRecognizer.translationInView(view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            println("Gesture began at: \(point)")
            originalTrayY = tray.frame.origin.y
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            println("Gesture changed at: \(point)")
            tray.frame.origin.y = originalTrayY + translation.y
            // frictional drag
            if (tray.frame.maxY < maxY) {
                tray.frame.origin.y = maxY - tray.frame.height + (tray.frame.maxY - maxY) / CGFloat(10.0)
            }
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            println("Gesture ended at: \(point)")
            // decide to go up and down
            UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                if (velocity.y > 0) {
                    // collapse
                    self.tray.frame.origin.y = CGFloat(520.0)
                    self.arrow.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                } else {
                    // expand
                    self.tray.frame.origin.y = maxY - self.tray.frame.height
                    self.arrow.transform = CGAffineTransformMakeRotation(CGFloat(0.0))
                }
                }, completion: { (flag: Bool) -> Void in
            })
        }
    }
}

