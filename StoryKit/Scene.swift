//
//  Scene.swift
//  StoryKit
//
//  Created by Noah Emmet on 11/11/14.
//  Copyright (c) 2014 Sticks. All rights reserved.
//

import SpriteKit

class Scene: SKScene {
	var engine: Engine = Engine()
	
	var actorNodes: [SKSpriteNode] = [SKSpriteNode]()
	override init(size: CGSize) {
		let planetMaker = PlanetMaker(numInitialActors: 100)
		engine.worlds.append(planetMaker.world())
		engine.startCalculation()
		super.init(size: size)
	}

	required init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
	}
	
	override func didMoveToView(view: SKView) {
		actorNodes = engine.worlds.first!.actors.map {
			actor in 
			var actorNode = SKSpriteNode(color: UIColor.randomColor(), size: CGSize(width: 10, height: 10))
			self.addChild(actorNode)
			return actorNode
		}
	}
	
	override func update(currentTime: NSTimeInterval) {
		if let world = engine.worlds.last {
			drawWorld(world)
		}
	}
	
	func drawWorld(world: World) {
		for var i = 0; i < world.actors.count; i++ {
			let actor = world.actors[i]
			let actorNode = self.actorNodes[i]
			actorNode.position = CGPoint(x: actor.gridPoint!.x * 10, y: Int(frame.size.height) - actor.gridPoint!.y * 10)
		}
	}
}