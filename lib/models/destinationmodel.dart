import 'package:cloud_firestore/cloud_firestore.dart';

class Destination {
  final String id;
  final String name;
  final String location;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final List<String> amenities;
  final List<String> nearbyPlaces;
  final double price;
  final String currency;
  final List<String> gallery;

  Destination({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.amenities,
    required this.nearbyPlaces,
    required this.price,
    this.currency = 'USD',
    required this.gallery,
  });

  factory Destination.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Destination(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      amenities: List<String>.from(data['amenities'] ?? []),
      nearbyPlaces: List<String>.from(data['nearbyPlaces'] ?? []),
      price: (data['price'] ?? 0.0).toDouble(),
      currency: data['currency'] ?? 'USD',
      gallery: List<String>.from(data['gallery'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'location': location,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'amenities': amenities,
      'nearbyPlaces': nearbyPlaces,
      'price': price,
      'currency': currency,
      'gallery': gallery,
    };
  }
}