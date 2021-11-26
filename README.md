# PopUp Rooms project - iOS Application

iOS application written in Swift used to display the list of Pop Up Rooms and their status, fetched from the Back End server. This app was developed as a free time, extra project for our class Pop Up Rooms project in Haaga-Helia.

Runs best on iOS 15.


## Setup



### Source Data URL

The source data URL must be specified inside the **RoomData.swift** file. It is stored as an URL object, created with the url passed as a **String**.

The variable referencing the object must be named `apiURL`.


## Documentation

The basic sturcture of the application and its functioning is well explained in the comments on the source code files. Additional information is contained in this readme, including what is expected from the used Back-End.


## Back End Communication and fetching Data

It communicates with the Back End of our project (found [here](https://github.com/Popup-Meeting-Rooms-Project/Backend)) which serves the clients with the required data through a REST API.

### Data Format

Data provided by the Back End REST API must be in JSON form and follow these models:
- Room Object (must at least contain the following, may contain additional fields which will be disregarded).
```json
{
  "id": number,
  "room_name": string,
  "building_floor": number,
  "detected": boolean
 }
 ```
