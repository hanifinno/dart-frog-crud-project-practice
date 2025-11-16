import 'package:crud_project/repositories/user_repository.dart';
import 'package:crud_project/services/mongo_service.dart';
import 'package:dart_frog/dart_frog.dart';

// Create a single instance of the repository.
final _mongoService = MongoService();
final _userRepository = UserRepository(_mongoService);

Handler middleware(Handler handler) {
  // Provide the service and repository instances to the request context.
  return handler.use(provider<UserRepository>((_) => _userRepository));
}
