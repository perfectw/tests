//: Playground - noun: a place where people can play

import Foundation

// Protocol definitions

protocol Soundable {
	associatedtype Sound
}

protocol Animal: Soundable {
	associatedtype Sound
	func makeSound(_ sound: Sound)
}

protocol Zoo: Soundable {
	associatedtype Sound
	// add animal to the Zoo
	func addAnimal<A: Animal>(_ a: A) where A.Sound == Sound
	// call makeSound for each animal in the Zoo
	func makeSounds(_ sound: Sound)
}

// Specific implementations
enum MySound {
	case NoSound
	case Roar
}

class Dog: Animal {
	typealias Sound = MySound
	func makeSound(_ sound: MySound) {
		switch sound {
		case .NoSound:
			print("Can I please woof?")
		case .Roar:
			print("WOOF! WOOF!")
		}
	}
}

class Cat: Animal {
	typealias Sound = MySound
	func makeSound(_ sound: MySound) {
		switch sound {
		case .NoSound:
			print("Purr...")
		case .Roar:
			print("Meow!")
		}
	}
}

// Add here class MyZoo which implements Zoo protocol with Sound == MySound

/*
По условию тестового задания мне не до конца ясна цель класса MyZoo, поэтому я сделал два варианта.
Второй варинат лучше в случае, если это реальные конечные сущности предметной области. Однако, первый более универсальный, хоть требует расширения классов перед "использованием" в MyZoo.
Если выбирать только один, я останавливаюсь на первом варианте.
*/

// OPTION 1

protocol MySoundable {
	func makeSound(_ sound: MySound)
}
extension Dog: MySoundable {}
extension Cat: MySoundable {}

final class MyZoo: Zoo {
	typealias Sound = MySound
	private var soundableAnimals: [MySoundable] = []

	func addAnimal<A: Animal>(_ a: A) where A.Sound == Sound {
		guard let newAnimal = a as? MySoundable else { return assertionFailure() }
		soundableAnimals.append(newAnimal)
	}

	func makeSounds(_ sound: Sound) {
		soundableAnimals.forEach { $0.makeSound(sound) }
	}
}

// OPTION 2

final class MyZoo2: Zoo {
	typealias Sound = MySound

	private enum SpecificAnimal: Animal {
		typealias Sound = MyZoo.Sound
		case cat(Cat)
		case dog(Dog)
		case unknown(Any)

		func makeSound(_ sound: MySound) {
			switch self {
			case .cat(let animal):
				animal.makeSound(sound)
			case .dog(let animal):
				animal.makeSound(sound)
			case .unknown:
				break
			}
		}
	}
	private var animals = [SpecificAnimal]()

	func addAnimal<A: Animal>(_ a: A) where A.Sound == Sound {
		let newAnimal: SpecificAnimal
		if let cat = a as? Cat {
			newAnimal = .cat(cat)
		} else if let dog = a as? Dog {
			newAnimal = .dog(dog)
		} else {
			newAnimal = .unknown(a)
			assertionFailure()
		}
		animals.append(newAnimal)
	}

	func makeSounds(_ sound: Sound) {
		animals.forEach { $0.makeSound(sound) }
	}
}

/*
Конец моего решения
*/

let zoo = MyZoo()
zoo.addAnimal(Cat())
zoo.addAnimal(Dog())
zoo.addAnimal(Cat())

zoo.makeSounds(.NoSound)
// Output:
// Purr...
// Can I please woof?
// Purr...
zoo.makeSounds(.Roar)
// Output:
// Meow!
// WOOF! WOOF!
// Meow!
