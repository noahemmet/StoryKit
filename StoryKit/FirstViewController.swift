//
//  FirstViewController.swift
//  StoryKit
//
//  Created by Noah Emmet on 10/19/14.
//  Copyright (c) 2014 Sticks. All rights reserved.
//

import UIKit
import SpriteKit

class FirstViewController: UIViewController {
	var skView: SKView
	var scene: Scene?
	
	required init(coder aDecoder: NSCoder) {
		skView = SKView()
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		scene = Scene(size: view.frame.size)
		skView = SKView(frame: view.frame)
		skView.showsDrawCount = true
		skView.showsFPS = true
		skView.showsNodeCount = true
		view.addSubview(skView)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		skView.presentScene(scene)
	}
	
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		let point = touches.anyObject()!.locationInView(skView)
		let gridPoint = GridPoint.fromCGPoint(point)
		let actors = scene?.engine.worlds.last?.nearestActorsToPoint(GridPoint.fromCGPoint(point))
		var goalQueue = [Dictionary<Int, Goal>]()
		for i in 0 ... 2 {
			if let actor = actors?[i] {
			let goal = Goal(
				type:GoalType.Place(gridPoint.randomPointWithinDistance(10)),
				priority: 120,
				immediacy: 40,
				motivations: [Motivation.EtherealVoice],
				subgoals: [Goal]())
				
				goalQueue.append([actor.ID: goal])
			}
		}
		
//		PerformAsync {
			self.scene?.engine.goalQueue += goalQueue
//		}
	}
}


