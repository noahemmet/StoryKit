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
	let eventQueue: [Event]?
	var nextWorld: World?
	var asyncronous: Bool {
		get { return true }
	}
//	var isFinished = false
//	override var finished: Bool {
//		get { return isFinished }
//	}
	
	init(world:World, eventQueue: [Event]?) {
		self.world = world
		self.eventQueue = eventQueue
		super.init()
	}
	
	override func start() {
		calculateWorld()
	}
	
	private func calculateWorld() {
		var newActors = [Actor]()
		for actor in world.actors {
			var newGoals = actor.goals
			for event in eventQueue! {

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
		nextWorld = updatedWorld.nextTurn(&updatedWorld)
//		isFinished = true
		if completionBlock != nil{
//			PerformAsync {
				self.completionBlock!()
			}
//		}
	}
}
