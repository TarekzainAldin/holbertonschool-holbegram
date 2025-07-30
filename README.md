Hello Holbies welcome to the final Flutter Project. It’s going to be special and I hope that you have fun doing it.

In general, developing a mobile application is a complex and challenging task. There are many frameworks available to develop a mobile application. Android provides a native framework based on Java language and iOS provides a native framework based on Objective-C / Shift language. However, to develop an application supporting both the OS’s, we need to code in two different languages using two different frameworks. To solve this problem there is Flutter – a simple and high-performance framework based on Dart language that provides high performance by rendering the UI directly in the operating system’s canvas rather than through the native framework.

To lighten up your mood get you ready for this amazing project you can start by clicking on this LINK

I know it might be very challenging to do such a project with limited knowledge in flutter but we are Holberton students and WE CAN DO ANYTHING. I believe in you guys

Let’s begin the Journey.

Resources
Read or watch:

Dart - Cheatsheet
FlutterFire Overview
Getting started with Firebase on Flutter
Get Started with Firebase Authentication on Flutter
Cloud Storage on Flutter
Layouts in Flutter
Introduction to widgets
Cloudinary Storage Images uploading | Flutter
Every Flutter Widgets

Every Flutter Widget Explained
Dependencies
Firebase Database Plugin for Flutter
Firebase Auth for Flutter
Cupertino Icons
Image Picker plugin for Flutter
BottomNavyBar
provider
Uuid
Cached network image
Flutter Pull To Refresh
Requirements
Create your project :

Open you’re command-line tool

flutter create holbegram
cd holbegram
flutter run
Step up your Firebase

For the backend, we are going to use Firebase(Firebase is a Backend-as-a-Service (BaaS) app development platform that provides hosted backend services such as (a real-time database, cloud storage, authentication, crash reporting, machine learning, remote configuration) and hosting for your static files. However, for storing and managing images, we will use Cloudinary, which is a cloud service that provides an easy-to-use solution for managing images and videos, including features for storing, transforming, and delivering media content. Cloudinary will handle the storage and retrieval of image files, while Firebase will handle the authentication and database functionalities.

Let’s start…

go to https://firebase.google.com/ and create an account then Let’s create a new project in firebase.

Go to Firebase Console and click Add Project and then you have to go through some steps.

First, we are going to build a fire_base app called holbegram:



Second Disable Google Analytics for this project:



Authentication

Click on Enable the Authentication: Enable the Email/Password







Database

Well done! Now you are going to move to the next task which is creating a database.

To do that follow the following steps:

1- Go to Firestore Database then click on Create Database.

2- Choose “start in test mode”



3- choose the location that is close to you.



4- Go to rules:



Finally, press Publish

Adding Firebase to our App

So now let’s add Firebase to our app:

If you want to use Android Follow the Android Support

If you want to work with iOS follow the iOS Support

Adding Android support
Registering the App

In order to add Android support to our Flutter application, select the Android logo from the dashboard. This brings us to the following screen:



The most important thing here is to match up the Android package name that you choose here with the one inside of our application.

The structure consists of at least two segments. A common pattern is to use a domain name, a company name, and the application name:

com.example.holbegram

Once you’ve decided on a name, open android/app/build.gradle in your code editor and update the applicationId to match the Android package name:

Example of File android/app/build.gradle

...
defaultConfig {
    // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
    applicationId 'com.example.holbegram'
    ...
}
...
You can skip the app nickname and debug signing keys at this stage. Select Register app to continue.

Downloading the Config File

The next step is to add the Firebase configuration file into our Flutter project. This is important as it contains the API keys and other critical information for Firebase to use.

Select Download google-services.json from this page:



Next, move the google-services.json file to the android/app directory within the Flutter project.

Adding the Firebase SDK

We’ll now need to update our Gradle configuration to include the Google Services plugin.

Open android/build.gradle in your code editor and modify it to include the following:

Example of File android/build.gradle

buildscript {
  repositories {
    // Check that you have the following line (if not, add it):
    google()  // Google's Maven repository
  }
  dependencies {
    ...
    // Add this line
    classpath 'com.google.gms:google-services:4.3.13'
  }
}

allprojects {
  ...
  repositories {
    // Check that you have the following line (if not, add it):
    google()  // Google's Maven repository
    ...
  }
}
Finally, update the app level file atandroid/app/build.gradle to include the following:

Example of File android/app/build.gradle

apply plugin: 'com.android.application'
// Add this line
apply plugin: 'com.google.gms.google-services'

dependencies {
  // Import the Firebase BoM
 implementation platform('com.google.firebase:firebase-bom:30.2.0')

  // Add the dependencies for any other desired Firebase products
  // https://firebase.google.com/docs/android/setup#available-libraries
}
With this update, we’re essentially applying the Google Services plugin as well as looking at how other Flutter Firebase plugins can be activated such as Analytics.

From here, run your application on an Android device or simulator. If everything has worked correctly, you should get the following message in the dashboard:



Adding iOS support
In order to add Firebase support for iOS, we have to follow a similar set of instructions.

Head back over to the dashboard and select Add app and then iOS icon to be navigated to the setup process.

Registering an App

You Should have Xcode installed in your PC:

Once again, we’ll need to add an “iOS Bundle ID”. It is possible to use the “Android package name” for consistency:



You’ll then need to make sure this matches up by opening the iOS folder up in Xcode



General


Now go back to your firebase and add the iOS Bundle ID

after that Download the configuration file

Downloading the Config File

Drag and Drop the file GoogleService-Info.plist and move this into the root of your Xcode project within Runner:





Be sure to move this file within Xcode to create the proper file references.