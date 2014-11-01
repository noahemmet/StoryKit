//
//  World.swift
//  StoryKit
//
//  Created by Noah Emmet on 10/29/14.
//  Copyright (c) 2014 Sticks. All rights reserved.
//

import Foundation

class Time {
	var current: Int = 100
	class var shared : Time {
		struct Static {
			static let instance = Time()
		}
		return Static.instance
	}
}

struct World: TurnSolvable, Equatable {
	var time: Int = 0
	
	var environment: Environment
	var actors: [Actor]
	
	func nextTurn() -> World {
		let nextEnvironment = environment.nextTurn()
		let nextActors = actors.map{actor in actor.nextTurn()}
		let nextWorld = World(time: time+1, environment: nextEnvironment, actors: nextActors)
		return nextWorld
	}
	
	func nextTurns(total: Int) -> [World] {
		var worlds = [World]()
		var world = self
		for i in 1...total {
			world = world.nextTurn()
			worlds.append(world)
		}
		return worlds
	}
	
	func displayString() -> String {
		return "env: \(environment.potentialEnergy)"
	}
}
func ==(lhs:World, rhs:World) -> Bool {
	return lhs.time == rhs.time
}

struct Environment: TurnSolvable {
	var potentialEnergy = 100
	
	func nextTurn() -> Environment {
		let environment = Environment()
		return environment
	}
}

struct Item: TurnSolvable {
//	let name: String
	let mass: Float = 100.0
	func nextTurn() -> Item {
		return Item()
	}
	
}

protocol TurnSolvable {
	func nextTurn<Self>() -> Self
}