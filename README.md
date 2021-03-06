# TopTenList

Simple application showing Top 10 rated movies and tv shows from the The Movie Database (https://www.themoviedb.org/). 
A search feature which allows for searching of movies and tv shows from the whole database (not just the lists) is also implemented.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 

### Prerequisites

What is needed in order to build and run the app:
```
- Xcode Version 10.0
```
```
- Mac running macOS 10.13.6 or later.
```

### Build and Run the TopTenList app

5 simple steps for launching the application locally:

```
1. Click on the green "Clone or Download" button.
```
```
2. Click on "Open in Xcode". Save it to the desired location on your computer.
```
```
3. The computer opens the project in Xcode automatically. 
   (If it does not, open the TopTenList folder, and select TopTenList.xcworkspace)
```
```
4. Select the desired iOS simulator and press the "play" button. This launches the application. 
```
```
5. That´s it! Explore the app! 
```

### Note
The reason why I added the scope bar through the storyboard, and not programatically is that there is some problems with the animation regarding showing and dismissing the scopebar (it either dissapears completely or overlays the searchbar), which makes for a bad UI experience. This is probably some Xcode version 10.0 bug.

Since I added the scope bar through the storyboard, the searchbar does not go to the top automatically when scrolling the table, as it would have if it was programatically attached to the searchbar in the navigation item. However, because of the mentioned bug, this was the best solution I found. 
