//
//  PokeCell.swift
//  Pokemon
//
//  Created by Santhosh Krishna on 24/08/16.
//  Copyright © 2016 Santhosh Krishna. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg:UIImageView!
    @IBOutlet weak var namLbl:UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    
    func configureCell(pokemon: Pokemon){
        self.pokemon = pokemon
        namLbl.text = self.pokemon.name.capitalizedString
        thumbImg.image = UIImage(named:"\(self.pokemon.pokemonId)")
    }
    
}
