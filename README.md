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
 - [x] Fat model, skinny controller
 - [x] Mark as finished
 - [x] Form for New/Edit Trails
 - [x] Radio buttons for body build in New/Edit Person
 - [x] Update Trails controller same as People
 - [x] Check eligibility redirect
 - [x] Make body_build enum as common -- referencing only
 - [x] View for eligible people
 - [x] Implement `person.practice_on(trail)`
 - [x] Add date for past trails
 - [x] Notice for eligibility error
 - [x] Shorten eligibility check conditions in model
 - [x] Record dependency

## Diagram
![Diagram](src/trails_diagram.png)