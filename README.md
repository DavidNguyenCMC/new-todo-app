🚀 Video demo
  - Mobile:
  https://user-images.githubusercontent.com/130980158/232953070-c319d7ef-530d-4989-9ebb-9fedb8592178.mp4
  - Web:
  https://user-images.githubusercontent.com/130980158/235577085-06319e35-4307-4d04-9993-d44924a8f9ed.mp4

🚀 Run test:
- Unit test: check directory test/unit_test
- Integration test: 
  + run file app_test in directory test/integration_test.
  + We can run below scrip (or you can run it in file execute_integration.sh in test/utils directory) to run with UI on simulator or real device:
    flutter drive \
  --driver=test/integration_test/test_driver/integration_test_driver.dart \
  --target=test/integration_test/app_test.dart
  
  - Screen record run inegration test
https://user-images.githubusercontent.com/130980158/235578091-ed99b64d-d735-43c1-8e6f-ae422ddceb63.mp4


  
🚀 In this application we are using gRPC in mobile app, and firebase on web application.
🚀 To run gRPC service in local:
  - Install protoc_plugin before run, check this link: https://grpc.io/docs/languages/dart/quickstart/
  - run this script in terminal: dart .\bin\server.dart 

# Config before run app
- flutter packages pub run build_runner build
- or: flutter packages pub run build_runner build --delete-conflicting-outputs
- Preference > Editor > Code Style > Dart > Line Length: 100
