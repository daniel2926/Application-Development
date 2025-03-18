import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pad_1/constants/urls.dart';
import 'package:flutter_pad_1/datas/mock_posts.dart';
import 'package:flutter_pad_1/helpers/cloud_firestore_helper.dart';
import 'package:flutter_pad_1/models/post_model.dart';
import 'package:flutter_pad_1/providers/post_provider.dart';
import 'package:flutter_pad_1/providers/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_pad_1/constants/app_theme.dart';
import 'package:flutter_pad_1/widgets/custom_input_field.dart';
import 'package:provider/provider.dart';

class PostAploudScreen extends StatefulWidget {
  const PostAploudScreen({super.key});

  @override
  _PostAploudScreenState createState() => _PostAploudScreenState();
}

class _PostAploudScreenState extends State<PostAploudScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? selectedImage; // To store the picked image


  // Method to pick an image
  // Future<void> _pickImage() async {
  //   final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
  //   if (photo != null) {
  //     setState(() {
  //       _selectedImage = photo;
  //     });
  //   }
  // }
  Future<void> _pickImage() async {
  final albumImages = [
    postImg1,
    postImg2,
    postImg3,
    postImg4,
    postImg5,
    postImg6,
    postImg7,
    postImg8,
    postImg9,
  ];

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 500,
        child: Column(
          children: [
            Text(
              "Select Photo",
              style: title2, // title2 equivalent
            ),
            const Divider(thickness: 0.5),
            Expanded(
              child: GridView.builder(
                itemCount: albumImages.length,
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedImage = albumImages[index];
                      });
                      Navigator.pop(context);
                    },
                    child: Image.network(
                      albumImages[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
@override
void initState() {
  super.initState();
  // Ensure user data is loaded
  Provider.of<UserProvider>(context, listen: false).loadUser();
}


  Future<void> _addPost() async {
  if (_formKey.currentState!.validate()) {
    CloudFirestoreHelper cloudFirestoreHelper = CloudFirestoreHelper();
final userProvider = Provider.of<UserProvider>(context, listen: false);
final userId = userProvider.user?.userId;
final userName = userProvider.user?.name;

final newPost = PostModel(
  postId: 'post_${DateTime.now().millisecondsSinceEpoch}',
  title: titleController.text,
  description: descriptionController.text,
  price: num.tryParse(priceController.text) ?? 0,
  images: [selectedImage ?? defalutImg],
  sellerId: userId!,
  sellerName: userName!,
  location: const GeoPoint(37.7749, -122.4194),
  isAvailable: true,
  createdAt: Timestamp.now(),
);
await cloudFirestoreHelper.uploadPost(newPost);
 setState(() {
  selectedImage = null;
        titleController.clear();
        priceController.clear();
        descriptionController.clear();
        
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully added!')));
  }
}

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
 Widget build(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Upload
              const Text(
                "Photo",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),

              // Image Picker Box
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                    image: selectedImage != null
                        ? DecorationImage(
                            image: NetworkImage(selectedImage!), // Load from network
                            fit: BoxFit.cover,
                          )
                            : null,
                  ),
                  child: (selectedImage == null && selectedImage == null)
                      ? const Icon(Icons.camera_alt_outlined,
                          color: Colors.black54, size: 40)
                      : null,
                ),
              ),

              const SizedBox(height: 20),

              // Title
              const Text(
                "Title",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              CustomInputField(
                isnum: false,
                lines: 1,
                validatorMessage: 'Title cannot be empty',
                controller: titleController,
              ),
              const SizedBox(height: 20),

              // Price
              const Text(
                "Price",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              CustomInputField(
                isnum: true,
                lines: 1,
                validatorMessage: 'Price cannot be empty',
                controller: priceController,
              ),
              const SizedBox(height: 20),

              // Description
              const Text(
                "Description",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              CustomInputField(
                isnum: false,
                lines: 5,
                validatorMessage: 'Description cannot be empty',
                controller: descriptionController,
              ),
              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: _addPost,
                child: const Text(
                  'Add a Product',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

}
