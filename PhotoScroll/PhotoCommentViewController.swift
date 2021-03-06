/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.    Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class PhotoCommentViewController: UIViewController {
  //1
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var nameTextField: UITextField!
  
  //2
  var photoName: String?
  var keyboadVisible = false
  var previousContentOffset:CGPoint?
  var photoIndex: Int!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //3
    if let photoName = photoName {
      self.imageView.image = UIImage(named: photoName)
    }
    
    // Do any additional setup after loading the view.
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(_:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil)
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(_:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil)
  }
  
  //1
  private func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
    guard
      let userInfo = notification.userInfo,
      let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
        as? NSValue
      else {
        return
    }
    
    keyboadVisible = show
    let adjustmentHeight = (keyboardFrame.cgRectValue.height + 20) * (show ? 1 : -1)
    print("adjustmentHeight = \(adjustmentHeight)")
    
    if !show, let contentOffset = previousContentOffset {
      scrollView.setContentOffset(contentOffset, animated: true)
    }
    
    scrollView.contentInset.bottom += adjustmentHeight
    scrollView.verticalScrollIndicatorInsets.bottom += adjustmentHeight
  }
  
  //2
  @objc func keyboardWillShow(_ notification: Notification) {
    print("show")
    if !keyboadVisible {
      previousContentOffset = scrollView.contentOffset
      adjustInsetForKeyboardShow(true, notification: notification)
    }
  }
  
  @objc func keyboardWillHide(_ notification: Notification) {
    print("hide")
    
    if keyboadVisible {
      adjustInsetForKeyboardShow(false, notification: notification)
    }
  }
  
  @IBAction func hideKeyboard(_ sender: AnyObject) {
    nameTextField.endEditing(true)
  }
  //1
  @IBAction func openZoomingController(_ sender: AnyObject) {
    self.performSegue(withIdentifier: "zooming", sender: nil)
  }
  
  //2
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let id = segue.identifier,
      let viewController = segue.destination as? ZoomedPhotoViewController,
      id == "zooming" {
      viewController.photoName = photoName
    }
  }

}
