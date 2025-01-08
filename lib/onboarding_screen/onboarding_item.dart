// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OnboardingItemModel {
  final String image;
  final String title;
  final String subtitle;
  OnboardingItemModel({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  OnboardingItemModel copyWith({
    String? image,
    String? title,
    String? subtitle,
  }) {
    return OnboardingItemModel(
      image: image ?? this.image,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
      'title': title,
      'subtitle': subtitle,
    };
  }

  factory OnboardingItemModel.fromMap(Map<String, dynamic> map) {
    return OnboardingItemModel(
      image: map['image'] as String,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OnboardingItemModel.fromJson(String source) =>
      OnboardingItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'OnboardingItemModel(image: $image, title: $title, subtitle: $subtitle)';

  @override
  bool operator ==(covariant OnboardingItemModel other) {
    if (identical(this, other)) return true;

    return other.image == image &&
        other.title == title &&
        other.subtitle == subtitle;
  }

  @override
  int get hashCode => image.hashCode ^ title.hashCode ^ subtitle.hashCode;
}
