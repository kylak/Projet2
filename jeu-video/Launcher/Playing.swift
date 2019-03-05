//
//  Playing.swift
//  jeu-video
//
//  Created by Gustav Berloty on 28/01/2019.
//  Copyright © 2019 Gustav Berloty. All rights reserved.
//

import Foundation

class Playing {
    
    var gameInformations : Game
    var winner : Player?
    
    init (game : Game) {
        gameInformations = game
        winner = nil
    }
    
    func start() {
        // Pour l'instant, l'ordre du jeu se fait selon les indices du tableau de players
        var indexOfThePlayingPlayer : Int = 0 // I'd like to declare this variable in the while because I won't use it anymore after the while, how can I do ?
        repeat {
            turn(of: nextPlayerIndex(after: indexOfThePlayingPlayer)) // The player associated has to play ! It's his turn.
            indexOfThePlayingPlayer = nextPlayerIndex(after: indexOfThePlayingPlayer)
        } while(!gameEnded())
        winner = getTheWinner()
        print("\n\(winner!.pseudo) a remporté la partie !\n")
    }
    
    func turn(of currentPlayer : Int) {
        let thePlayingPlayer : Player = gameInformations.players[currentPlayer]
        print("---- C'est au tour de \(thePlayingPlayer.pseudo) ----")
        let theNextPlayingPlayer : Player = gameInformations.players[nextPlayerIndex(after: currentPlayer)]
        print("\(thePlayingPlayer.pseudo), choisisez un personnage de votre équipe pour guérir un de ses confrères ou alors pour combattre un personnage adverse: ")
        let theFirstChosenCharacter : Character = thePlayingPlayer.chooseOneCharacter(onlyAliveCharacter: true)!
        var theSecondChosenCharacter : Character
        
        if(thisTimeIsGood()){
            aTreasureAppeared(for: theFirstChosenCharacter)
        }
        
        if (String(describing: type(of: theFirstChosenCharacter)) == "Mage") {
            print("\(thePlayingPlayer.pseudo), choisisez un personnage de votre équipe que le mage guérira: ")
            theSecondChosenCharacter = thePlayingPlayer.chooseOneCharacter(onlyAliveCharacter: true)!
        }
        else {
            print("\(thePlayingPlayer.pseudo), choisisez à présent un personnage de l'équipe de \(theNextPlayingPlayer.pseudo) à combattre: ")
            theSecondChosenCharacter = theNextPlayingPlayer.chooseOneCharacter(onlyAliveCharacter: true)!
        }
        theFirstChosenCharacter.act(to: theSecondChosenCharacter)
    }
    
    func nextPlayerIndex (after this : Int) -> Int {
        if(this == gameInformations.players.count - 1) {
            return 0
        }
        return this + 1
    }
    
    func gameEnded () -> Bool {
        var NbrOfUnplayablePlayer : Int = 0
        for thePlayerTeam in gameInformations.players {
            if (thePlayerTeam.isAllDead()) {
                 NbrOfUnplayablePlayer += 1
            }
        }
        if (NbrOfUnplayablePlayer == gameInformations.players.count - 1) {
            return true
        }
        return false
    }
    
    func getTheWinner () -> Player? {
        if (gameEnded()) {
            for player in gameInformations.players {
                if (!player.isAllDead()) {
                   return player
                }
            }
        }
        return nil
    }
    
    func aTreasureAppeared (for character : Character) {
        print("\n ** Un coffre fort est apparu ! ** \nPour ouvrir ce coffre fort, entrez 'o': ")
        var newWeapon : Weapon?, newPower : Power?
        let isNewItemWeapon : Bool = generateNewItem()
        if (isNewItemWeapon == true) {
            newWeapon = Weapon.generateNewOne()
        }
        else {
            newPower = Power.generateNewOne()
        }
        openTheTreasure()
        let toContinue = canGiftBeCarry(byThis: character, dependingOf: isNewItemWeapon, itemPossibility1: newWeapon, itemPossibility2: newPower)
        if (toContinue) {
            getTheGift(dependingOf: isNewItemWeapon, itemPossibility1: newWeapon, itemPossibility2: newPower, forThis: character)
        }
    }
    
    func thisTimeIsGood() -> Bool {
        // the use of thisTimeIsGood() is only to rename generateNewItem() to use it in the turn() method.
        return !generateNewItem() // ! i.e it's return more often a false value so get a treasure is less frequent that to not get one.
    }
    
    func generateNewItem () -> Bool { // True for weapon & False for power
        let number = Int.random(in: 0 ..< 4) // either 0, 1, 2 or 3
        if (number == 2) { return false } // 2 means it's a power
        return true
    }
    
    func openTheTreasure() {
        var choice : String
        repeat {
            choice =  readLine()!
            if choice == "o" {
                
            }
            else {
                print("Caractère non reconnu, il vous faut ouvrir ce coffre.\nPour ouvrir ce coffre fort, entrez 'o': ")
            }
        } while (choice != "o")
    }
    
    func itemDescription(isAWeapon : Bool, itemPossibility1: Weapon?, itemPossibility2 : Power?) {
        if(isAWeapon) {
            print("L'item provenant du coffre est l'arme suivante: ")
            print("\t› " + String(describing: type(of: itemPossibility1!)) + ":")
            print("\t\t- Dégat: \(itemPossibility1!.damage)")
        }
        else {
            print("L'item provenant du coffre est le pouvoir suivant: ")
            print("\t› \(itemPossibility2!.name):")
            if(itemPossibility2!.giveLifePoint != nil) {
                print("\t\t- Ajoute \(itemPossibility2!.giveLifePoint!) points de vie.")
            }
            else { print("\t\t- N'ajoute pas de point de vie.") }
            if(itemPossibility2!.giveDefensePoint != nil) {
                print("\t\t- Ajoute \(itemPossibility2!.giveLifePoint!) points de défense.")
            }
            else { print("\t\t- N'ajoute pas de point de défense.") }

        }
    }
    
    func canGiftBeCarry(byThis character : Character,  dependingOf itemIsWeapon: Bool, itemPossibility1: Weapon?, itemPossibility2 : Power?) -> Bool {
        var canGiftBeCarry : Bool = false
        if (itemIsWeapon && String(describing: type(of: character)) != "Mage" && itemPossibility1 != nil) {
            canGiftBeCarry = true
        }
        else  if ( !itemIsWeapon && String(describing: type(of: character)) == "Mage") {
            canGiftBeCarry = true
        }
       
        if (itemIsWeapon) {
            itemDescription(isAWeapon: true, itemPossibility1: itemPossibility1, itemPossibility2: nil)
            if (canGiftBeCarry == true) {
                print("\(character.name) est apte à avoir cette arme !")
            }
            else {
                print("\(character.name) ne peut pas porter une arme de ce type.\n")
            }
        }
        else {
            itemDescription(isAWeapon: false, itemPossibility1: nil, itemPossibility2: itemPossibility2)
            if(canGiftBeCarry == true) {
                print("\(character.name) est apte à avoir ce pouvoir ! Ce povuoir a donc été ajoutée à \(character.name).")
            }
            else {
                print("\(character.name) ne peut pas utiliser ce pouvoir.\n")
            }
        }
        return canGiftBeCarry
    }
    
    func getTheGift(dependingOf itemIsWeapon: Bool, itemPossibility1 : Weapon?, itemPossibility2 : Power?, forThis character : Character ) {
        if (itemIsWeapon && itemPossibility1 != nil) {
            forWeaponGift(weaponGiven: itemPossibility1!, character: character)
        }
        else if (itemPossibility2 != nil){
            forPowerGift(powerGiven: itemPossibility2!, character: character)
        }
    }
    
    func forWeaponGift (weaponGiven : Weapon, character : Character) {
        print("Voulez-vous que \(character.name) utilise cette arme pour combattre ? il s'agira alors dans ce cas de son arme par défaut.")
        print("Entrez 'o' pour répondre par l'affirmative ou 'n' pour la négative :")
        var choice : String
        repeat {
            choice =  readLine()!
            if choice == "o" {
                character.weapon.append(weaponGiven)
                character.weaponUsedByDefault = weaponGiven
                print("\(character.name) porte désormais cette arme, de plus elle a été ajoutée à votre inventaire.")
            }
            else if choice == "n" {
                character.weapon.append(weaponGiven)
                print("Arme ajoutée à l'inventaire de \(character.name).")
            }
            else {
                print("Caractère non reconnu.\nEntrez 'o' pour répondre par l'affirmative! ou 'n' pour la négative :")
            }
        } while (choice != "o" && choice != "n")
    }
    
    func forPowerGift (powerGiven : Power, character : Character) {
        print("Voulez-vous que \(character.name) utilise ce pouvoir en tant qu'action par défaut ?")
        print("Entrez 'o' pour répondre par l'affirmative ou 'n' pour la négative :")
        var choice : String
        repeat {
            choice =  readLine()!
            if choice == "o" {
                character.power.append(powerGiven)
                character.powerUsedByDefault = powerGiven
                print("\(character.name) utilisere désormais par défaut ce nouveau pouvoir.")
            }
            else if choice == "n" {
                character.power.append(powerGiven)
                print("\(character.name) a un nouveau pouvoir !")
            }
            else {
                print("Caractère non reconnu.\nEntrez 'o' pour répondre par l'affirmative ou 'n' pour la négative :")
            }
        } while (choice != "o" && choice != "n")
    }
    
}
