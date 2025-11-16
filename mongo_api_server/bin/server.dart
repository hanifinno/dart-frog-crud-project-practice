// bin/server.dart
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:mongo_dart/mongo_dart.dart';

void main() async {
  // CORRECT URI - ONLY ONE mongodb+srv://
  final db = Db(
      'mongodb://hanifuddindev_db_user:1234@cluster0.xqn6yfp.mongodb.net/crud_project?retryWrites=true&w=majority');

  //mongodb+srv://hanifuddindev_db_user:<db_password>@cluster0.xqn6yfp.mongodb.net/

  print('Connecting to MongoDB...');
  await db.open();
  print('Connected!');

  final users = db.collection('users');
  final app = Router();

  // POST /api/users
  app.post('/api/users', (Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      if (data['name'] == null || data['email'] == null) {
        return Response(400,
            body: jsonEncode({'error': 'name and email required'}));
      }

      final result = await users.insertOne({
        ...data,
        'createdAt': DateTime.now().toIso8601String(),
      });

      return Response.ok(
        jsonEncode({'message': 'User created!', 'id': result.id.toHexString()}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({'error': e.toString()}));
    }
  });

  // GET /api/users
  app.get('/api/users', (Request request) async {
    final list = await users.find().toList();
    return Response.ok(
      jsonEncode(list),
      headers: {'Content-Type': 'application/json'},
    );
  });

  await shelf_io.serve(app, 'localhost', 8080);
  print('API running at http://localhost:8080');
  print('POST → http://localhost:8080/api/users');
}
