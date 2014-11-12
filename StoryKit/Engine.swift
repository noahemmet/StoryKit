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
	var goalQueue = [Goal]()
	var turnDelay: Double = 0.005
	let operationQueue = NSOperationQueue()
	
	init() {
		operationQueue.maxConcurrentOperationCount = 1
	}
	
	func startCalculation () -> Bool{
		if let world = worlds.first {
			PerformAsync {
				[weak self] in self!.calculateWorld(world)
			}
			return true
		} else {
			return false
		}
	}
	
	private func calculateWorld(world: World) {
		let operation = TurnOperation(world: world, goalQueue: goalQueue)
		self.goalQueue.removeAll(keepCapacity: false)
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
		//		worlds.append(nextWorld)
//		worlds = [nextWorld]
//		delay(turnDelay) {
//			weak var _self = self
//			PerformAsync {
//				if _self?.worlds.count > 0 {
//					_self?.calculateWorld(nextWorld)
//				}
//			}
//		}
	}
}