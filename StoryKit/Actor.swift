//
//  Actor.swift
//  StoryKit
//
//  Created by Noah Emmet on 10/19/14.
//  Copyright (c) 2014 Sticks. All rights reserved.
//

import Foundation

struct Actor: TurnSolvable {
	var goals: [Goal]
	var location: Location?
	let birthday: Int
	var energy: Float
	var needs: [Need]?
	func age() -> Int {
		// TODO
		return Time.shared.current - birthday
	}
	func speed() -> Int {
		return 1
	}
	
	func actions() -> [Action]{
		var action: Action? = goals.first?.requiredActions().first?
		if action? != nil { return [action!] }
		else { return [Action]() }
	}
//	func nextTurn<Actor>() -> Actor {
//		return 
//	}
	func nextTurn() -> Actor {
		println(energy)
		return Actor(goals: goals, location: location, birthday: birthday, energy: energy - 1, needs: needs)
	}
}

struct Goal {
	let type: GoalType
	let priority: Float
	let immediacy: Float
	let motivations: [Motivation]
	let subgoals: [Goal]
	
	func requiredActions() -> [Action] {
		
		let action = Action()
		return [action]
	}
}

enum GoalType { 
	case Place(Location)
	case Emotional([Emotion])
	case Creative
	case Financial
	case Health
}

struct Action {
	func requiredEnergy() -> Float{
		return 25
	}
}

enum Motivation {
	case God, EtherealVoice
	case Physiological
	case Emotion
}

enum Need {
	case Physiological
	case Safety
	case LoveOrBelonging
	case Esteem
	case SelfActualization
}

struct Location {
	let x,y: Int
	let z: Int?
}

struct Emotion {
	let name: String
}