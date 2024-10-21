//
//  CharacterCollectionViewCell.swift
//  ChararactersApp
//
//  Created by Dina Mansour  on 16/10/2024.
//

import UIKit
import SwiftUI

class CharacterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var species: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var elfimage: UIImageView!
    
   

    
    override init(frame: CGRect) {
          super.init(frame: frame)
            commonInit()
        
      }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }
        
        override func awakeFromNib() {
            commonInit()
        }
        
        private func commonInit() {
           
        
        }
    
 
  
}
