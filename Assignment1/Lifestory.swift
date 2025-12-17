import Foundation

// Step 1: Personal Information
var firstName: String = "Daniyal"
var lastName: String = "Baimenov"
var birthYear: Int = 2005
let currentYear: Int = 2025
var age: Int = currentYear - birthYear
var isStudent: Bool = true
var height: Double = 1.75

// Step 2: Hobbies and Interests
var hobby: String = "music🎶"
var numberOfHobbies: Int = 3
var favoriteNumber: Int = 7
var isHobbyCreative: Bool = true

// Step 3: Summary of Life Story
var lifeStory: String = "My name is \(firstName) \(lastName). I am \(age) years old, born in \(birthYear). " +
"I am currently a student: \(isStudent). I enjoy \(hobby), which is a creative hobby: \(isHobbyCreative). " +
"I have \(numberOfHobbies) hobbies in total, and my favorite number is \(favoriteNumber). " +
"My height is \(height)m."

// Bonus: Future Goals
var futureGoals: String = " In the future, I want to have a lot of cars🏎️."
lifeStory += futureGoals

// Step 4: Print
print(lifeStory)
