# reminder

This is a "reminder" app. It allows you to make repeating reminders for things 
that you do regularly. For example, I need to remember to give my dog flea 
medicine every month. I tap the flea medicine reminder whenever I give him is 
flea medicine and it keeps track of how long since the last time I gave him 
the flea medicine and adds a count down letting me know when I need to do it 
again.

## Features

One thing I tried out with this app, was making the app fit the target platform
better than some of the other apps I've written. In `main.dart` if you update the
platform constant on line 22 you can force it to use material design or cupertino
widgets. If you set that constant to `null` it will match the platform you are 
running the app on.

### Cupertino Theme
![Cupertino Theme](screenshots/cupertino.png?raw=True)

### Android Theme
![Android Theme](screenshots/android.png?raw=True)

## Setup

You need to setup the datastore to get this app working. It can either
use firestore or it can use an in-memory database. Directions are as
follows.

### Firestore
To get this app working with firebase you need to setup firebase. Go to [firebase console](https://console.firebase.google.com/). There you can create firebase apps for iOS and Android. Put the iOS file `GoogleService-Info.plist` in the `ios` directory. Put the Android file `google-services.json` in the `android/app` directlry. Finally populate a `json` file at `assets/firestore.json` with the data:
```
{
    "googleAppID": "xxx",
    "gcmSenderID": "xxx",
    "apiKey": "xxx",
    "projectID": "xxx",
    "bundleID": "xxx"
}
```

### Memory
You can alternatively use this app with an in memory database (although you may still need to create some of the above mentioned files). To set it to use the in memory database change `_DatabaseProviderState.database` to be `DatabaseType.memory` in `lib/data/database_provider.dart`.