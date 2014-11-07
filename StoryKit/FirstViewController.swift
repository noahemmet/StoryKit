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
	var actorViews: [UIView]
	
	required init(coder aDecoder: NSCoder) {
		worlds = [World]()
		goalQueues = [Goal]()
		textView = UITextView()
		actorViews = [UIView]()
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		// Remove previous
		for view in actorViews {
			view.removeFromSuperview()
		}
		actorViews.removeAll(keepCapacity: false)
		self.worlds.removeAll(keepCapacity: false)
		
		var actors = [Actor]()
		for i in 1...100 {
			let gridPoint = GridPoint(x: Int(arc4random_uniform(60)), y: Int(arc4random_uniform(90)), z: nil)
			let goal = Goal(type:GoalType.Place(GridPoint(x: Int(arc4random_uniform(60)), y: Int(arc4random_uniform(90)), z: nil)), 
				priority: 100,
				immediacy: 10,
				motivations: [Motivation.EtherealVoice],
				subgoals: [Goal]())
			let actor = Actor(goals:[goal],
				gridPoint: gridPoint,
				birthday: 0,
				energy: 100,
				needs: nil)
			actors.append(actor)
		}
		
		let environment = Environment(potentialEnergy: 100)
		self.worlds.append(World(time: 0, environment:environment, actors: actors))
		
		self.actorViews = self.worlds.first!.actors.map {
			actor in 
			var actorView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10)) 
			actorView.backgroundColor = self.randomColor()
			self.view.addSubview(actorView)
			return actorView
		}
		
		PerformAsync {
			self.calculateWorld(self.worlds.first!)
		}
	}
	
	func calculateWorld(world: World) {
		PerformOnMain{
			self.drawWorld(world)
		}
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
		delay(0.01) {
			if self.worlds.count > 0 {
				self.calculateWorld(nextWorld)
			}
		}
	}
	
	func drawWorld(world: World) {
		for var i = 0; i < world.actors.count; i++ {
			let actor = world.actors[i]
			let actorView = self.actorViews[i]
			actorView.center = CGPoint(x: actor.gridPoint!.x * 10, y: actor.gridPoint!.y * 10)
		}
		
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
	
	func randomColor() -> UIColor {
		let colors = [UIColor.orangeColor(),
		UIColor.redColor(),
		UIColor.blueColor(),
		UIColor.purpleColor(),
		UIColor.greenColor()]
		return colors.randomItem()
	}
}


