# Route To Do

Visiting a new city? Want to discover a new neighborhood? Or maybe do something
different this weekend? Route to Do is here to help you. It's a mobile app that allows
you to discover, share and rate sets of three places to visit. Have a favorite bar
hopping route? You can share it with your friends. Want to check some landscapes?
Check Route to Do. Someone already shared that route.

## User Stories

The following **required** functionality is completed:

[Interactive wireframes](http://ios-route-to-do.github.io/app/wireframes/index.html)

- [ ] Splash screen

- [ ] Category selection view: What type of route does the user wants to do (dance, dinner, drinks, etc) [wireframe](wireframes/static/2-0-CategoryPick.png)
  - [ ] Navigation bar:
    - [ ] Back button to select location view
  - [ ] Content view:
    - [ ] Collection view with all the categories: background picture and name
    - [ ] Navigate to selected category on tap

- [ ] Category view [wireframe](wireframes/static/3-0-CategoryHome.png)
  - [ ] Navigation bar:
    - [ ] Search button for specific route/place search
    - [ ] Reset location button
    - [ ] Navigation buttons with:
      - [ ] Category Home section
      - [ ] My profile view
  - [ ] Content view:
    - [ ] Carousel of trending routes with:
      - [ ] Label with "Trending now in {location name}"
      - [ ] Route detail: background image, name, location, creator name, favorites count and rating
    - [ ] Collection view of new routes
      - [ ] Label with "What's new" text
      - [ ] Route detail: background image, name and location

- [ ] Route Cover View: presentation of the route and starting point check the route [wireframe](wireframes/static/4-0-RouteCoverView.png)
  - [ ] Top bar with:
    - [ ] Back button: goes back in navigation flow
    - [ ] Favorite button: Marks/Unmarks route as favorite for the current user
    - [ ] Share button: Implementation of this is optional
  - [ ] Route image on the background
  - [ ] Bottom panel with:
    - [ ] Route title, general location, author, amount of users that visited, rating score
    - [ ] Scrolling description of the route
    - [ ] List of three locations to visit
    - [ ] Start route button

- [ ] Route Progress View: presentation of the route on a map and current place [wireframe step 1](wireframes/static/5-0-RouteStepView1.png) [wireframe step 2](wireframes/static/6-0-RouteStepView2.png) [wireframe step 3](wireframes/static/7-0-RouteStepView3.png)
  - [ ] Top bar with:
    - [ ] Back button: goes back in navigation flow
    - [ ] Favorite button: Marks/Unmarks route as favorite for the current user
    - [ ] Share button: Implementation of this is optional
  - [ ] Map with:
    - [ ] Current location of user visible if user is not on the route location
    - [ ] Current route location with a special marker
    - [ ] Previous route location (if on step 2 or 3)
    - [ ] Next route location (if on steps 1 or 2)
    - [ ] Curved line connecting all previous dots in correct order. This line is not
    meant to be a direction trajectory but a simplification to express route's progress
  - [ ] Bottom panel with:
    - [ ] Place title, place location
    - [ ] Scrolling description of the place
    - [ ] Go Next button (if on steps 1 or 2)
    - [ ] Rate this route (if on steps 3)

- [ ] Rate Route View: Modal presentation with a rating widget [wireframe](wireframes/static/8-0-RouteRate.png)
  - [ ] When user clicks on rate this route, he's presented with the home screen and
  a modal widget to rate the route. This widget contains:
  - [ ] Route Title, Route location and Author
  - [ ] Five star rating widget
  - [ ] Split bottom bar with two buttons: Cancel and Submit

- [ ] Profile View: details of the user [wireframe tab 1](wireframes/static/9-0-Profile-Favorites.png) [wireframe tab 2](wireframes/static/10-0-Profile-NightsOut.png) [wireframe tab 3](wireframes/static/11-0-Profile-MyRoutes.png)
  - [ ] Show avatar, username
  - [ ] Show location, count of owned routes and count of nights out
  - [ ] Tab selector for:
    - [ ] Favorites
    - [ ] Nights out
    - [ ] My Routes

The following **optional** features are implemented:

- [ ] Select location view after splash screen: Ask the user for the location to focus the search
  - [ ] Map view asking for the user location
  - [ ] Navigate to category selection view on location tap

- [ ] Category view:
  - [ ] Content view:
    - [ ] Button for adding a new route

- [ ] Route Cover View:
  - [ ] Top bar with:
    - [ ] Share button: Share with friends on Twitter or Facebook

- [ ] Add Route Views
  - Add route action in main view
  - [ ] Screen 1 - route picture
    - Pick one or multiple pictures (from library / new picture)
  - [ ] Screen 2 - route description
    - Set Title
    - Set City
    - Set Description
  - [ ] Screen 3 - add locations
    - Search bar
    - search results in map
    - search results in list
    - pick / add up to 3 locations
  - [ ] Screen 4 - review route
    - Review route
    - Publish route action

- [ ] Edit profile View
  - Set profile name and last name
  - Set profile picture
  - Set profile location

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!

# Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='assignment.gif' title='Video Walkthrough' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## License

    Copyright 2015 <to be completed>

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
