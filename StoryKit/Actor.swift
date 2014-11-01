//
//  Actor.swift
//  StoryKit
//
//  Created by Noah Emmet on 10/19/14.
//  Copyright (c) 2014 Sticks. All rights reserved.
//

import Foundation

struct Actor: TurnSolvable {
	var goals: [Goal]
	var gridPoint: GridPoint?
	let birthday: Int
	var energy: Float
	var needs: [Need]?
	func age() -> Int {
		return Time.shared.current - birthday
	}
	func speedForTerrain(terrain: Terrain) -> Float {
		return terrain.speedMultiplier 
	}
	func energyAfterRest () -> Float {
		return 100
	}
	
	func nextTurn() -> Actor {
		let sortedGoals = sorted(goals, {
			(goal1, goal2) -> Bool in
			return goal1.immediacy > goal2.immediacy || goal1.priority > goal2.priority
		})
		var actions = sortedGoals.map {
			(var goal) -> Action? in
			switch goal.type {
			case let .Place(goalPoint):
				if (self.gridPoint == goalPoint) {
					return Action(type: .ResolvedGoal(goal))
				}
				let newGoalPoint = goalPoint.moveHereFromPoint(self.gridPoint!)
				return Action(type: .Move(newGoalPoint))
			default:
				return nil
			}
		}
		var newEnergy = energyAfterRest()
		var newGridPoint = gridPoint
		for action in actions {
			if (newEnergy <= 0) { break }
			if (action == nil)  { break }
			switch action!.type {
			case let .ResolvedGoal(goal):
				newEnergy += goal.resolutionReward()
				
			case let .Move(point):
				newGridPoint = point
			}
		}
		let newGoals = sortedGoals.filter {
			(var goal) -> Bool in
			return true
		}
		return Actor(goals: goals.map{goal in goal.nextTurn()}, 
			gridPoint: newGridPoint, 
			birthday: birthday,
			energy: energy - 1, 
			needs: needs)
	}
}

struct Goal: TurnSolvable {
	let type: GoalType
	let priority: Float  = 100.0
	let immediacy: Float = 100.0
	let motivations: [Motivation] = [Motivation]()
	let subgoals: [Goal] = [Goal]()
//	var isResolved: Bool = false
	
	func nextTurn() -> Goal {
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
}

enum GoalType { 
	case Place(GridPoint)
	case Emotional([Emotion])
	case Creative
	case Financial
	case Health
}

struct Action {
	let type: ActionType
	func requiredEnergy() -> Float{
		return 25
	}
}

enum ActionType {
	case Move(GridPoint)
	case ResolvedGoal(Goal)
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