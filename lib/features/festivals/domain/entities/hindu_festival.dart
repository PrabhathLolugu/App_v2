/// Entity for a Hindu festival (Festival Stories section).
class HinduFestival {
  final String id;
  final String name;
  final String slug;
  final String? shortDescription;
  final String? description;
  final String? whenCelebrated;
  final String? whenDetails;
  final String? whereCelebrated;
  final String? howCelebrated;
  final String? history;
  final String? significance;
  final String? scripturesRelated;
  final String? imageUrl;
  final int orderIndex;

  HinduFestival({
    required this.id,
    required this.name,
    required this.slug,
    this.shortDescription,
    this.description,
    this.whenCelebrated,
    this.whenDetails,
    this.whereCelebrated,
    this.howCelebrated,
    this.history,
    this.significance,
    this.scripturesRelated,
    this.imageUrl,
    this.orderIndex = 0,
  });

  factory HinduFestival.fromJson(Map<String, dynamic> json) {
    return HinduFestival(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      shortDescription: json['short_description']?.toString(),
      description: json['description']?.toString(),
      whenCelebrated: json['when_celebrated']?.toString(),
      whenDetails: json['when_details']?.toString(),
      whereCelebrated: json['where_celebrated']?.toString(),
      howCelebrated: json['how_celebrated']?.toString(),
      history: json['history']?.toString(),
      significance: json['significance']?.toString(),
      scripturesRelated: json['scriptures_related']?.toString(),
      imageUrl: json['image_url']?.toString(),
      orderIndex: (json['order_index'] as num?)?.toInt() ?? 0,
    );
  }
}
