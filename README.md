# MEMORIZ - Capstone Project, Udacity iOS Developer Nanodegree. 
***Memoriz*** is a simple app that allows users to preserve memorable events of their life. Users will be able to remember the exact location where an event happened, pictures taken at the location and text description of the details attached to the event.


## How it works
- Users can post pin on a mapview by longpressing the location of their choice. 
- Each pin is clickable and once a pin is clicked, a new view is presented to the user where they can add images attached to the location from the photo library.
- The images are displayed in a collection view and are clickable.
- If an image is selected, another view is presented to the user with only the selected image and a text field where the user can input a decription for the image. At the top of this view is a non- editable text field that displays random quotes to the users. 

## Project Overview
- This project was built using UIKit components in Xcode.
- This project incorporate data from a network source by calling the `Zenquote.io` API. This data was parsed using JSONDecoder and appropriate error is displayed to the user whenever there is a problem fetching data from the network. 
- Data is persisted in the app using Core Data and UserDefaults. 

## Requirements
- Basic to intermediate proficieny with Xcode and Swift
- iOS 15
