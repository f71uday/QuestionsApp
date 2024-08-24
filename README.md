
## Running application 
``` bash
flutter run --dart-define-from-file=env/config_dev.json
```
Adjust file name according to your run env


## Generating code continuously for JSON and models
https://docs.flutter.dev/data-and-backend/serialization/json#generating-code-continuously

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Swagger CodeGen
```bash
brew install swagger-codegen
```