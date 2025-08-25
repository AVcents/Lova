import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // 🔹 Ces infos seront remplacées par de vraies données plus tard
  final String userName = "Vincent";
  final String email = "vincent@example.com";
  final bool isLinked = true; // Mock, à remplacer avec Riverpod + state réel

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Informations personnelles",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text("👤 Prénom : $userName"),
            Text("✉️ Email : $email"),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            const Text(
              "Relation de couple",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text("❤️ Partenaire lié : ${isLinked ? "Oui" : "Non"}"),
            const SizedBox(height: 12),
            if (isLinked)
              ElevatedButton.icon(
                onPressed: () {
                  // TODO : déclencher la dissociation
                },
                icon: const Icon(Icons.link_off),
                label: const Text("Dissocier la relation"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            const Spacer(),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  // TODO : AuthRepository.logout()
                },
                icon: const Icon(Icons.logout),
                label: const Text("Se déconnecter"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}