import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/data/task/response_models/task_model.dart';
import 'package:todo_app/models/task.dart';

void main() {
  group('Test get task model from json', () {
    test('The task item should be parse from json', () {
      final json = {
        "123": {
          "id": "123",
          "createdAt": "2022-05-18T17:19:40.773",
          "desc": "doing math homework",
          "expiredAt": "2022-05-18T17:19:40.773",
          "name": "do homework",
          "status": "complete"
        }
      };
      final task = TaskModel.fromJson(json.keys.first, json.values.first);
      expect(task.name, 'do homework');
    });

    test('The list tasks should be parse from json', () {
      final json = {
        "data": {
          "123": {
            "id": "123",
            "createdAt": "2022-05-18T17:19:40.773",
            "desc": "doing math homework",
            "expiredAt": "2022-05-18T17:19:40.773",
            "name": "do homework",
            "status": "complete"
          },
          "124": {
            "id": "124",
            "createdAt": "2022-05-19T17:19:40.773",
            "desc": "picnic on centrel park",
            "expiredAt": "2022-05-19T17:19:40.773",
            "name": "picnic",
            "status": "incomplete"
          },
          "125": {
            "id": "125",
            "createdAt": "2022-05-20T17:19:40.773",
            "desc": "Ceremony party",
            "expiredAt": "2022-05-20T17:19:40.773",
            "name": "Take part in party",
            "status": "complete"
          }
        }
      };
      final tasks = List<Task>.from((json['data'] as Map<dynamic, dynamic>)
          .entries
          .map((e) => TaskModel.fromJson(e.key as String, e.value as Map<dynamic, dynamic>)));
      expect(tasks.length, 3);
    });
  });
}
