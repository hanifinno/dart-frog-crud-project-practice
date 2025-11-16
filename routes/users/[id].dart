import 'dart:io';

import 'package:crud_project/repositories/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final userRepository = context.read<UserRepository>();
  final user = await userRepository.getUserById(id);
  if (user == null) {
    return Response(statusCode: 404, body: 'User not found.');
  }

  switch (context.request.method) {
    case HttpMethod.get:
      return Response.json(body: user.toJson());
    case HttpMethod.put:
      final body = await context.request.json() as Map<String, dynamic>;
      final name = body['name'] as String?;
      final email = body['email'] as String?;

      if (name == null || email == null) {
        return Response(
          statusCode: HttpStatus.badRequest,
          body: 'Name and email are required.',
        );
      }

      final updatedUser = await userRepository.update(id, name, email);
      return Response.json(body: updatedUser?.toJson());
    case HttpMethod.delete:
      await userRepository.deleteUser(id);
      return Response(statusCode: HttpStatus.noContent);
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.post:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
