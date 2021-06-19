# firestore_crud
```
flutter create --org com.eric -i objc -a java firestore_crud

flutter build apk --release
```

* choose a project in https://console.firebase.google.com/u/0/ 
* Register new App with package `com.eric.firestore_crud`
* get file `google_services.json` at https://console.firebase.google.com/u/0/project/flutterproject-57085/overview
* per 19 juni 21, minimum Android SDK is 23
* drop it into `android/app`
* WAJIB buat SHA fingerprint di package yg udah ditentukan (misal `com.eric.firestore_crud`). SHA-1 ini merujuk pada file keystore **DEBUG** atau **PROD** jd pastikan dulu file `.keystore` yg mau diregister.
Kalau debug, flutter menggunakan file yg sama dengan Android Studio.

To get fingerprint, run following :
```
$ keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore
Enter keystore password: android
...

Certificate fingerprints:
         SHA1: 4F:D1:...
         SHA256: C9:C1:...
```
COPAS the value of SHA1 to related package, ex: `com.eric.firebase_login` :
```
https://console.firebase.google.com/u/0/project/flutterproject-57085/settings/general/android:com.eric.firestore_crud
```
Dont forget to SAVE !

* Finally, create database here https://console.firebase.google.com/u/0/project/flutterproject-57085/firestore

---
## Android Native Setup

android/app/build.gradle
```
apply plugin: 'com.google.gms.google-services'

android {
    defaultConfig {
        minSdkVersion 23
        multiDexEnabled true
    }
```

android/build.gradle
```
buildscript {
    repositories {
        ...
    }

    dependencies {
        ...
        classpath 'com.google.gms:google-services:4.3.8'
    }
```

---
## pubspec.yml per 19-Jun-21
```
  firebase_core:
  cloud_firestore:
```

## FAT APK
+/- 38 MBytes


---
## References
https://github.com/sbis04/flutterfire-samples/tree/crud-firestore/lib/screens

https://medium.com/flutter-community/flutter-crud-operations-using-firebase-cloud-firestore-a7ef38bbf027

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.me/ellkana)