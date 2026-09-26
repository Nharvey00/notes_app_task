import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'crud_service.dart';
import 'auth_service.dart';
import 'login_page.dart';
import 'app_colors.dart'; // Make sure this matches your filename

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CrudService service = CrudService();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController qtyCtrl = TextEditingController();
  
  String? selectedImageUrl;
  bool isUploading = false;

  void openAddDialog(BuildContext context) {
    nameCtrl.clear();
    qtyCtrl.clear();
    selectedImageUrl = null;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColors.surface,
            title: const Text("Add item", style: TextStyle(color: AppColors.textLight)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selectedImageUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Image.network(selectedImageUrl!, height: 100, fit: BoxFit.cover),
                  ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.textLight,
                    side: const BorderSide(color: AppColors.accent),
                  ),
                  icon: isUploading 
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent)) 
                    : const Icon(Icons.image, color: AppColors.accent),
                  label: const Text("Upload Image"),
                  onPressed: () async {
                    setState(() => isUploading = true);
                    String? url = await service.pickImageForAddItem();
                    setState(() {
                      selectedImageUrl = url;
                      isUploading = false;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameCtrl,
                  style: const TextStyle(color: AppColors.textLight),
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: const TextStyle(color: AppColors.textMuted),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.textMuted),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.accent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: qtyCtrl,
                  style: const TextStyle(color: AppColors.textLight),
                  decoration: InputDecoration(
                    labelText: "Quantity",
                    labelStyle: const TextStyle(color: AppColors.textMuted),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.textMuted),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.accent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.textLight,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Save"),
                onPressed: () {
                  if (nameCtrl.text.isNotEmpty && qtyCtrl.text.isNotEmpty) {
                    service.addItem(nameCtrl.text, int.parse(qtyCtrl.text), selectedImageUrl);
                    Navigator.pop(context);
                  }
                },
              )
            ],
          );
        }
      )
    );
  }

  void openEditDialog(BuildContext context, DocumentSnapshot item) {
    final data = item.data() as Map<String, dynamic>;
    nameCtrl.text = data['name'] ?? '';
    qtyCtrl.text = data['quantity'].toString();
    selectedImageUrl = data['image_url'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColors.surface,
            title: const Text("Edit item", style: TextStyle(color: AppColors.textLight)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selectedImageUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Image.network(selectedImageUrl!, height: 100, fit: BoxFit.cover),
                  ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.textLight,
                    side: const BorderSide(color: AppColors.accent),
                  ),
                  icon: isUploading 
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent)) 
                    : const Icon(Icons.image, color: AppColors.accent),
                  label: const Text("Change Image"),
                  onPressed: () async {
                    setState(() => isUploading = true);
                    String? url = await service.pickImageForAddItem();
                    if (url != null) {
                      setState(() {
                        selectedImageUrl = url;
                      });
                    }
                    setState(() => isUploading = false);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameCtrl,
                  style: const TextStyle(color: AppColors.textLight),
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: const TextStyle(color: AppColors.textMuted),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.textMuted),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.accent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: qtyCtrl,
                  style: const TextStyle(color: AppColors.textLight),
                  decoration: InputDecoration(
                    labelText: "Quantity",
                    labelStyle: const TextStyle(color: AppColors.textMuted),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.textMuted),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.accent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.textLight,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Update"),
                onPressed: () {
                  if (nameCtrl.text.isNotEmpty && qtyCtrl.text.isNotEmpty) {
                    service.updateItem(item.id, nameCtrl.text, int.parse(qtyCtrl.text), selectedImageUrl);
                    Navigator.pop(context);
                  }
                },
              )
            ],
          );
        }
      )
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text("Delete item", style: TextStyle(color: AppColors.textLight)),
        content: const Text("Are you sure you want to delete this item?", style: TextStyle(color: AppColors.textMuted)),
        actions: [
          TextButton(
            child: const Text("Cancel", style: TextStyle(color: AppColors.textMuted)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.textLight,
            ),
            child: const Text("Delete"),
            onPressed: () {
              service.deleteItem(id);
              Navigator.pop(context);
            },
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Firebase Morong', style: TextStyle(color: AppColors.textLight)),
        centerTitle: true,
        // The flexibleSpace container allows the gradient to fill the AppBar completely
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.appBarGradient,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textLight),
            onPressed: () {
              AuthService().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textLight,
        child: const Icon(Icons.add),
        onPressed: () => openAddDialog(context),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: service.getItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accent));
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text("No items found", style: TextStyle(fontSize: 18, color: AppColors.textMuted)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var item = docs[index];
              final data = item.data() as Map<String, dynamic>;
              final String? imageUrl = data['image_url'];

              return Card(
                color: AppColors.surface,
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: imageUrl != null 
                    ? CircleAvatar(backgroundImage: NetworkImage(imageUrl)) 
                    : const CircleAvatar(
                        backgroundColor: AppColors.background, 
                        child: Icon(Icons.image_not_supported, color: AppColors.textMuted)
                      ),
                  title: Text(
                    data['name'] ?? '',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textLight),
                  ),
                  subtitle: Text(
                    "Quantity: ${data['quantity']}",
                    style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: AppColors.textMuted),
                        onPressed: () => openEditDialog(context, item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: AppColors.accent),
                        onPressed: () => _confirmDelete(context, item.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}