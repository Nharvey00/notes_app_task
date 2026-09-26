import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';

class CrudService {
  final CollectionReference items = FirebaseFirestore.instance.collection('items');
  
  // Replace with your actual Cloud Name and Unsigned Preset Name
  final cloudinary = CloudinaryPublic('gyv0xeph', 'Pavlova', cache: false);

  Future<String?> pickImageForAddItem() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile == null) return null;
    
    File imageFile = File(pickedFile.path);
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageFile.path, resourceType: CloudinaryResourceType.Image),
      );
      return response.secureUrl;
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }

  Future<void> addItem(String name, int quantity, String? imageUrl) {
    return items.add({
      'name': name,
      'quantity': quantity,
      'image_url': imageUrl,
      'createdAt': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getItems() {
    return items.orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> updateItem(String id, String name, int quantity, String? imageUrl) {
    return items.doc(id).update({
      'name': name,
      'quantity': quantity,
      'image_url': imageUrl,
    });
  }

  Future<void> deleteItem(String id) {
    return items.doc(id).delete();
  }
}