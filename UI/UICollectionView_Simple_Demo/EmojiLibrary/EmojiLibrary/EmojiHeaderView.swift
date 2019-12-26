//
//  EmojiHeaderView.swift
//  EmojiLibrary
//
//  Created by 王振 on 2019/12/26.
//  Copyright © 2019 Ray Wenderlich. All rights reserved.
//

import UIKit

class EmojiHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = String(describing: EmojiHeaderView.self)
    
    @IBOutlet weak var textLabel: UILabel!
    
}
