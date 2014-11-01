//
//  FirstViewController.swift
//  StoryKit
//
//  Created by Noah Emmet on 10/19/14.
//  Copyright (c) 2014 Sticks. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
	
	var textView: UITextView
	var actorView: UIView
	
	required init(coder aDecoder: NSCoder) {
		textView = UITextView()
		actorView = UIView()
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		textView.frame = view.frame
		self.view.addSubview(textView)
		
		actorView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10));
		actorView.backgroundColor = UIColor.orangeColor()
		view.addSubview(actorView)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		
		let loops = 1000
		var worlds = [World]()
		PerformAsync {
			let goal: Goal = Goal(type:GoalType.Place(GridPoint(x: 20, y: 10, z: nil)), 
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
			worlds = World(time: 0, environment:environment, actors: actors).nextTurns(loops)
			PerformOnMain{ 
				//				self.textView.text = worlds.map { $0.displayString() }.reduce("", { $0 + "\n" + $1})
				self.drawWorld(worlds.first!, worlds: worlds)
				
			}	
		}
		
		
	}
	func drawWorld(world: World, worlds: [World]) {
		let actor = world.actors.first?
		actorView.center = CGPoint(x: actor!.gridPoint!.x * 10, y: actor!.gridPoint!.y * 10)
		delay(0.4) {
			let nextIndex = find(worlds, world)! + 1
			let nextWorld = worlds[nextIndex]
			self.drawWorld(nextWorld, worlds: worlds)
		}
	}
}


