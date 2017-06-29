//
//  BoardCollectionViewCell.swift
//  WhackAFrog
//
//  Created by Shay Manzaly on 5/16/17.
//  Copyright © 2017 Shay Manzaly. All rights reserved.
//

import UIKit

class BoardCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var cellPic: UIImageView!
    
    func convertImageToBW(image:UIImage) -> UIImage {
        
        let filter = CIFilter(name: "CIPhotoEffectMono")
        
        // convert UIImage to CIImage and set as input
        
        let ciInput = CIImage(image: image)
        filter?.setValue(ciInput, forKey: "inputImage")
        
        // get output CIImage, render as CGImage first to retain proper UIImage scale
        
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        
        return UIImage(cgImage: cgImage!)
    }
    

    func rotate() {
        let duration = 2.0
        let delay = 0.0
        let options = UIViewKeyframeAnimationOptions.calculationModePaced
        let fullRotation = CGFloat(Double.pi * 2)
    UIView.animateKeyframes(withDuration: duration, delay: delay, options: options, animations: {
    
    // note that we've set relativeStartTime and relativeDuration to zero.
    // Because we're using `CalculationModePaced` these values are ignored
    // and iOS figures out values that are needed to create a smooth constant transition
    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0, animations: {
    self.cellPic.transform = CGAffineTransform(rotationAngle: 1/3 * fullRotation)
    })
    
    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0, animations: {
    self.cellPic.transform = CGAffineTransform(rotationAngle: 2/3 * fullRotation)
    })
    
    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0, animations: {
    self.cellPic.transform = CGAffineTransform(rotationAngle: 3/3 * fullRotation)
    })
    
    }, completion: nil)
}
    



}
