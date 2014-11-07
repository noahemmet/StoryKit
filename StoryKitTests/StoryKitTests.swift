//
//  StoryKitTests.swift
//  StoryKitTests
//
//  Created by Noah Emmet on 10/19/14.
//  Copyright (c) 2014 Sticks. All rights reserved.
//

import XCTest
import StoryKit

class StoryKitTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testStory() {
		self.measureBlock() {
			let actors = [Actor(goals:[Goal](),
				gridPoint: nil, 
				birthday: 0, 
				energy: 100,
				needs: nil)]
			let environment = Environment(potentialEnergy: 100)
			var world = World(time: 0, environment:environment, actors: actors)
			for i in 1...1000 {
				world = world.nextTurn(world)
			}
		}
	}
}
