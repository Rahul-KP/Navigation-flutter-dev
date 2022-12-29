import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoRes {
  late final String username;
  late final String pass;
  late final Db db;

  void connect() async {
    await dotenv.load(fileName: "credentials.env");
    username = dotenv.env["mongo.username"]!;
    pass = dotenv.env["mongo.password"]!;
    db = await Db.create('mongodb+srv://' +
        username +
        ':' +
        pass +
        '@cluster0.fg98e.mongodb.net/flutter_test?retryWrites=true&w=majority');
    Fluttertoast.showToast(msg: "Connected to MongoDB Cluster");
  }
}
