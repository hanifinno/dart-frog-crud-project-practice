// import 'dart:convert';
// import 'dart:io';

// import 'package:crud_project/models/user.dart';
// import 'package:crud_project/repositories/user_repository.dart';
// import 'package:dart_frog/dart_frog.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:test/test.dart';

// class _MockUserRepository extends Mock implements UserRepository {}

// class _MockRequestContext extends Mock implements RequestContext {}

// class _MockRequest extends Mock implements Request {}

// void main() {
//   group('onRequest /users/[id]', () {
//     late UserRepository userRepository;
//     late RequestContext context;
//     late Request request;

//     const userId = 'test-id';
//     const user = User(id: userId, name: 'Test User', email: 'test@example.com');

//     setUp(() {
//       userRepository = _MockUserRepository();
//       context = _MockRequestContext();
//       request = _MockRequest();

//       when(() => context.read<UserRepository>()).thenReturn(userRepository);
//       when(() => context.request).thenReturn(request);
//     });

//     group('GET', () {
//       test('responds with 200 OK and the user', () async {
//         // Arrange
//         when(() => request.method).thenReturn(HttpMethod.get);
//         when(() => userRepository.getUserById(userId)).thenReturn(user);

//         // Act
//         final response = await route.onRequest(context, userId);

//         // Assert
//         expect(response.statusCode, equals(HttpStatus.ok));
//         expect(response.json(), completion(equals(user.toJson())));
//       });

//       test('responds with 404 Not Found if user does not exist', () async {
//         // Arrange
//         when(() => request.method).thenReturn(HttpMethod.get);
//         when(() => userRepository.getUserById(userId)).thenReturn(null);

//         // Act
//         final response = await route.onRequest(context, userId);

//         // Assert
//         expect(response.statusCode, equals(HttpStatus.notFound));
//       });
//     });

//     group('PUT', () {
//       test('responds with 200 OK and the updated user', () async {
//         // Arrange
//         when(() => request.method).thenReturn(HttpMethod.put);
//         when(() => userRepository.getUserById(userId)).thenReturn(user);

//         final updatedUser = user.copyWith(name: 'Updated Name');
//         final body = {'name': updatedUser.name, 'email': updatedUser.email};

//         when(() => request.json()).thenAnswer((_) async => body);
//         when(() => userRepository.update(
//                 userId, updatedUser.name, updatedUser.email))
//             .thenReturn(updatedUser);

//         // Act
//         final response = await route.onRequest(context, userId);

//         // Assert
//         expect(response.statusCode, equals(HttpStatus.ok));
//         expect(response.json(), completion(equals(updatedUser.toJson())));
//       });

//       test('responds with 400 Bad Request if body is invalid', () async {
//         // Arrange
//         when(() => request.method).thenReturn(HttpMethod.put);
//         when(() => userRepository.getUserById(userId)).thenReturn(user);
//         when(() => request.json()).thenAnswer((_) async => {'name': 'Test'});

//         // Act
//         final response = await route.onRequest(context, userId);

//         // Assert
//         expect(response.statusCode, equals(HttpStatus.badRequest));
//       });
//     });

//     group('DELETE', () {
//       test('responds with 204 No Content on success', () async {
//         // Arrange
//         when(() => request.method).thenReturn(HttpMethod.delete);
//         when(() => userRepository.getUserById(userId)).thenReturn(user);
//         when(() => userRepository.deleteUser(userId)).thenAnswer((_) async {});

//         // Act
//         final response = await route.onRequest(context, userId);

//         // Assert
//         expect(response.statusCode, equals(HttpStatus.noContent));
//         verify(() => userRepository.deleteUser(userId)).called(1);
//       });
//     });
//   });
// }
