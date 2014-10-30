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
		return Time.shared.current - birthday
	}
	func speedForTerrain(terrain: Terrain) -> Float {
		return terrain.speedMultiplier 
	}
	
	func nextTurn() -> Actor {
		return Actor(goals: goals.map{goal in goal.nextTurn()}, 
			location: location, 
			birthday: birthday,
			energy: energy - 1, 
			needs: needs)
	}
}

struct Goal: TurnSolvable {
	let type: GoalType
	let priority: Float  = 100.0
	let immediacy: Float = 100.0
	let motivations: [Motivation] = [Motivation]()
	let subgoals: [Goal] = [Goal]()
	
	func nextTurn() -> Goal {
		return Goal(type: type, priority: priority, immediacy: immediacy, motivations: motivations, subgoals: subgoals)
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
	let terrain: Terrain
}

struct Terrain {
	let speedMultiplier: Float = 1
}

struct Emotion {
	let name: String
}