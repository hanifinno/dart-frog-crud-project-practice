import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:crud_project/services/mongo_service.dart';

Future<HttpServer> onServerStart(
  Handler handler,
  InternetAddress ip,
  int port,
) async {
  await MongoService().connect();
  return serve(handler, ip, port);
}

Future<void> onServerStop(HttpServer server) async {
  await MongoService().disconnect();
  await server.close();
}
