//
//  ViewController.swift
//  InteractiveStory
//
//  Created by Ethan Neff on 4/22/16.
//  Copyright © 2016 Ethan Neff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    let story = Page(story: .TouchDown)
    story.firstChoice = (title: "some Title", page: Page(story: .Droid))
    story.firstChoice = (title: "some Title", page: Page(story: .Droid))
  }

}

