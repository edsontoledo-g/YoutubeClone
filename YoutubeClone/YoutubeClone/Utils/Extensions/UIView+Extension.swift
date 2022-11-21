//
//  UIView+Extension.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 08/11/22.
//

import UIKit

extension UIView {
    func animateBottomSheet(show: Bool, onComplete: (() -> Void)? = nil) {
        if show {
            frame.origin.y += frame.height
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 4.0, options: .curveEaseIn) {
                self.frame.origin.y -= self.frame.height
                self.animateOverlay()
                
                if let onComplete = onComplete {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        onComplete()
                    }
                }
            }
            
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 4.0, options: .curveEaseIn) {
            self.frame.origin.y += self.frame.height
            self.animateOverlay()
            
            if let onComplete = onComplete {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    onComplete()
                }
            }
        }
    }
    
    func animateOverlay(delay: TimeInterval = 0.0) {
        self.alpha = 0.0
        UIView.animate(withDuration: 0.5, delay: delay, options: .curveEaseIn) {
            self.alpha = 1.0
        }
    }
}
