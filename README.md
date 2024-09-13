
## Running application 
``` bash
flutter run --dart-define-from-file=env/config_dev.json
```
Adjust file name according to your run env


## Generating code continuously for JSON and models
https://docs.flutter.dev/data-and-backend/serialization/json#generating-code-continuously

```bash
dart run build_runner watch --delete-conflicting-outputs
flutter pub run flutter_native_splash:create
```

## Swagger CodeGen
```bash
brew install swagger-codegen
```

## installing firebase cli
do not use curl from official doc, instead:
```bash
npm i -g firebase-tools
```

## Debugging Analytics with Debug Mode on Firebase
https://firebase.google.com/docs/analytics/debugview
https://console.firebase.google.com/project/testregister-ae4f8/analytics/app/android:com.example.flutter_application_2/debugview/realtime~2Fdebugview%3Ffpn%3D583974691550

```bash
-FIRAnalyticsDebugEnabled
-FIRDebugEnabled
```

Launch from Xcode, android studio/idea wont' work (https://github.com/flutter/flutter/issues/17043)