import 'package:pharmacy/Constants/constants.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {

  //  INSERT USER...
  static insertUser () async {
    try {
      var db = await Db.create(MONGO_URL);
      await db.open();
      if (db.state != State.open){
        print('THE DATABASE STATE IS CLOSED!');
      } else {
        var collection = db.collection(COLLECTION_NAME);
        try{
          await collection.insert({
            "first_name": "Setsofia Kojo",
            "last_name": "Nusetor",
            "email": "nusetorsetsofia101@gmail.com",
            "phone": "0555159963"
          });}
        catch (error){
          print("THIS ERROR OCCURRED DURING DATA INSERT: $error");
        } finally {
          print('HERE IS THE DATABASE CONNECTION: ${await collection.find().toList()}');
        }
      }
    } catch (error) {
      print('AN ERROR OCCURRED: $error');
    }
  }

  //  UPDATE USER DATA...
  static updateUser () async {
    try {
      var db = await Db.create(MONGO_URL);
      await db.open();
      if (db.state != State.open){
        print('THE DATABASE STATE IS CLOSED!');
      } else {
        var collection = db.collection(COLLECTION_NAME);
        //  DATA UPDATE METHOD...
        try{
          await collection.updateOne(where.eq('last_name', 'Nusetor'), modify.set('email', 'setso@gmail.com'));
        }
        catch (error){
          print("THIS ERROR OCCURRED DURING DATA INSERT: $error");
        } finally {
          print('HERE IS THE DATABASE CONNECTION: ${await collection.find().toList()}');
        }
      }
    } catch (error) {
      print('AN ERROR OCCURRED: $error');
    }
  }

  //  DELETE USER DATA...
  static deleteUser () async {
    try {
      var db = await Db.create(MONGO_URL);
      await db.open();
      if (db.state != State.open){
        print('THE DATABASE STATE IS CLOSED!');
      } else {
        var collection = db.collection(COLLECTION_NAME);
        try{
          await collection.deleteOne({"last_name": "Nusetor"});
        }
        catch (error){
          print("THIS ERROR OCCURRED DURING DATA INSERT: $error");
        } finally {
          print('HERE IS THE DATABASE CONNECTION: ${await collection.find().toList()}');
        }
      }
    } catch (error) {
      print('AN ERROR OCCURRED: $error');
    }
  }
}
