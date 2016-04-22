//
//  PageController.swift
//  InteractiveStory
//
//  Created by Ethan Neff on 4/22/16.
//  Copyright © 2016 Ethan Neff. All rights reserved.
//

import UIKit
import AudioToolbox

class PageController: UIViewController {
  // MARK: properties
  var sound: SystemSoundID = 0
  var page: Page? // passed from viewcontroller
  let artwork = UIImageView()
  let storyLabel = UILabel()
  let firstChoiceButton = UIButton(type: .System)
  let secondChoiceButton = UIButton(type: .System)
  
  // MARK: init
  init(page: Page) {
    self.page = page
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // MARK: load
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .whiteColor()
    edgesForExtendedLayout = .None
    
    if let page = page {
      artwork.image = page.story.artwork
      
      let attributedString = NSMutableAttributedString(string: page.story.text)
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineSpacing = 5
      attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
      
      storyLabel.attributedText = attributedString
      storyLabel.font = UIFont.systemFontOfSize(14)
      
      
      if let firstChoice = page.firstChoice {
        firstChoiceButton.setTitle(firstChoice.title, forState: .Normal)
        firstChoiceButton.addTarget(self, action: #selector(loadFirstChoice), forControlEvents: .TouchUpInside)
      } else {
        firstChoiceButton.setTitle("Play Again", forState: .Normal)
        firstChoiceButton.addTarget(self, action: #selector(playAgain), forControlEvents: .TouchUpInside)
      }
      
      if let secondChoice = page.secondChoice {
        secondChoiceButton.setTitle(secondChoice.title, forState: .Normal)
        secondChoiceButton.addTarget(self, action: #selector(loadSecondChoice), forControlEvents: .TouchUpInside)
      }
    }
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.addSubview(artwork)
    artwork.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activateConstraints([
      artwork.topAnchor.constraintEqualToAnchor(view.topAnchor),
      artwork.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
      artwork.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
      artwork.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
      ])
    
    view.addSubview(storyLabel)
    storyLabel.numberOfLines = 0
    storyLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activateConstraints([
      storyLabel.topAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: -48),
      storyLabel.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 16),
      storyLabel.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -16),
      ])
    
    view.addSubview(firstChoiceButton)
    firstChoiceButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activateConstraints([
      firstChoiceButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      firstChoiceButton.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -80.0)
      ])
    
    view.addSubview(secondChoiceButton)
    secondChoiceButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activateConstraints([
      secondChoiceButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      secondChoiceButton.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -32)
      ])
  }
  
  func loadFirstChoice() {
    if let page = page, firstChoice = page.firstChoice {
      let nextPage = firstChoice.page
      let pageController = PageController(page: nextPage)
      pageController.edgesForExtendedLayout = .None
      playSound(nextPage.story.soundEffectURL)
      navigationController?.pushViewController(pageController, animated: true)
    }
  }
  
  func loadSecondChoice() {
    if let page = page, secondChoice = page.secondChoice {
      let nextPage = secondChoice.page
      let pageController = PageController(page: nextPage)
      pageController.edgesForExtendedLayout = .None
      playSound(nextPage.story.soundEffectURL)
      navigationController?.pushViewController(pageController, animated: true)
    }
  }
  
  func playAgain() {
    navigationController?.popToRootViewControllerAnimated(true)
  }
  
  func playSound(url: NSURL) {
    // audio servies are C functions
    // copy the bits of the url to the SystemSoundID in memory
    AudioServicesCreateSystemSoundID(url, &sound)
    AudioServicesPlayAlertSound(sound)
  }
}
