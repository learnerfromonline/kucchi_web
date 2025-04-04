import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kucchi/screens/dashboard.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  Future<void> registerWithEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
          'email': _emailController.text,
          'phone': _phoneController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        Navigator.push(context, MaterialPageRoute(builder: (context) => const Dashboard()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth!.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        // Check for phone number
        final docRef = FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid);
        final snapshot = await docRef.get();

        if (!snapshot.exists || snapshot.data()?['phone'] == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter your phone number to complete registration.')),
          );
          showPhoneDialog(userCredential.user!.uid);
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Dashboard()));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void showPhoneDialog(String uid) {
    final phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Phone Number'),
        content: TextField(
          controller: phoneController,
          decoration: const InputDecoration(labelText: 'Phone Number'),
          keyboardType: TextInputType.phone,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (phoneController.text.isNotEmpty) {
                await FirebaseFirestore.instance.collection('users').doc(uid).set({
                  'phone': phoneController.text,
                  'timestamp': FieldValue.serverTimestamp(),
                }, SetOptions(merge: true));
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Dashboard()));
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login / Register')),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Phone number is required' : null,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter email' : null,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter password' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: registerWithEmail,
                    child: const Text('Register with Email'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: signInWithGoogle,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: const Text('Continue with Google', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}