import 'dart:io';

import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:app_dialog/models/product.dart';

class ProductProvider {
  static ProductProvider _instance = ProductProvider();
  static ProductProvider get instance => _instance;

  DatabaseReference _database;
  StorageReference _storage;

  DatabaseReference get reference => _database;
  Query get promoQuery => _database.orderByChild('promo').equalTo(true);

  ProductProvider() {
    _database = FirebaseDatabase.instance.reference().child('products');
    _storage = FirebaseStorage.instance.ref().child('products');
  }

  create(Product product, File image) async {
    product.urlPhoto = await _uploadFile(image);
    _database.push().set(product.toJson());
  }

  update(Product product, String path, File image) async {
    if (image != null) {
      product.urlPhoto = await _uploadFile(image);
    }
    _database.child(path).update(product.toJson());
  }

  destroy(String path) => _database.child(path).remove();

  Future<String> _uploadFile(File image) async {
    final storageReference = _storage.child(Path.basename(image.path));
    await storageReference.putFile(image).onComplete;
    return await storageReference.getDownloadURL();
  }
}