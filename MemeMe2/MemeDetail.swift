//
//  MemeDetail.swift
//  MemeMe2
//
//  Created by Ashrakat Sherif on 06/03/2022.
//

import UIKit

class MemeDetail: UIViewController {
    var meme: Meme!
    
    @IBOutlet weak var memedImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memedImage.image = meme.memedImage
    }
    
}
