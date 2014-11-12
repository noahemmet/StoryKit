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
	let goalQueue: [Goal]?
	var nextWorld: World?
	var asyncronous: Bool {
		get { return true }
	}
	
	init(world:World, goalQueue: [Goal]?) {
		self.world = world
		self.goalQueue = goalQueue
		super.init()
	}
	
	override func start() {
		calculateWorld(world)
	}
	
	private func calculateWorld(world: World) {
		var newActors = [Actor]()
		for actor in world.actors {
			var newGoals = actor.goals
			if (self.goalQueue != nil) {
				newGoals += self.goalQueue!
			}
			let newActor = Actor(
				goals:newGoals,
				gridPoint: actor.gridPoint,
				birthday: actor.birthday,
				energy: actor.energy,
				needs: actor.needs)
			newActors.append(newActor)
		}
		
		nextWorld = (World(time: world.time, environment:world.environment, actors: newActors)).nextTurn(world)
		
		if completionBlock != nil{
			completionBlock!()
		}
	}
}
