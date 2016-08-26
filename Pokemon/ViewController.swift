//
//  ViewController.swift
//  Pokemon
//
//  Created by Santhosh Krishna on 24/08/16.
//  Copyright © 2016 Santhosh Krishna. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UISearchBarDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var pokemon = [Pokemon]()
    var filterdPokemon = [Pokemon]()
    var musicPlayer:AVAudioPlayer!
    var inSearchMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
                parsePokemonCSV()
        initAudio()
        
    }
   

    
    func initAudio() {
        
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")
        do{ musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        }catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    func parsePokemonCSV(){
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            for row in rows{
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokemonId: pokeId)
                pokemon.append(poke)
            }
            
        }catch let err as NSError{
            print(err.debugDescription)
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell{
            let poke:Pokemon!
            if inSearchMode{
                poke = filterdPokemon[indexPath.row]
            }else{
                poke = pokemon[indexPath.row]
            }
            cell.configureCell(poke)
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let poke:Pokemon!
        if inSearchMode{
            poke = filterdPokemon[indexPath.row]
            
        }else{
            poke = pokemon[indexPath.row]
        }
       performSegueWithIdentifier("PokemonDetailVC", sender: poke)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode{
            return filterdPokemon.count
        }
        
        return pokemon.count
        
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }

   @IBAction func musicButtonPressed(sender: UIButton!) {
    
       if musicPlayer.playing{
            musicPlayer.stop()
            sender.alpha = 0.2
        }else{
        
        musicPlayer.play()
           sender.alpha = 1.0
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
              inSearchMode = false
              view.endEditing(true)
              collectionView.reloadData()
        }else{
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            filterdPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil})
            collectionView.reloadData()
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokemonDetailVC"{
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC {
                if let poke = sender as? Pokemon{
                    detailsVC.pokemon = poke
                }
                
            }
       }
   }
   

}

