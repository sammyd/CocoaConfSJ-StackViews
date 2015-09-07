/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class AboutViewController: UIViewController {
  
  
  @IBOutlet weak var contentStackView: UIStackView!
  private var copyrightStackView: UIStackView?
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
}


extension AboutViewController {
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    let image = imageForAspectRatio(size.width / size.height)
    
    coordinator.animateAlongsideTransition({
      context in
      // Create a transition and match the context's duration
      let transition = CATransition()
      transition.duration = context.transitionDuration()
      
      // Make it fade
      transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
      transition.type = kCATransitionFade
      self.backgroundImageView.layer.addAnimation(transition, forKey: "Fade")
      
      // Set the new image
      self.backgroundImageView.image = image
      }, completion: nil)
  }
  
  
  private func configureView() {
    let aspectRatio = view.bounds.size.width / view.bounds.size.height
    self.backgroundImageView.image = imageForAspectRatio(aspectRatio)
  }
  
  private func imageForAspectRatio(aspectRatio : CGFloat) -> UIImage? {
    return UIImage(named: aspectRatio > 1 ? "pancake3" : "placeholder")
  }
}



extension AboutViewController {
  @IBAction func handleCopyrightButtonTapped(sender: AnyObject) {
    if copyrightStackView != .None {
      UIView.animateWithDuration(0.8, animations: {
        self.copyrightStackView?.hidden = true
        }, completion: { _ in
          self.copyrightStackView?.removeFromSuperview()
          self.copyrightStackView = nil
      })
    } else {
      copyrightStackView = createCopyrightStackView()
      copyrightStackView?.hidden = true
      contentStackView.addArrangedSubview(copyrightStackView!)
      UIView.animateWithDuration(0.8) {
        self.copyrightStackView?.hidden = false
      }
    }
  }
  
  private func createCopyrightStackView() -> UIStackView? {
    let imageView = UIImageView(image: UIImage(named: "rw_logo"))
    imageView.contentMode = .ScaleAspectFit
    
    let label = UILabel()
    label.text = "© Razeware 2015"
    
    let stackView = UIStackView(arrangedSubviews: [imageView, label])
    stackView.axis = .Horizontal
    stackView.alignment = .Center
    stackView.distribution = .FillEqually
    
    return stackView
  }

}


