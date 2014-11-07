//
//  Helpers.swift
//  StoryKit
//
//  Created by Noah Emmet on 10/30/14.
//  Copyright (c) 2014 Sticks. All rights reserved.
//

import Foundation

func PerformOnMain(work: () -> Void) {
	CFRunLoopPerformBlock(NSRunLoop.mainRunLoop().getCFRunLoop(), kCFRunLoopCommonModes, work)
}

func PerformAsync(work: () -> Void) {
	dispatch_async(dispatch_get_global_queue(0, 0), work)
}

func delay(delay:Double, closure:()->()) {
	dispatch_after(
		dispatch_time(
			DISPATCH_TIME_NOW,
			Int64(delay * Double(NSEC_PER_SEC))
		),
		dispatch_get_main_queue(), closure)
}

extension Array {
	func randomItem() -> T {
		let index = Int(arc4random_uniform(UInt32(self.count)))
		return self[index]
	}
}
