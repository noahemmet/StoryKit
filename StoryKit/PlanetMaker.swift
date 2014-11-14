//
//  PlanetMaker.swift
//  StoryKit
//
//  Created by Noah Emmet on 11/1/14.
//  Copyright (c) 2014 Sticks. All rights reserved.
//

import Foundation

struct PlanetMaker {
	var numInitialActors: Int
	
	func world () -> World {
		var actors = [Actor]()
		for i in 1...numInitialActors {
			let gridPoint = GridPoint(x: Int(arc4random_uniform(60)), y: Int(arc4random_uniform(90)), z: nil)
			let goal = Goal(type:GoalType.Place(GridPoint(x: Int(arc4random_uniform(60)), y: Int(arc4random_uniform(90)), z: nil)), 
				priority: 100,
				immediacy: 10,
				motivations: [Motivation.EtherealVoice],
				subgoals: [Goal]())
			let actor = Actor(
				ID: i,
				goals:[goal],
				gridPoint: gridPoint,
				birthday: 0,
				energy: 100,
				needs: [Need]())
			actors.append(actor)
		}
		
		let environment = Environment(potentialEnergy: 100)
		let world = (World(time: 0, environment:environment, actors: actors))
		return world
	}
}