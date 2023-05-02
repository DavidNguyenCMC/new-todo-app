import 'package:grpc/grpc.dart';
import 'package:server/src/service/todo_service.dart';

void main(List<String> arguments) async {
  final server = Server([TodoService()]);
  await server.serve(port: 8000);
  print('server opened on port: ${server.port}');
}
