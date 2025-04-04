// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:kucchi/screens/insert.dart';
// import 'package:flutter_animate/flutter_animate.dart'; // Added for animations
// import 'package:url_launcher/url_launcher.dart'; // For email and WhatsApp

// class Dashboard extends StatefulWidget {
//   const Dashboard({super.key});

//   @override
//   State<Dashboard> createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   final List<Map<String, dynamic>> _items = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchItems();
//   }

//   Future<void> fetchItems() async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('items')
//         .orderBy('timestamp', descending: true)
//         .get();
//     final items = snapshot.docs.map((doc) => doc.data()).toList();

//     setState(() {
//       _items.addAll(items);
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Explore and Select',
//           style: TextStyle(
//             fontFamily: 'SF Pro Display',
//             fontSize: 28,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         // Removed logout button
//       ),
//       body: Container(
//         color: Colors.grey[100],
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               _isLoading
//                   ? const SizedBox(
//                       height: 350,
//                       child: Center(
//                         child: CircularProgressIndicator(
//                           color: Colors.blueAccent,
//                         ),
//                       ),
//                     )
//                   : _buildCarousel(),
//               _buildItemCards(),
//               const SizedBox(height: 20),
              
//               const SizedBox(height: 40),
//               _buildContactSection(),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCarousel() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: SizedBox(
//         height: 350,
//         child: CarouselSlider(
//           options: CarouselOptions(
//             height: 350.0,
//             autoPlay: true,
//             enlargeCenterPage: true,
//             viewportFraction: 0.85,
//             autoPlayCurve: Curves.easeInOut,
//             autoPlayAnimationDuration: const Duration(milliseconds: 800),
//             scrollPhysics: const BouncingScrollPhysics(),
//           ),
//           items: _items.map((item) {
//             return Builder(
//               builder: (BuildContext context) {
//                 return Container(
//                   width: MediaQuery.of(context).size.width,
//                   margin: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey[400]!.withOpacity(0.3),
//                         blurRadius: 10,
//                         spreadRadius: 2,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                     image: DecorationImage(
//                       image: NetworkImage(item['imageUrl'] ?? ''),
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 );
//               },
//             );
//           }).toList(),
//         ),
//       ),
//     ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, end: 0, curve: Curves.easeOut);
//   }

//   Widget _buildItemCards() {
//     if (_items.isEmpty) {
//       return const SizedBox.shrink();
//     }

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: _items.length,
//       itemBuilder: (context, index) {
//         final item = _items[index];
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
//           child: Card(
//             elevation: 6,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             color: Colors.white,
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     item['name'] ?? '',
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                       fontFamily: 'SF Pro Display',
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Center(
//                     child: GestureDetector(
//                       onTap: () {
//                         _showFullScreenImage(context, item['imageUrl'] ?? '');
//                       },
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(16),
//                         child: Image.network(
//                           item['imageUrl'] ?? '',
//                           width: double.infinity,
//                           height: 250,
//                           fit: BoxFit.fill,
//                           errorBuilder: (context, error, stackTrace) => Container(
//                             width: double.infinity,
//                             height: 250,
//                             color: Colors.grey[300],
//                             child: const Icon(
//                               Icons.broken_image,
//                               size: 50,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     item['description'] ?? '',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey[600],
//                       fontFamily: 'SF Pro Text',
//                       height: 1.5,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ).animate().fadeIn(duration: 1000.ms, delay: (index * 200).ms).slideX(
//               begin: 0.5,
//               end: 0,
//               curve: Curves.easeOutCubic,
//             );
//       },
//     );
//   }

  

//   void _showFullScreenImage(BuildContext context, String imageUrl) {
//     showDialog(
//       context: context,
//       barrierColor: Colors.black.withOpacity(0.8),
//       builder: (context) {
//         return GestureDetector(
//           onTap: () {
//             Navigator.of(context).pop();
//           },
//           child: Dialog(
//             backgroundColor: Colors.transparent,
//             insetPadding: const EdgeInsets.all(0),
//             child: Center(
//               child: Image.network(
//                 imageUrl,
//                 fit: BoxFit.contain,
//                 errorBuilder: (context, error, stackTrace) => Container(
//                   color: Colors.grey[300],
//                   child: const Icon(
//                     Icons.broken_image,
//                     size: 100,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildContactSection() {
//     return Container(
//       padding: const EdgeInsets.all(24.0),
//       color: Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Contact Us',
//             style: TextStyle(
//               fontFamily: 'SF Pro Display',
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildContactItem(
//                 icon: Icons.email,
//                 title: 'Email',
//                 value: 'bhargav7060@gmail.com',
//                 onTap: () => _launchEmail('bhargav7060@gmail.com'),
//               ),
//               _buildContactItem(
//                 icon: Icons.phone,
//                 title: 'Phone',
//                 value: '+91-9951097789',
//                 onTap: () => _launchWhatsApp('9951097789'),
//               ),
//               _buildContactItem(
//                 icon: Icons.location_on,
//                 title: 'Address',
//                 value: 'Gudivada, AP',
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'We’d love to hear from you! Reach out anytime.',
//             style: TextStyle(
//               fontSize: 16,
//               color: Color.fromARGB(139, 158, 158, 158),
//               fontFamily: 'SF Pro Text',
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     ).animate().fadeIn(duration: 1200.ms).slideY(
//           begin: 0.5,
//           end: 0,
//           curve: Curves.easeOutQuad,
//         ).then().blurXY(
//           begin: 4,


//           end: 0,
//           duration: 600.ms,
//         ); // Fade in with blur effect
//   }

//   Widget _buildContactItem({
//     required IconData icon,
//     required String title,
//     required String value,
//     VoidCallback? onTap,
//   }) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Icon(
//                 icon,
//                 size: 28,
//                 color: Colors.blueAccent,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                   fontFamily: 'SF Pro Text',
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey[600],
//                   fontFamily: 'SF Pro Text',
//                 ),
//                 textAlign: TextAlign.center,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ).animate().fadeIn(duration: 800.ms).scale(
//             begin: const Offset(0.9, 0.9),
//             end: const Offset(1.0, 1.0),
//             curve: Curves.easeInOut,
//           ),
//     );
//   }

//   Future<void> _launchEmail(String email) async {
//     final Uri emailUri = Uri(
//       scheme: 'mailto',
//       path: email,
//       queryParameters: {'subject': 'Hello from KucchuLu'},
//     );
//     if (await canLaunchUrl(emailUri)) {
//       await launchUrl(emailUri);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Could not launch email app')),
//       );
//     }
//   }

//   Future<void> _launchWhatsApp(String phoneNumber) async {
//     final String message = 'Hello! I’m reaching out from Your  Website. I Like One Of Your Design, Can We talk?';
//     final Uri whatsappUri = Uri.parse(
//       'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}',
//     );
//     if (await canLaunchUrl(whatsappUri)) {
//       await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Could not launch WhatsApp')),
//       );
//     }
//   }
// }

// ---------------
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kucchi/screens/insert.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Map<String, dynamic>> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('items')
        .orderBy('timestamp', descending: true)
        .get();
    final items = snapshot.docs.map((doc) => doc.data()).toList();

    setState(() {
      _items.addAll(items);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F3),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: const Text(
            'Explore and Select',
            style: TextStyle(
              fontFamily: 'SF Pro Display',
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFC5185),
            ),
          ),
          backgroundColor: const Color(0xFFFFF1F3),
          elevation: 4,
          centerTitle: true,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFFF1F3), // Light pink
        Color(0xFFAFCBFF), // Light blue
        Color(0xFFB5EAD7), // Light green
      ],
    ),),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _isLoading
                  ? const SizedBox(
                      height: 350,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFC5185),
                        ),
                      ),
                    )
                  : _buildCarousel(),
              _buildItemCards(),
              const SizedBox(height: 20),
              const SizedBox(height: 40),
              _buildContactSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 350,
        child: CarouselSlider(
          options: CarouselOptions(
            height: 350.0,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.85,
            autoPlayCurve: Curves.fastOutSlowIn,
            autoPlayAnimationDuration: const Duration(milliseconds: 900),
            scrollPhysics: const BouncingScrollPhysics(),
          ),
          items: _items.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink[100]!.withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(item['imageUrl'] ?? ''),
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 900.ms)
        .scale(begin: const Offset(0.95, 0.95), end: Offset(1, 1))
        .shimmer(color: const Color(0xFFFC5185));
  }

  Widget _buildItemCards() {
    if (_items.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: const Color.fromARGB(164, 175, 203, 255),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _showFullScreenImage(context, item['imageUrl'] ?? '');
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          item['imageUrl'] ?? '',
                          width: double.infinity,
                          height: 450,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: double.infinity,
                            height: 250,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item['description'] ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      fontFamily: 'SF Pro Text',
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 1000.ms, delay: (index * 300).ms)
            .slideX(begin: 0.6, end: 0)
            .scaleXY(begin: 0.95, end: 1);
      },
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(0),
            child: Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      color: const Color(0xFFFFFBEA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Us',
            style: TextStyle(
              fontFamily: 'SF Pro Display',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFC5185),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildContactItem(
                icon: Icons.email,
                title: 'Email',
                value: 'bhargav7060@gmail.com',
                onTap: () => _launchEmail('bhargav7060@gmail.com'),
              ),
              _buildContactItem(
                icon: Icons.phone,
                title: 'Phone',
                value: '+91-9951097789',
                onTap: () => _launchWhatsApp('9951097789'),
              ),
              _buildContactItem(
                icon: Icons.location_on,
                title: 'Address',
                value: 'Gudivada, AP',
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'We’d love to hear from you! Reach out anytime.',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(139, 158, 158, 158),
              fontFamily: 'SF Pro Text',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 1200.ms)
        .slideY(begin: 0.4, end: 0)
        .then()
        .shake(duration: 400.ms, hz: 3, offset: const Offset(1.5, 0));
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Icon(icon, size: 28, color: const Color(0xFFB5EAD7)),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontFamily: 'SF Pro Text',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontFamily: 'SF Pro Text',
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 800.ms).scaleXY(begin: 0.9, end: 1.05).shimmer(color: const Color(0xFFFC5185)),
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'Hello from KucchuLu'},
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch email app')),
      );
    }
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final String message =
        'Hello! I’m reaching out from Your Website. I like one of your designs. Can we talk?';
    final Uri whatsappUri = Uri.parse(
      'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}',
    );
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch WhatsApp')),
      );
    }
  }
}
