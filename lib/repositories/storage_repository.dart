import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageRepository {
  addFileOneLevel(folder, filename, extension) {
    return FirebaseStorage.instance
        .ref()
        .child(folder)
        .child(filename + '.' + extension);
  }

  addFileTwoLevels(folder1, folder2, filename, extension) {
    return FirebaseStorage.instance
        .ref()
        .child(folder1)
        .child(folder2)
        .child(filename + '.' + extension);
  }
}
