//
//  Helpers.swift
//  StoryKit
//
//  Created by Noah Emmet on 10/30/14.
//  Copyright (c) 2014 Sticks. All rights reserved.
//

import Foundation
import UIKit
//MARK: Runloop

func PerformOnMain(work: () -> Void) {
	CFRunLoopPerformBlock(NSRunLoop.mainRunLoop().getCFRunLoop(), kCFRunLoopCommonModes, work)
}

func PerformAsync(work: () -> Void) {
	dispatch_get_global_queue(0, 1)
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

//MARK: Collections

extension Array {
	func randomItem() -> T {
		let index = Int(arc4random_uniform(UInt32(self.count)))
		return self[index]
	}
}

extension UIColor {
	class func randomColor() -> UIColor{
		let colors = [UIColor.orangeColor(),
			UIColor.redColor(),
			UIColor.blueColor(),
			UIColor.purpleColor(),
			UIColor.greenColor()]
		return colors.randomItem()
	}
}