class ExclusiveContent {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String content;
  final DateTime publishDate;
  final List<String> tags;
  final int requiredMonths;

  const ExclusiveContent({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.content,
    required this.publishDate,
    required this.tags,
    required this.requiredMonths,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'content': content,
      'publishDate': publishDate.toIso8601String(),
      'tags': tags,
      'requiredMonths': requiredMonths,
    };
  }

  factory ExclusiveContent.fromMap(Map<String, dynamic> map) {
    return ExclusiveContent(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      content: map['content'] ?? '',
      publishDate: DateTime.parse(
        map['publishDate'] ?? DateTime.now().toIso8601String(),
      ),
      tags: List<String>.from(map['tags'] ?? []),
      requiredMonths: map['requiredMonths'] ?? 0,
    );
  }
}
