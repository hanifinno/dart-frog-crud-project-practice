// lib/mongo_viewer.dart
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:convert';

class MongoService {
  factory MongoService() => _instance;
  MongoService._internal();
  static final MongoService _instance = MongoService._internal();

  late Db _db;
  late DbCollection usersCollection;

  Future<void> connect() async {
    const uri =
        'mongodb+srv://hanifuddindev_db_user:1234@cluster0.xqn6yfp.mongodb.net/crud_project?retryWrites=true&w=majority';

    print('Connecting to Atlas (+srv)...');
    _db = await Db.create(uri);
    await _db.open(secure: true);
    usersCollection = _db.collection('users');
    print('Connected!');
  }

  Future<void> disconnect() async {
    await _db.close();
    print('Disconnected');
  }

  Future<List<String>> listCollections() async {
    final raw = await _db.listCollections();
    return raw
        .map((c) => (c as Map<String, dynamic>)['name'] as String)
        .toList();
  }

  Future<void> dumpUsersTable() async {
    final cursor = usersCollection.find();
    print('\nUSERS TABLE (collection: users)');
    print('=' * 50);
    int idx = 1;
    bool hasData = false;
    await for (final doc in cursor) {
      hasData = true;
      print('\n$idx. ${doc.toJsonPretty()}');
      idx++;
    }
    if (!hasData) print('No documents found.');
    print('=' * 50);
  }
}

extension PrettyJson on Map<String, dynamic> {
  String toJsonPretty() {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(this);
  }
}

Future<void> main() async {
  final mongo = MongoService();
  try {
    await mongo.connect();
    final collections = await mongo.listCollections();
    print('Collections: $collections');
    await mongo.dumpUsersTable();
  } catch (e) {
    print('Error: $e');
  } finally {
    await mongo.disconnect();
  }
}
