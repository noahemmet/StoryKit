//
//  Event.swift
//  StoryKit
//
//  Created by Noah Emmet on 11/14/14.
//  Copyright (c) 2014 Sticks. All rights reserved.
//

import Foundation

struct Event: Hashable {
	let type: EventType	
	var hashValue: Int { get { return 0 } }
}

func ==(lhs: Event, rhs: Event) -> Bool {
	return lhs.hashValue == rhs.hashValue
}

enum EventType {
	case PlayerTouch(point: GridPoint)
}