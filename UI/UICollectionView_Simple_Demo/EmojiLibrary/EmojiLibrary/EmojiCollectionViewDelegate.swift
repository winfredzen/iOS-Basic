//
//  EmojiCollectionViewDelegate.swift
//  EmojiLibrary
//
//  Created by 王振 on 2019/12/26.
//  Copyright © 2019 Ray Wenderlich. All rights reserved.
//

import UIKit

class EmojiCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    
    let numberOfItemsPerRow: CGFloat
    let interItemSpacing: CGFloat
    
    weak var viewContorller: UIViewController?
    
    init(numberOfItemsPerRow: CGFloat, interItemSpacing: CGFloat) {
        self.numberOfItemsPerRow = numberOfItemsPerRow
        self.interItemSpacing = interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let maxWidth = UIScreen.main.bounds.width
        let totalSpacing = interItemSpacing * numberOfItemsPerRow
        
        let itemWidth = (maxWidth - totalSpacing) / numberOfItemsPerRow
        
        return CGSize(width: itemWidth, height: itemWidth)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return interItemSpacing
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 0 {
            
            return UIEdgeInsets(top: 0, left: 0, bottom: interItemSpacing / 2, right: 0)
            
        } else {
            
            return UIEdgeInsets(top: interItemSpacing / 2, left: 0, bottom: interItemSpacing / 2, right: 0)
            
        }
        
    }
    
    
    // MARK:  - UICollectionViewDelegate -
     
     
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        
//        guard let viewController = viewContorller else {
//            return
//        }
//
//        if !viewController.isEditing {
//
//            viewController.performSegue(withIdentifier: "showEmojiDetail", sender: nil)
//
//        }
        
        
//        guard let emojiCell = collectionView.cellForItem(at: indexPath) as? EmojiCell else {
//            return
//        }
//        
//        emojiCell.contentView.backgroundColor = UIColor.systemRed.withAlphaComponent(0.5)
        
        
    }
    
    
    
    
}
