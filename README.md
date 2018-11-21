# reminder

This is a "reminder" app. It allows you to make repeating reminders for things 
that you do regularly. For example, I need to remember to give my dog flea 
medicine every month. I tap the flea medicine reminder whenever I give him is 
flea medicine and it keeps track of how long since the last time I gave him 
the flea medicine and adds a count down letting me know when I need to do it 
again.

It uses firestore, so you'll need to create a firestore database and files:
- assets/firestore.json
- android/app/google-services.json
- ios/Runner/GoogleService-Info.plist

The latter two files you will get from firestore and the first one needs to be of
the form:

```
{
    "googleAppID": "xxx",
    "gcmSenderID": "xxx",
    "apiKey": "xxx",
    "projectID": "xxx",
    "bundleID": "com.korbonix.reminder"
}
```

It makes sense to update the bundleID to something unique.

## Features

One thing I tried out with this app, was making the app fit the target platform
better than some of the other apps I've written. In `main.dart` if you update the
platform constant on line 22 you can force it to use material design or cupertino
widgets. If you set that constant to `null` it will match the platform you are 
running the app on.

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).
