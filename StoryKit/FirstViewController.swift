//
//  FirstViewController.swift
//  StoryKit
//
//  Created by Noah Emmet on 10/19/14.
//  Copyright (c) 2014 Sticks. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
	var worlds: [World]
	var goalQueues: [Goal]
	var textView: UITextView
	var actorView: UIView
	
	required init(coder aDecoder: NSCoder) {
		worlds = [World]()
		goalQueues = [Goal]()
		textView = UITextView()
		actorView = UIView()
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		textView.frame = view.frame
//		self.view.addSubview(textView)
		
		actorView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10));
		actorView.backgroundColor = UIColor.orangeColor()
		view.addSubview(actorView)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		let loops = 1000
		
		PerformAsync {
			let goal = Goal(type:GoalType.Place(GridPoint(x: 20, y: 10, z: nil)), 
				priority: 100,
				immediacy: 10,
				motivations: [Motivation.EtherealVoice],
				subgoals: [Goal]())
			let actors = [Actor(goals:[goal],
				gridPoint: GridPoint(x: 0, y: 0, z: nil),
				birthday: 0,
				energy: 100,
				needs: nil)]
			let environment = Environment(potentialEnergy: 100)
			
			self.calculateWorld(World(time: 0, environment:environment, actors: actors))
		}
	}
	
	func calculateWorld(world: World) {
		PerformOnMain{
			self.drawWorld(world)
		}
		let goals = self.goalQueues
		let actor = world.actors.first!
		let newGoals = actor.goals + goals
		goalQueues = [Goal]()
		let newActor = Actor(goals:newGoals,
			gridPoint: actor.gridPoint,
			birthday: actor.birthday,
			energy: actor.energy,
			needs: actor.needs)
		let nextWorld = (World(time: world.time, environment:world.environment, actors: [newActor])).nextTurn(world)
		worlds.append(nextWorld)
		delay(0.1) {
			self.calculateWorld(nextWorld)
		}
	}
	
	func drawWorld(world: World) {
		let actor = world.actors.first?
		actorView.center = CGPoint(x: actor!.gridPoint!.x * 10, y: actor!.gridPoint!.y * 10)
		
	}
	
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		let point = touches.anyObject()!.locationInView(view)
		let goal = Goal(type:GoalType.Place(GridPoint.fromCGPoint(point)),
		priority: 120,
		immediacy: 40,
		motivations: [Motivation.EtherealVoice],
		subgoals: [Goal]())
		
		goalQueues.append(goal)
	}
}


