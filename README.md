# Clutch Zip Codes

This simple iOS app is designed to fetch a series of zip codes in a given radius and display them as a list. The app is designed as a take home project for [Clutch Technologies](https://www.driveclutch.com), and should work on all iOS devices running iOS 9.0+. 

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

This app uses Cocoapods as dependencies, and will fail to compile without them. Instructions for installing the base CocoaPods program can be found here: [Getting Started](https://guides.cocoapods.org/using/getting-started.html#getting-started).

### Installing

Once CocoaPods is installed, you can clone the repo and navigate to the root directory of the project. From there, you should be able to run the following command to install the project's dependencies. 

```
pod install
```

As per the instructions in a successful pod install, shut down all instances of XCode and open the xcworkspace file that was created in the root directory of the repository. You may need to build the project a couple of times until there is no error for the missing dependencies.

## Running the app

Click your desired simulator or connected device in the dropdown next to the stop button in XCode, and then click the Run button.

## Built With

* [SwiftyJSON](https://cocoapods.org/pods/SwiftyJSON) - Library for parsing JSON

## Further Considerations

Some possible improvements to the project include, but are not limited to:

1. Make the UI more attractive with AutoLayout and colors
2. Display networking progress in a user friendly manner (like a progress indicator)
3. Research better ways to implement the API Key within the code
4. Discuss with Ben whether JSON parsing should occur in ViewController or in a separate dependency.



<!-- ## Versioning -->

<!-- I use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags).  -->

## Authors

* **Seth Mosgin** - *Initial work* - [smosgin](https://github.com/smosgin)

<!-- See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project. -->

<!-- ## License -->

<!-- This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details -->

## Acknowledgments

* Zip Code results provided by [Zip Code API](https://www.zipcodeapi.com)
* Thank you to Sang and Ben at Clutch Technologies for providing this fun project idea

