//
//  FirstViewController.swift
//  StoryKit
//
//  Created by Noah Emmet on 10/19/14.
//  Copyright (c) 2014 Sticks. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let actors = [Actor(goals:[Goal](),
			location: nil, 
			birthday: 0, 
			energy: 100,
			needs: nil)]
		let environment = Environment(potentialEnergy: 100)
		var world = World(time: 0, environment:environment, actors: actors)
		for i in 1...100 {
			world = world.nextTurn()
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

