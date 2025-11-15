import 'dart:io';
import 'dart:convert';

import 'package:crud_project/models/user.dart';
import 'package:crud_project/repositories/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../routes/index.dart' as route;

class _MockUserRepository extends Mock implements UserRepository {}

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

void main() {
  group('GET /', () {
    late UserRepository userRepository;
    late RequestContext context;

    setUp(() {
      userRepository = _MockUserRepository();
      context = _MockRequestContext();
      final request = Request.get(Uri.parse('http://localhost:8080/'));
      when(() => context.read<UserRepository>()).thenReturn(userRepository);
      when(() => context.request).thenReturn(request);
    });

    test('responds with 200 OK and a list of users', () async {
      // Arrange
      const users = [
        const User(id: '1', name: 'Test User', email: 'test@example.com'),
      ];
      when(() => userRepository.getAllUsers()).thenReturn(users);

      // Act
      final response = await route.onRequest(context);

      // Assert
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.json(),
          completion(equals(users.map((e) => e.toJson()).toList())));
    });
  });

  group('POST /', () {
    late UserRepository userRepository;
    late RequestContext context;
    late Request request;

    setUp(() {
      userRepository = _MockUserRepository();
      context = _MockRequestContext();
      request = _MockRequest();
      when(() => context.read<UserRepository>()).thenReturn(userRepository);
      when(() => context.request).thenReturn(request);
      when(() => request.method).thenReturn(HttpMethod.post);
    });

    test('responds with 201 Created and the new user', () async {
      // Arrange
      const name = 'Test User';
      const email = 'test@example.com';
      final body = {'name': name, 'email': email};
      const createdUser = User(id: '1', name: name, email: email);
      when(() => request.json()).thenAnswer((_) async => body);
      when(() => userRepository.createUser(name, email))
          .thenReturn(createdUser);

      // Act
      final response = await route.onRequest(context);

      // Assert
      expect(response.statusCode, equals(HttpStatus.created));
      expect(
        response.json(),
        completion(equals(createdUser.toJson())),
      );
    });
  });
}
