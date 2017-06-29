//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Rola Kitaphanich on 2016-07-24.
//  Copyright © 2016 Rola Kitaphanich. All rights reserved.
//

import UIKit

class MemeDetailViewController :UIViewController {
    
    @IBOutlet weak var memeImage: UIImageView!
    
    var meme: Meme!
    
    
    override func viewWillAppear(animated: Bool){
        
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = true
        
        memeImage.image = meme.memedImage
    
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
}
