// lib/screens/home/property_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../data/models/property.dart';
import '../../data/services/chat_service.dart';
import '../../providers/auth_provider.dart';
import '../chat/chat_screen.dart';
import '../../data/models/conversation.dart';

class PropertyDetailScreen extends StatelessWidget {
  final Property property;

  const PropertyDetailScreen({
    Key? key,
    required this.property,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(property.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photos
            Container(
              height: 250,
              color: AppColors.lightGrey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_camera, size: 50, color: AppColors.grey),
                    const SizedBox(height: 8),
                    Text('PHOTOS / VIDÉOS', style: TextStyle(color: AppColors.grey)),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Prix et statut
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: property.isAvailable ? AppColors.green : AppColors.error,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          property.isAvailable ? 'DISPONIBLE' : 'LOUÉ',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        property.formattedPrice,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    property.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    property.location,
                    style: TextStyle(color: AppColors.grey),
                  ),

                  const SizedBox(height: 24),

                  // Détails
                  const Text(
                    'Détails du bien',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildDetailRow('Type', property.propertyTypeText),
                  _buildDetailRow('Chambres', '${property.rooms}'),
                  _buildDetailRow('Salles de bain', '${property.bathrooms}'),
                  _buildDetailRow('Surface', '${property.surface}m²'),
                  _buildDetailRow('Standing', property.standingText),

                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    property.description,
                    style: TextStyle(color: AppColors.grey),
                  ),

                  const SizedBox(height: 24),

                  // Équipements
                  const Text(
                    'Équipements',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: property.equipments.map((equipment) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          equipment.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _contactOwner(context),
                child: const Text('CONTACTER'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Visite virtuelle
                },
                child: const Text('VISITE VIRTUELLE'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _contactOwner(BuildContext context) async {
    final currentUser = context.read<AuthProvider>().currentUser!;

    // Créer ou récupérer la conversation
    final conversationId = await ChatService.createConversation(
      senderId: currentUser.id,
      receiverId: property.ownerId,
      propertyId: property.id,
      propertyTitle: property.title,
      initialMessage: "Bonjour, je suis intéressé(e) par votre bien : ${property.title}",
    );

    if (conversationId != null) {
      // Récupérer la conversation complète
      final conversation = await ChatService.getConversation(conversationId);

      if (conversation != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(conversation: conversation),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de l\'ouverture du chat'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: TextStyle(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}