🚀 # Video demo
  - Mobile:
  https://user-images.githubusercontent.com/130980158/232953070-c319d7ef-530d-4989-9ebb-9fedb8592178.mp4
  - Web:
  https://user-images.githubusercontent.com/130980158/235577085-06319e35-4307-4d04-9993-d44924a8f9ed.mp4
  
🚀 # Config before run app
- flutter packages pub run build_runner build
- or: flutter packages pub run build_runner build --delete-conflicting-outputs
- Preference > Editor > Code Style > Dart > Line Length: 100

🚀 # Run test:
- Unit test: check directory test/unit_test
- Integration test: 
  + run file app_test in directory test/integration_test.
  + We can run below scrip (or you can run it in file execute_integration.sh in test/utils directory) to run with UI on simulator or real device:
    flutter drive \
  --driver=test/integration_test/test_driver/integration_test_driver.dart \
  --target=test/integration_test/app_test.dart
  
  - Screen record run inegration test
https://user-images.githubusercontent.com/130980158/235578091-ed99b64d-d735-43c1-8e6f-ae422ddceb63.mp4

  
🚀 # In this application we are using gRPC in mobile app, and firebase on web application.
🚀 # To run gRPC service in local:
  - Install protoc_plugin before run, check this link: https://grpc.io/docs/languages/dart/quickstart/
  - run this script in terminal: dart .\bin\server.dart 

🚀 Note: gRPC only work on mobile for now because web need gRPC-web server(it's not support for dart now, we can use another server). So in web we can use firebase instead.
 
🚀 # Run Docker
- Create the Container
- To get the container running, we first have to build an image:
  docker build -t flutter-web .

This builds an image called flutter-web and uses the current directory as the context for the Dockerfile
If everything completed successfully, we then run the container:
  docker run -d -p 8080:80 --name flutter-web flutter-web 

- Now, if you navigate to http://localhost:8080, you should see the flutter app.
- When you want to stop it, run:
  docker stop flutter-web

🚀 ## <a name="architecture-of-boilerplate">#</a> 🙌 Architecture of boilerplate

#### Boilerplate using Clean Architecture

- Advantages of using this architecture
    - Easier to modify
    - Easier to test
    - Easier to detect bugs & errors
- There are three main categories in a clean architecture structure;
    - Data ⇨ Local and / or Remote(API) data sources
    - Domain ⇨ business logic(use cases) and business objects(entities) to modify or shape the data source
    - Presentation ⇨ How modified data source is shown to user
<br/>
## <a name="folder-structure">#</a> 🚪 Folder Structure

Here is the core folder structure which flutter provides.

```
flutter-app/
|- android
|- build
|- ios
|- lib
|- test
|- server
|- web
|- protos
```

Here is the folder structure we have been using in this project

```
lib/
|- common
|- configs
|- data
|- domain
|- di
|- infrastructure
|- pages
|- routers
|- main.dart
|- main_common.dart
```

Now, lets dive into the lib folder which has the main code for the application.

```
1- data - Local and / or Remote(API) data sources, raw model from data source, mapper(Map Entity objects to Models and vice-versa)
2- domain - Business logic and business objects(entities) to modify or shape the data source.
3- di - Initialize the objects and the dependency injection module.
4- pages - How modified data source is shown to user.
5- infrastructor - contain all of framework that using on application
6- routers - Routes folder containing routes for the app.
7- common - Folders manage constants, helpers, extensions,...
8- main_common.dart - Method injection flavor for target file main_production.dart and main_staging.dart.
```
