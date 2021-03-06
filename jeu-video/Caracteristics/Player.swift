//
//  Player.swift
//  jeu-video
//
//  Created by Gustav Berloty on 02/01/2019.
//  Copyright © 2019 Gustav Berloty. All rights reserved.
//

import Foundation

    // This is class is used a little bit in StartTheGame.swift and mainly in PlayTheGame.swift

class Player { // This class represents a game's real player.
    
    // MARK: PROPERTY LIST
    
    private var pseudo : String     // The player's pseudo used for the game.
    private var team : [Character]  // The player's team used to fight others player's characters.
    
    // MARK: GETTER LIST
    
    func getPseudo() -> String {  // getter
        return pseudo
    }
    
    func getTeam() -> [Character] {  // getter
        return team
    }
    
    private func getCharactersAlive () -> [Character] {        // Return the characters alive from the player's team.
        var teamAlive : [Character] = []    // The team that will be returned
        for char in team {
            if (char.getCurrentLifePoint() > 0) {
                teamAlive.append(char)
            }
        }
        return teamAlive
    }
    
    // MARK: SETTER LIST
    
    func addCharacterToTheTeam(this char : Character) {  // Function to add one character to the player's team
         team.append(char)
    }
    
    // MARK: CONSTRUCTOR

    init(name:String, teamPlayer : [Character]) {
        pseudo = name
        team = teamPlayer
    }
    
    // MARK: ACTION METHODS
    
    func isAllDead () -> Bool {     // Return if all the player's team characters are dead or not.
        for char in team {
            if (char.getCurrentLifePoint() > 0) {
                return false
            }
        }
        return true
    }
    
    func chooseOneCharacter(onlyAliveCharacter : Bool) -> Character? {      // The user choose one character among the player's team.
        var teamChosen : [Character]        // The team given: only the alive characters or all the team ?
        if (onlyAliveCharacter == true) {
            teamChosen = getCharactersAlive()
        }
        else {
            teamChosen = team
        }
        describeTeam(teamGiven: teamChosen)
        var indexer : Int?      // Used to get the user choice about the character he wants.
        indexer =  Int(readLine()!)
        while indexer == nil || indexer! > teamChosen.count || indexer! < 1 {
            print("\t\tVeuillez entrer un chiffre correspondant à un des personnages ci-dessus: ".red())
            indexer =  Int(readLine()!)
        }
        print("----------------> \(teamChosen[indexer! - 1].getName()) a été choisi.".foregroundColor(.orange1))
        return teamChosen[indexer! - 1]
    }
    
    // MARK: OTHER
    
    // This function is used to describe a set of characters often the player's team. It's useful for select a character when it's our time to play.
    private func describeTeam(teamGiven : [Character]) {
        var index : Int = 1     // The index of the character used to be able to select it.
        for i in teamGiven {
            print("\t\t- Entrez '\(index)' pour choisir le personnage suivant: ")
            i.describe()
            if (i.getWeaponUsedByDefault() != nil) {
                print("\t\t\t\t• Arme(s):")
                i.getWeaponUsedByDefault()!.describe()
            }
            else { print("\t\t\t\t• Sans armes") }
            if (i.getPowerUsedByDefault() != nil) {
                print("\t\t\t\t• Pouvoir(s):") // display any power information
                i.getPowerUsedByDefault()!.describe()
            }
            else { print("\t\t\t\t• Sans pouvoirs") }
            index += 1
        }
    }
    
}
