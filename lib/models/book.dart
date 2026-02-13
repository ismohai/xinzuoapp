class Book {
  final String id;
  final String title;
  final String? coverPath;
  final int wordCount;
  final int chapterCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool hasHealthIssue; // Halo 健康度信号灯
  
  const Book({
    required this.id,
    required this.title,
    this.coverPath,
    this.wordCount = 0,
    this.chapterCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.hasHealthIssue = false,
  });
  
  String get formattedWordCount {
    if (wordCount >= 10000) {
      return '${(wordCount / 10000).toStringAsFixed(1)}万字';
    }
    return '$wordCount字';
  }
  
  Book copyWith({
    String? id,
    String? title,
    String? coverPath,
    int? wordCount,
    int? chapterCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? hasHealthIssue,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      coverPath: coverPath ?? this.coverPath,
      wordCount: wordCount ?? this.wordCount,
      chapterCount: chapterCount ?? this.chapterCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hasHealthIssue: hasHealthIssue ?? this.hasHealthIssue,
    );
  }
}

// 示例数据
class SampleBooks {
  static final List<Book> books = [
    Book(
      id: '1',
      title: '仙途问道',
      wordCount: 125600,
      chapterCount: 45,
      createdAt: DateTime(2025, 12, 1),
      updatedAt: DateTime(2026, 2, 10),
      hasHealthIssue: false,
    ),
    Book(
      id: '2',
      title: '都市传奇',
      wordCount: 89200,
      chapterCount: 32,
      createdAt: DateTime(2026, 1, 5),
      updatedAt: DateTime(2026, 2, 12),
      hasHealthIssue: true,
    ),
    Book(
      id: '3',
      title: '星际征途',
      wordCount: 234500,
      chapterCount: 87,
      createdAt: DateTime(2025, 8, 15),
      updatedAt: DateTime(2026, 2, 8),
      hasHealthIssue: false,
    ),
  ];
}
