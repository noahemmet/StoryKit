//
//  TurnOperation.swift
//  StoryKit
//
//  Created by Noah Emmet on 11/11/14.
//  Copyright (c) 2014 Sticks. All rights reserved.
//

import Foundation

class TurnOperation: NSOperation {
	let world: World
	let goalQueue: [Dictionary<Int, Goal>]? // Actor.ID
	var nextWorld: World?
	var asyncronous: Bool {
		get { return true }
	}
//	override var finished: Bool {
//		get { return true }
//	}
	
	init(world:World, goalQueue: [Dictionary<Int, Goal>]?) {
		self.world = world
		self.goalQueue = goalQueue
		super.init()
	}
	
	override func start() {
		calculateWorld()
	}
	
	private func calculateWorld() {
		
//		let nextActors = world.actors.map ({ actor in 
//			var newGoals = actor.goals
//			for dict in goalQueue! {
//				if let goal = dict[actor.ID] {
//					newGoals.append(goal)
//				}
//			}
//			let newActor = Actor(
//				ID: actor.ID,
//				goals: newGoals,
//				gridPoint: actor.gridPoint,
//				birthday: actor.birthday,
//				energy: actor.energy,
//				needs: actor.needs)
//			return newActor
//		})
		
		
		var newActors = [Actor]()
		for actor in world.actors {
			var newGoals = actor.goals
			for dict in goalQueue! {
				if let goal = dict[actor.ID] {
					newGoals.append(goal)
				}
			}
			let newActor = Actor(
				ID: actor.ID,
				goals: newGoals,
				gridPoint: actor.gridPoint,
				birthday: actor.birthday,
				energy: actor.energy,
				needs: actor.needs)
			newActors.append(newActor)
		}
		
		var updatedWorld = (World(time: world.time, environment:world.environment, actors: newActors))
		let nextWorld = updatedWorld.nextTurn(&updatedWorld)
		
		if completionBlock != nil{
			PerformAsync {
				self.completionBlock!()
			}
		}
	}
}
