class Chapter {
  final String id;
  final String volumeId;
  final String title;
  final String? content;
  final int wordCount;
  final ChapterStatus status;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const Chapter({
    required this.id,
    required this.volumeId,
    required this.title,
    this.content,
    this.wordCount = 0,
    this.status = ChapterStatus.draft,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });
  
  Chapter copyWith({
    String? id,
    String? volumeId,
    String? title,
    String? content,
    int? wordCount,
    ChapterStatus? status,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Chapter(
      id: id ?? this.id,
      volumeId: volumeId ?? this.volumeId,
      title: title ?? this.title,
      content: content ?? this.content,
      wordCount: wordCount ?? this.wordCount,
      status: status ?? this.status,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum ChapterStatus {
  draft,    // 草稿
  complete, // 完成
  dirty,    // 完成后被修改
}

extension ChapterStatusExtension on ChapterStatus {
  String get label {
    switch (this) {
      case ChapterStatus.draft:
        return '草稿';
      case ChapterStatus.complete:
        return '完成';
      case ChapterStatus.dirty:
        return '已修改';
    }
  }
}
