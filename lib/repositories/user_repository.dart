import 'package:crud_project/models/user.dart';
import 'package:uuid/uuid.dart';

/// A repository that handles user data.
class UserRepository {
  final Map<String, User> _users = <String, User>{};
  final _uuid = const Uuid();

  /// Creates a new user with the given [name] and [email].
  User createUser(String name, String email) {
    final user = User(id: _uuid.v4(), name: name, email: email);
    _users[user.id] = user;
    return user;
  }

  /// Returns a list of all users.
  List<User> getAllUsers() {
    return _users.values.toList();
  }

  /// Returns a user with the given [id].
  ///
  /// Returns `null` if no user with the given [id] is found.
  User? getUserById(String id) {
    return _users[id];
  }

  /// Updates the user with the given [id] to have the new [name] and [email].
  ///
  /// Returns the updated user.
  /// Returns `null` if no user with the given [id] is found.
  User? update(String id, String name, String email) {
    if (!_users.containsKey(id)) {
      return null;
    }
    final updatedUser = User(id: id, name: name, email: email);
    _users[id] = updatedUser;
    return updatedUser;
  }

  /// Deletes the user with the given [id].
  void deleteUser(String id) {
    _users.remove(id);
  }
}
