Original App Design Project - README Template
===

# Study Buddy

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Helps college students find other students that are taking the same classes to help them find study partners/groups. Also helps compare class schedules to find shared free times to study.

### App Evaluation
 - **Category:** Education/Productivity/Social
 - **Mobile:** Can use maps to find locations close to everybody, users will have profiles to keep track of their schedules
 - **Story:** Helps match people with potential study partners or groups to help them succeed in their shared classes.
 - **Market:** College students
 - **Habit:** Students would use the app fairly often to find people to study with and times that they could meet
 - **Scope:** Could start with only finding students in the same class and be expanded to include both groups and individuals, coordinate study times, and find locations/plan study times

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can create a new account
* User can login to the app
* User can view their class schedule
* User can add classes to their schedule
* User can add blockout times to their schedule
* User can view details view of a class including other students in the class
* User can view a list of students that share at least one class
* User can view a list of their current study buddies
* User can access other users' profiles to get their contact information
* User can have schedules compared to find common free time
* User can edit their profile
* User can view other students' schedules through their profile

**Optional Nice-to-have Stories**

* User can remove classes from their schedule
* User can send study requests to other students through the app
* User can find study groups for classes they are in
* User can coordinate and create study sessions through the app
* User can share locations with other users
* User can search for other users
* User can add other users as Facebook friends

### 2. Screen Archetypes

* Login screen
    * User can login to the app
* Registration screen
    * User can create a new account
* Stream
    * User can view their class schedule
    * User can remove classes from their schedule
* Stream 2
    * User can view a list of students that share at least one class
* Stream 3
    * User can view a list of their current study buddies
* Creation
    * User can add classes to their schedule
* Details
    * User can view a list of students in a particular class
    * User can access other users' profiles to get their contact information
    * User can have schedules compared to find common free time
    * User can edit their profile
    * User can view other students' schedules through their profile

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Schedule (Home screen)
* Suggested Study Buddies
* Current Study Buddies
* Profile

**Flow Navigation** (Screen to Screen)

* Login screen
    * => Home
* Registration screen
    * => Home
* Schedule
    * => Class details
    * => Class creation
* Suggested Buddies
    * => Other user's profile
* Current Study Buddies
    * => Other user's profile
* Profile
    * => None

## Wireframes
<img src="https://github.com/Zingsla/Study-Buddy/blob/master/BF069023-A068-474F-951E-41D953DFA050.jpeg" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
### Models
#### PFUser

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user (default field) |
   | username      | String   | unique login for the user (default field) |
   | password      | String   | encrypted password for logging in (default field) |
   | createdAt     | DateTime | date when post is created (default field) |
   | updatedAt     | DateTime | date when post is last updated (default field) |
   | email         | String   | the user's email address (default field) |
   | firstName     | String   | the user's first name |
   | lastName      | String   | the user's last name |
   | major         | String   | the user's major |
   | year          | Number   | year of college the student is in |
   | profileImage  | File     | the user's profile picture |
   | schedule      | Array    | array of TimeBlocks representing the user's class schedule |
   | buddies       | Array    | array of PFUsers representing the user's current buddies |
   
#### TimeBlock

   | Property      | Type     | Description |
   | --------------| ---------| ------------|
   | objectId      | String   | unique id for the timeblock (default field) |
   | createdAt     | DateTime | date when the timeblock is created (default field) |
   | updatedAt     | DateTime | date when the timeblock is last updated (default field) |
   | startTime     | DateTime | time of day the block starts |
   | endTime       | DateTime | time of day the block ends |
   | monday        | Boolean  | whether the block is active on Mondays |
   | tuesday       | Boolean  | whether the block is active on Tuesdays |
   | wednesday     | Boolean  | whether the block is active on Wednesdays |
   | thursday      | Boolean  | whether the block is active on Thursdays |
   | friday        | Boolean  | whether the block is active on Fridays |
   | saturday      | Boolean  | whether the block is active on Saturdays |
   | sunday        | Boolean  | whether the block is active on Sundays |
   | class         | Pointer to Class | the class represented by the timeblock (nil if timeblock is blockout) |
   
#### Class
   | Property      | Type     | Description |
   | --------------| ---------| ------------|
   | objectId      | String   | unique id for the user (default field) |
   | createdAt     | DateTime | date when the class is created (default field) |
   | updatedAt     | DateTime | date when the class is last updated (default field) |
   | className     | String   | the name of the class |
   | courseNumber  | String   | the course number for the class |
   | professorName | String   | the name of the professor for the class |
   | students      | Array    | array of PFUser's that are in this class |
   
### Networking
- Login Screen
      - (Read/GET) Login
         
         [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
         if (error != nil) {
             NSLog(@"Error logging in: %@", error.localizedDescription);
             //TODO: Show error alert
         } else {
             NSLog(@"Successfully logged in!");
             //TODO: Send user to home screen
         }
         }];
- Signup Screen
      - (Create/POST) Signup
        
        PFUser *newUser = [PFUser user];
    
        //TODO: Set user fields
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error signing up: %@", error.localizedDescription);
            //TODO: Show error alert
        } else {
            NSLog(@"Successfully registered user!");
            //TODO: Send user to home screen
        }
        }];
- Schedule Screen
      - (Read/GET) Get schedule
      - (Delete) Delete existing timeblock
- Class Creation Screen
      - (Create/POST) Create new timeblock
- Suggested Buddies Screen
      - (Read/GET) Get list of suggested buddies
- Current Buddies Screen
      - (Read/GET) Get list of current buddies
- Profile Screen
      - (Read/GET) Query logged in user
      - (Update/PUT) Update profile
- Class Details Screen
      - (Read/GET) Get list of students in class
- Person Details Screen
      - (Read/GET) Get student's schedule
