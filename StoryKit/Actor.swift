//
//  Actor.swift
//  StoryKit
//
//  Created by Noah Emmet on 10/19/14.
//  Copyright (c) 2014 Sticks. All rights reserved.
//

import Foundation
import UIKit

struct Actor: TurnSolvable {
	let ID: Int
	var goals = [Goal]()
	var gridPoint: GridPoint
	let birthday: Int
	var energy: Float
	var needs: [Need]
	func age() -> Int {
		return Time.shared.current - birthday
	}
	func speedForTerrain(terrain: Terrain) -> Float {
		return terrain.speedMultiplier 
	}
	func energyAfterRest () -> Float {
		return 100
	}
	
	func goalsForID() -> [Dictionary<Int, Goal>]{
		return self.goals.map { goal in 
			return [self.ID: goal]
		}
	}
	
	func nextTurn(inout world: World) -> Actor {
		let sortedGoals = sorted(goals, {
			(goal1, goal2) -> Bool in
			return goal1.immediacy > goal2.immediacy || goal1.priority > goal2.priority
		})
		let actions = sortedGoals.map {
			(var goal) -> Action? in
			switch goal.type {
			case let .Place(goalPoint):
				let newGoalPoint = goalPoint.moveHereFromPoint(self.gridPoint)
				return Action(type: .Move(newGoalPoint))
				
			default:
				return nil
			}
		}
		var newEnergy = energyAfterRest()
		var newGridPoint = gridPoint
		for action in actions {
			if (newEnergy <= 0) { break }
			if (action == nil)  { continue }
			switch action!.type {
			case let .Move(point):
				newGridPoint = point
			}
		}
		let newGoals = sortedGoals.filter {
			(var goal) -> Bool in
			switch goal.type {
			case let .Place(goalGridPoint):
				return self.gridPoint != goalGridPoint
			case let .Emotional(emotions):
				return true
			case .Creative:
				return true
			case .Financial:
				return true
			case .Health:
				return true
			}
		}
		return Actor(
			ID: ID,
			goals: newGoals, 
			gridPoint: newGridPoint, 
			birthday: birthday,
			energy: energy - 1, 
			needs: needs)
	}
}

struct Goal: TurnSolvable, Hashable {
	let type: GoalType
	let priority: Float  = 100.0
	let immediacy: Float = 100.0
	let motivations: [Motivation] = [Motivation]()
	let subgoals: [Goal] = [Goal]()
	//	var isResolved: Bool = false
	
	func nextTurn(inout world: World) -> Goal {
		return Goal(type: type, priority: priority, immediacy: immediacy, motivations: motivations, subgoals: subgoals)
	}
	func resolutionReward() -> Float {
		return 10
	}
	//	func isResolvedForType(checkedGoalType: GoalType) -> Bool {
	//		switch checkedGoalType {
	//		case let .Place(checkedPoint):
	//			let placeType = GoalType.Place(point)
	//			return checkedPoint == self.type as GoalType.Place(point) in point
	//		}
	//	}
	var hashValue: Int { get {
		return -1
	}
	}
}
func ==(lhs: Goal, rhs: Goal) -> Bool {
	return lhs.hashValue == rhs.hashValue
}

enum GoalType { 
	case Place(GridPoint)
	case Emotional([Emotion])
	case Creative
	case Financial
	case Health
}

struct Action: Hashable {
	let type: ActionType
	func requiredEnergy() -> Float{
		return 25
	}
	
	var hashValue: Int { get {
		return 3
		}
	}
}

func ==(lhs: Action, rhs: Action) -> Bool {
	return false
}

enum ActionType {
	case Move(GridPoint)
}

enum Motivation {
	case God, EtherealVoice
	case Physiological
	case Emotion
}

enum Need {
	case Physiological
	case Safety
	case LoveOrBelonging
	case Esteem
	case SelfActualization
}

struct Location {
	let gridPoint: GridPoint
	let terrain: Terrain
}

struct GridPoint: Equatable {
	let x,y: Int
	let z: Int?
	func moveHereFromPoint(startPoint:GridPoint) -> GridPoint{
		var endX = startPoint.x
		var endY = startPoint.y
		var endZ = startPoint.z
		if startPoint.x < x {
			endX++
		} else if startPoint.x > x {
			endX--
		}
		if startPoint.y < y {
			endY++
		} else if startPoint.y > y {
			endY--
		}
		if startPoint.z? < z? {
			endZ?++
		} else if startPoint.z? > z? {
			endZ?--
		}
		return GridPoint(x: endX, y: endY, z: endZ)
	}
	
	static func fromCGPoint (cgPoint: CGPoint) -> GridPoint {
		print(cgPoint)
		return GridPoint(x: Int(cgPoint.x/10.0), y: Int(cgPoint.y/10.0), z: nil)
	}
	
	func distanceFromGridPoint(point: GridPoint) -> Int {
		let distance = abs(point.x - self.x) + abs(point.y - self.y)
		return distance
	}
	
	func randomPointWithinDistance(distance: UInt) -> GridPoint {
		if distance == 0 { return self }
		var signX = Int(arc4random_uniform(2) == 1 ? 1 : -1) as Int
		var signY = Int(arc4random_uniform(2) == 1 ? 1 : -1)
		let randomXDistance = arc4random_uniform(UInt32(distance))
		let randomYDistance = arc4random_uniform(UInt32(distance))
		let newX = x - (Int(randomXDistance) * signX)
		let newY = y - (Int(randomYDistance) * signY)
		return GridPoint(x: newX, y: newY, z: z)
	}
}

func ==(lhs: GridPoint, rhs: GridPoint) -> Bool {
	return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z? == rhs.z?
}

struct Terrain {
	let speedMultiplier: Float = 1
}

struct Emotion {
	let name: String
}