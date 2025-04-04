// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';

// class Insert extends StatefulWidget {
//   const Insert({Key? key}) : super(key: key);

//   @override
//   State<Insert> createState() => _InsertState();
// }

// class _InsertState extends State<Insert> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//   TextEditingController ImageController = TextEditingController();
//   Uint8List? _imageBytes;
//   bool isSaving = false;
//   bool isSaved = false; // Renamed for clarity
//   String? savedName; // Store data for preview
//   String? savedDescription;
//   Uint8List? savedImageBytes;
//   String? savedImageURL;

//   Future<void> pickImage() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//     );

//     if (result != null) {
//       setState(() {
//         _imageBytes = result.files.first.bytes;
//       });
//     }
//   }


//   Future<void> saveToFirestore() async {
//     if (isSaving) return;

//     // Basic validation
//     if (nameController.text.isEmpty || descriptionController.text.isEmpty || ImageController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter name and description')),
//       );
//       return;
//     }

//     setState(() => isSaving = true);

//     try {

//       await FirebaseFirestore.instance.collection('items').add({
//         'name': nameController.text,
//         'description': descriptionController.text,
//         'imageUrl': ImageController.text,
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       // Store data for preview before clearing
//       setState(() {
//         savedName = nameController.text;
//         savedDescription = descriptionController.text;
//         savedImageURL = ImageController.text;
//         savedImageBytes = _imageBytes;
//         nameController.clear();
//         descriptionController.clear();
//         ImageController.clear();
        
//         isSaved = true;
//         isSaving = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Item saved successfully!')),
//       );
//     } catch (e) {
//       setState(() => isSaving = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.redAccent,
//         title: const Text(
//           "Add a New Item",
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Container(
//             width: 500,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.grey[900],
//               borderRadius: BorderRadius.circular(15),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.red.withOpacity(0.6),
//                   blurRadius: 10,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextField(
//                   controller: nameController,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     labelText: "Name",
//                     labelStyle: const TextStyle(color: Colors.redAccent),
//                     filled: true,
//                     fillColor: Colors.grey[850],
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: descriptionController,
//                   style: const TextStyle(color: Colors.white),
//                   maxLines: 3,
//                   decoration: InputDecoration(
//                     labelText: "Description",
//                     labelStyle: const TextStyle(color: Colors.redAccent),
//                     filled: true,
//                     fillColor: Colors.grey[850],
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: ImageController,
//                   style: const TextStyle(color: Colors.white),
//                   maxLines: 3,
//                   decoration: InputDecoration(
//                     labelText: "Enter Image URL",
//                     labelStyle: const TextStyle(color: Colors.redAccent),
//                     filled: true,
//                     fillColor: Colors.grey[850],
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
           
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: isSaving ? null : saveToFirestore,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.redAccent,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                   ),
//                   child: Center(
//                     child: isSaving
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                             "SAVE",
//                             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                   ),
//                 ),
//                 if (isSaved) ...[
//                   const SizedBox(height: 20),
//                   SingleChildScrollView(
//                     child: Card(
//                       color: Colors.blueGrey,
//                       elevation: 5,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(15),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Center(
//                               child: Text(
//                                 savedName ?? "New Item",
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 30,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 15),
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   height: 150,
//                                   width: 150,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     border: Border.all(color: Colors.redAccent, width: 2),
//                                   ),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(10),
//                                     child: savedImageBytes != null
//                                         ? Image.network(ImageController.text, fit: BoxFit.cover)
//                                         : const Icon(Icons.image, size: 50, color: Colors.grey),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 15),
//                                 Expanded(
//                                   child: Text(
//                                     savedDescription ?? "No description",
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     softWrap: true,
//                                     overflow: TextOverflow.clip,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Insert extends StatefulWidget {
  const Insert({Key? key}) : super(key: key);

  @override
  State<Insert> createState() => _InsertState();
}

class _InsertState extends State<Insert> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imageController = TextEditingController(); // Renamed for consistency
  bool isSaving = false;
  bool isSaved = false;
  String? savedName;
  String? savedDescription;
  String? savedImageURL;

  Future<void> saveToFirestore() async {
    if (isSaving) return;

    // Basic validation
    if (nameController.text.isEmpty || 
        descriptionController.text.isEmpty || 
        imageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter name, description, and image URL')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      await FirebaseFirestore.instance.collection('items').add({
        'name': nameController.text,
        'description': descriptionController.text,
        'imageUrl': imageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Store data for preview before clearing
      setState(() {
        savedName = nameController.text;
        savedDescription = descriptionController.text;
        savedImageURL = imageController.text;
        nameController.clear();
        descriptionController.clear();
        imageController.clear();
        isSaved = true;
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item saved successfully!')),
      );
    } catch (e) {
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text(
          "Add a New Item",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.6),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: const TextStyle(color: Colors.redAccent),
                    filled: true,
                    fillColor: Colors.grey[850],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: descriptionController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Description",
                    labelStyle: const TextStyle(color: Colors.redAccent),
                    filled: true,
                    fillColor: Colors.grey[850],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: imageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Enter Image URL",
                    labelStyle: const TextStyle(color: Colors.redAccent),
                    filled: true,
                    fillColor: Colors.grey[850],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isSaving ? null : saveToFirestore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Center(
                    child: isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "SAVE",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                if (isSaved) ...[
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    child: Card(
                      color: Colors.blueGrey,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                savedName ?? "New Item",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.redAccent, width: 2),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: savedImageURL != null && savedImageURL!.isNotEmpty
                                        ? Image.network(
                                            savedImageURL!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Icon(Icons.error, size: 50, color: Colors.red);
                                            },
                                          )
                                        : const Icon(Icons.image, size: 50, color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    savedDescription ?? "No description",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}