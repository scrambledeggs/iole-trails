# Trails Exercise
## Requirements
3 models
 - [x] Person (people table)
 - [x] Trail (trails table)
 - [x] Practice (practices tables)

Person model
 - [x] has age, body-build (slim, fit, large)
 - [x] can `start` *practice* on any *trail*
  - given he/she has passed the criteria of a trail
  - given he/she is not already starting a practice on a trail
 - [x] can `finish` *practice* on a *trail*
  - given he/she is starting this particular trail
 - [x] can see all trails finished
 - [x] can see all uncompleted trails

Trail model
 - [x] has pass criteria depending on age, body-build
 - [x] can see people who have finished this trail
 - [x] can see people who have started the trail
 - [x] can see people who can start the trail

Practice model
 - [x] has the status field of person/trail

## To-do list
 - [ ] routes: practice should be nested under people
 - [ ] ruby way for arrays: `%i[ ]`
 - [ ] For new practice: pre-filter only eligible trails
 - [ ] practice controller: separate method for checking eligibility
 - [ ] change if/else in controllers for create, update etc. to 2 lines

## Diagram
![Diagram](src/trails_diagram.png)