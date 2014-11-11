//
//  Engine.swift
//  StoryKit
//
//  Created by Noah Emmet on 11/11/14.
//  Copyright (c) 2014 Sticks. All rights reserved.
//

import Foundation

class Engine: EngineProtocol {
	var worlds = [World]()
	var goalQueues = [Goal]()
	var turnDelay: Double = 0.01
	
	func startCalculation () -> Bool{
		if let world = worlds.first {
			calculateWorld(world)
			return true
		} else {
			return false
		}
	}
	
	private func calculateWorld(world: World) {
		let goals = self.goalQueues
		goalQueues = [Goal]()
		var newActors = [Actor]()
		for actor in world.actors {
			let newGoals = actor.goals + goals
			let newActor = Actor(goals:newGoals,
				gridPoint: actor.gridPoint,
				birthday: actor.birthday,
				energy: actor.energy,
				needs: actor.needs)
			newActors.append(newActor)
		}
		
		let nextWorld = (World(time: world.time, environment:world.environment, actors: newActors)).nextTurn(world)
		worlds.append(nextWorld)
		delay(turnDelay) {
			PerformAsync {
				if self.worlds.count > 0 {
					self.calculateWorld(nextWorld)
				}
			}
		}
	}
	
	//MARK: EngineProtocol
	func newestWorld() -> World? {
		return worlds.last
	}
}

protocol EngineProtocol {
	func newestWorld () -> World?
}