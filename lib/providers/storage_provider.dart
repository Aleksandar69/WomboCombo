import 'package:flutter/material.dart';
import '../repositories/storage_repository.dart';

class StorageProvider with ChangeNotifier {
  StorageRepository storageRepo = StorageRepository();

  addFileOneLevel(folder, filename, extension) {
    return storageRepo.addFileOneLevel(folder, filename, extension);
  }

  addFileTwoLevels(folder1, folder2, filename, extension) {
    return storageRepo.addFileTwoLevels(folder1, folder2, filename, extension);
  }
}
