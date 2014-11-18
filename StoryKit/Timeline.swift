//
//  Timeline.swift
//  StoryKit
//
//  Created by Noah Emmet on 11/14/14.
//  Copyright (c) 2014 Sticks. All rights reserved.
//

import Foundation

class Timeline {
	let initialEntity: TurnSolvable
	var events = [Dictionary<Event, Int>]()
	
	init(initialEntity: TurnSolvable) {
		self.initialEntity = initialEntity
	}
}
