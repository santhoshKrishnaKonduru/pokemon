//
//  PokemonDetailVC.swift
//  Pokemon
//
//  Created by Santhosh Krishna on 24/08/16.
//  Copyright © 2016 Santhosh Krishna. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    @IBOutlet weak var pokeLabel: UILabel!
    var pokemon:Pokemon!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var discriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenceLbl: UILabel!
    @IBOutlet weak var hightLbl: UILabel!
    @IBOutlet weak var pokemonIdLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var evolutionLbl: UILabel!
    
    @IBOutlet weak var currentEvlImg: UIImageView!
    @IBOutlet weak var nexEvlImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pokeLabel.text = pokemon.name.capitalizedString
        let img = UIImage(named: "\(pokemon.pokemonId)")
        mainImg.image = img
        currentEvlImg.image = img
        
        pokemon.downloadPokemonDetails { () -> () in
           self.updateUI()
        }
        
    }

    func updateUI(){
        discriptionLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        defenceLbl.text = pokemon.defense
        hightLbl.text = pokemon.height
        pokemonIdLbl.text = "\(pokemon.pokemonId)"
        weightLbl.text = pokemon.weight
        baseAttackLbl.text = pokemon.baseAttack
       
        if pokemon.nextEvolutionId == ""{
          evolutionLbl.text = "There is no evolution"
            nexEvlImg.hidden = true
        }else{
            nexEvlImg.hidden = false
            nexEvlImg.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution :\(pokemon.nextEvolutionTxt)"
            if pokemon.nextEvolutionLvl != "" {
                str += "-LVL\(pokemon.nextEvolutionLvl)"
                evolutionLbl.text = str 
            }
        }
        
        

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backButtonPressed(sender: AnyObject) {
      dismissViewControllerAnimated(true, completion: nil)
    }

}
