// ignore_for_file: no_default_cases

import 'dart:io';

import 'package:crud_project/repositories/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  final userRepository = context.read<UserRepository>();
  switch (context.request.method) {
    case HttpMethod.get:
      final users = userRepository.getAllUsers();
      final usersJson = users.map((user) => user.toJson()).toList();
      return Response.json(body: usersJson);
    case HttpMethod.post:
      final body = await context.request.json() as Map<String, dynamic>;
      final name = body['name'] as String?;
      final email = body['email'] as String?;

      if (name == null || email == null) {
        return Response(
          statusCode: HttpStatus.badRequest,
          body: 'Name and email are required.',
        );
      }

      final newUser = userRepository.createUser(name, email);
      return Response.json(
        statusCode: HttpStatus.created,
        body: newUser.toJson(),
      );
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
