//
//  ViewController.swift
//  InteractiveStory
//
//  Created by Ethan Neff on 4/22/16.
//  Copyright © 2016 Ethan Neff. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController, UITextFieldDelegate {
  
  enum Error: ErrorType {
    case NoName
  }
  
  var sound: SystemSoundID = 0
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
  
  // load
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // UITextFieldDelegate delegate
    nameTextField.delegate = self
    // add observe to function
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
  }
  
  // will show
  func keyboardWillShow(notification: NSNotification) {
    animateTextField(bottomConstraint: self.keyboardHeight(notification) + 10)
  }
  
  // will hide
  func keyboardWillHide(notification: NSNotification) {
    animateTextField(bottomConstraint: 40)
  }
  
  func animateTextField(bottomConstraint bottomConstraint: CGFloat) {
    UIView.animateWithDuration(0.8) {
      self.textFieldBottomConstraint.constant = bottomConstraint
      self.view.layoutIfNeeded()
    }
  }
  
  func keyboardHeight(notification: NSNotification) -> CGFloat {
    if let userInfoDict = notification.userInfo, keyboardFrameValue = userInfoDict[UIKeyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardFrame = keyboardFrameValue.CGRectValue()
      return keyboardFrame.size.height
    }
    return 0
  }
  
  // enter
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  // only need to remove if below iOS9
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }
  
  
  // transition page
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "startAdventure" {
      
      do {
        if let name = nameTextField?.text {
          if name == "" {
            throw Error.NoName
          }
          if let pageController = segue.destinationViewController as? PageController {
            let page = Adventure.story(name)
            playSound(page.story.soundEffectURL)
            
            pageController.page = page
          }
        }
      } catch Error.NoName {
        let alertController = UIAlertController(title: "Name not provided", message: "Provide a name to start your story", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
      } catch let error {
        fatalError("\(error)")
      }
    }
  }
  
  func playSound(url:NSURL) {
    AudioServicesCreateSystemSoundID(url, &sound)
    AudioServicesPlayAlertSound(sound)
  }
}

