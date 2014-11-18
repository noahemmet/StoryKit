//
//  Engine.swift
//  StoryKit
//
//  Created by Noah Emmet on 11/11/14.
//  Copyright (c) 2014 Sticks. All rights reserved.
//

import Foundation

class Engine {
	var worlds = [World]()
	var eventQueue = [Event]()
	var turnDelay: Double = 0.005
	let operationQueue = NSOperationQueue()
	var timeLine: Timeline
	
	init(initialWorld: World) {
		operationQueue.maxConcurrentOperationCount = 1
		timeLine = Timeline(initialEntity: initialWorld)
		worlds.append(initialWorld)
	}
	
	func startCalculation () -> Bool{
		if let world = worlds.first {
			timeLine = Timeline(initialEntity: world)
//			PerformAsync {
//				[weak self] in self!.calculateWorld(world)			
			self.calculateWorld(world)
//			}
			return true
		} else {
			return false
		}
	}
	
	private func calculateWorld(world: World) {
		let operation = TurnOperation(world: world, eventQueue: eventQueue)
		eventQueue.removeAll(keepCapacity: false)
		operationQueue.addOperation(operation)
		weak var wself = self
		operation.completionBlock = {
			if let nextWorld = operation.nextWorld {
//				wself?.worlds.append(nextWorld)
				wself?.worlds = [nextWorld]
				wself?.calculateWorld(operation.nextWorld!)
			}
		}
		delay(turnDelay) {
			PerformAsync {
				operation.start()
			}
		}
	}
}

