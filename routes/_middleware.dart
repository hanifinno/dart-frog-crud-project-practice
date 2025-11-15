import 'package:crud_project/repositories/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';

// Create a single instance of the repository.
final _userRepository = UserRepository();

Handler middleware(Handler handler) {
  // Provide the repository instance to the request context.
  return handler.use(provider<UserRepository>((_) => _userRepository));
}
