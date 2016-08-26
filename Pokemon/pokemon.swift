//
//  pokemon.swift
//  Pokemon
//
//  Created by Santhosh Krishna on 24/08/16.
//  Copyright © 2016 Santhosh Krishna. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokemonId: Int!
    private var _description: String!
    private var _type:String!
    private var _defense:String!
    private var _hight:String!
    private var _weight:String!
    private var _baseAttack:String!
    private var _nextEvolutionTxt:String!
    private var _pokemonURL:String!
    private var _nextEvolutionId:String!
    private var _nextEvolutionLvl:String!
    
    var name : String{
        return _name
    }
    
    var pokemonId: Int {
        return _pokemonId
    }
    var description: String{
        if _description == nil {
            _description = ""
        }
        return _description
    }
    var type: String{
        if _type == nil{
            _type = ""
        }
        return _type
    }
    var defense:String{
        if _defense == nil{
            _defense = ""
        }
        return _defense
    }
    var height:String{
        if _hight == nil{
            _hight = ""
        }
        return _hight
    }
    var weight:String{
        if _weight == nil {
            _weight = ""
        }
        
        return _weight
    }
    var baseAttack:String{
        if _baseAttack == nil {
            _baseAttack = ""
        }
        return _baseAttack
    }
    var nextEvolutionTxt:String{
        if _nextEvolutionTxt == nil{
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    var nextEvolutionLvl:String{
        if _nextEvolutionLvl == nil{
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    var nextEvolutionId:String{
        if _nextEvolutionId == nil{
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    init(name:String,pokemonId:Int){
        self._name = name
        self._pokemonId = pokemonId
        _pokemonURL = "\(URL_BASE)\(URL_POKE)\(self._pokemonId)/"
    }
    
    func downloadPokemonDetails(completed:DownloadComplete ){
        
        let url = NSURL(string: _pokemonURL)!
      
        Alamofire.request(.GET, url).responseJSON { response  in
            let result = response.result
            print(result.value.debugDescription)
            
            if let dict = result.value as? Dictionary<String, AnyObject>{
                if let weight = dict["weight"] as? String{
                    self._weight = weight
                }
                if let height = dict["height"] as? String{
                self._hight = height
            }
                if let defense = dict["defense"] as? Int{
                    self._defense = "\(defense)"
                }
                if let attack = dict["attack"] as? Int{
                    self._baseAttack = "\(attack)"
                }
               
                print(self._hight)
                print(self._weight)
                print(self._baseAttack)
                
                
                if let types = dict["types"] as? [Dictionary<String,String>] where types.count > 0{
                    if let name = types[0]["name"]{
                        self._type = name.capitalizedString
                    }
                    if types.count > 1 {
                        for x in 1 ..< types.count{
                            if let name = types[x]["name"]{
                            self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                    
                }else{
                    self._type = ""
                }
              print(self._type)
                if let discArr = dict["descriptions"] as? [Dictionary<String,String>]   where discArr.count > 0{
                    if let url = discArr[0]["resource_uri"]{
                      let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        print(nsurl)
                        
                        Alamofire.request(.GET, nsurl).responseJSON { response  in
                            let result = response.result
                            print(result.value.debugDescription)
                        
                        if let descDict = result.value as? Dictionary<String,AnyObject> {
                            if let description = descDict["description"]  as? String {
                                self._description = description
                                print(self._description)
                            }
                        }
                            
                        completed()
                       
                      }
                    }
                }else{
                    self._description = ""
                }
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>] where evolutions.count > 0 {
                    print(evolutions.count)
                    if let to = evolutions[0]["to"] as? String{
                        //Can't Support mega pokemon
                        if to.rangeOfString("mega") == nil {
                            if let url = evolutions[0]["resource_uri"] as? String {
                                let newStr = url.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                print(newStr)
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                self._nextEvolutionId = num
                                self._nextEvolutionTxt = to
                                if let level = evolutions[0]["level"] as? Int{
                                    self._nextEvolutionLvl = "\(level)"
                                    
                                }
                                print(self._nextEvolutionLvl)
                                print(self._nextEvolutionId)
                                print(self._nextEvolutionTxt)
 
                            
                            }
                        }
                    }
                }
            }
            
        }
            
            
    }
}
        

