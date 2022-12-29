import 'package:AmbiNav/shared_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoRes {
  late final String username;
  late final String pass;
  late final Db db;
  late final DbCollection dbCollection;

  void connect() async {
    await dotenv.load(fileName: "credentials.env");
    username = dotenv.env["mongo.username"]!;
    pass = dotenv.env["mongo.password"]!;
    db = await Db.create('mongodb+srv://' +
        username +
        ':' +
        pass +
        '@cluster0.fg98e.mongodb.net/flutter_test?retryWrites=true&w=majority');
    await db.open();
    dbCollection = db.collection('flutter_test1');
    Fluttertoast.showToast(msg: "Connected to MongoDB Cluster");
  }

  void insert() async {
    LocationData ld = await SharedData.locationData.first;
    await dbCollection.insertOne({
      'time': DateTime.now().toString(),
      'current_loc_lat': ld.latitude,
      'current_loc_lon': ld.longitude
    });
  }
}
