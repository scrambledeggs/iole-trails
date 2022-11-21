# Trails Exercise
## To-do list
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
 - [ ] can see people who can start the trail

Practice model
 - [x] has the status field of person/trail

Stuff
 - [x] Mark as finished
 - [ ] Form for New/Edit Trails
 - [ ] Radio buttons for body build in New/Edit Person
 - [x] Update Trails controller same as People
 - [x] Check eligibility redirect
 - [ ] Make body_build enum as common
 - [ ] Fat model, skinny controller

Additional
 - [ ] Practice start and end date?
 - [ ] Ask if need for Practices view?

## Diagram
![Diagram](src/trails_diagram.png)