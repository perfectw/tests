//: Playground - noun: a place where people can play

import UIKit

class Node {
	var next: Node?
	var value: Int

	init(value: Int) {
		self.value = value
	}

	func doPrint() {
		print(value)
		next?.doPrint()
	}

	func last() -> Node {
		var last = self
		while let next = last.next {
			last = next
		}
		return last
	}

	func reverse() {
		print("before:")
		doPrint()

		var previous = self
		var tempCurrent = previous.next
		while let current = tempCurrent {
			tempCurrent = current.next
			current.next = previous
			previous = current
		}
		next = nil

		print("\nafter:")
		previous.doPrint()
	}
}

var head: Node?
head = Node(value: 0)
head?.next = Node(value: 1)
head?.next?.next = Node(value: 2)
head?.reverse()
