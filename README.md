# Workout App - iOS version
## Important Notice
This app is work in progress 🚧. My wish is to adapt it as a personal showcase app. I think this is a great candidate as it shows how code could be complicated and far away from simple and ideal examples that we see online. Some of the specs:
- This app works only in offline mode using MockData
- There are a lot of Firebase's code that is not used because I shut down the instance

## TO DO list
 
 - [ ] server-side Swift
 - [ ] setup database
 - [ ] setup API
 - [ ] remove firebase code
 - [ ] setup new api on mobile client
 - [ ] update mock files and tests
 - [ ] use Core Data as offline DB
 - [ ] setup sync model
 - [ ] make integration tests

NOTE: Down bellow was initial proposal to the client. I will keep as a history. Also, it has some nice explanation of current architecture.

## Description
Just a simple Workout app using Firebase as a back-end service. App shows a list of possible workout sessions, from which user should choose one. Every workout session consist of multiple exercises in a certain order. Every exercise has a detail view with YouTube link. 

## Goal
Trying to put the best architecture approach with all leasons learned through many years put in one production project, backup by server system
## Future plans
This app doesn't have any design it's just my way of arranging elements (developer design). Maybe in the future I will invest more time and make it more appealing with animation and transitions. 

I would also to make a transition to RxSwift but this framework is not so begginer friendly so there is a tradeoff to consider in the future.

I would also like to see Vapor as a backend service technology and deploy it somewhere with an attempt of sharing some code.

Even though the code is written to be tested and mock structure is in place for both purposes of testing and rapid prototyping in playgrounds.

## Architecture
Here is used MVVM-C architecture or ModelView View Model - Coordinators. I also used Promises as basic structure for chaining API calls and also very begginer friendly framework. This helps a lot to achieve writing more descriptive code.

The whole app is divided into layered architecture and frameworks. In this project we have two but scalability has no limits. 
* DataSourceFramework - handling fetch and save of data, models and everything related to data
* WorkoutsFramework - UI framework with Workouts, exercise screens. Very handy to have UI screens in framework so we can do rapid prototyping in playgrounds

## Setup
Just checkout the cod run `pod install` to install all Cocoapods dependencies. Build all frameworks individually and then main project itself of course.

## Credentials 
This app was written by me alone in Swift programming language with support Firebase and other 3rd-party libraries
