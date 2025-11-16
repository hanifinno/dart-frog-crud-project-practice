import 'package:crud_project/models/user.dart';
import 'package:crud_project/services/mongo_service.dart';
import 'package:uuid/uuid.dart';

/// A repository that handles user data.
class UserRepository {
  /// Creates a new instance of the [UserRepository].
  UserRepository(this._mongoService);

  final MongoService _mongoService;

  /// Creates a new user with the given [name] and [email].
  Future<User> createUser(String name, String email) async {
    final User user = User(id: const Uuid().v4(), name: name, email: email);
    await _mongoService.usersCollection.insertOne(user.toJson());
    return user;
  }

  /// Retrieves all users.
  Future<List<User>> getAllUsers() async {
    final users = <User>[];
    final results = _mongoService.usersCollection.find();
    await for (final result in results) {
      users.add(User.fromJson(result));
    }
    return users;
  }

  /// Retrieves a user by their [id].
  Future<User?> getUserById(String id) async {
    final result = await _mongoService.usersCollection.findOne({'id': id});
    if (result == null) {
      return null;
    }
    return User.fromJson(result);
  }

  /// Updates the user with the given [id] to have the new [name] and [email].
  Future<User?> update(String id, String name, String email) async {
    final updatedUser = User(id: id, name: name, email: email);
    final result = await _mongoService.usersCollection.replaceOne(
      {'id': id},
      updatedUser.toJson(),
    );
    if (result.isSuccess && result.nModified == 1) {
      return updatedUser;
    }
    return null;
  }

  /// Deletes the user with the given [id].
  Future<void> deleteUser(String id) async {
    await _mongoService.usersCollection.deleteOne({'id': id});
  }
}
