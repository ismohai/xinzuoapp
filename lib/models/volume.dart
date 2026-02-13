class Volume {
  final String id;
  final String bookId;
  final String title;
  final int order;
  final DateTime createdAt;
  
  const Volume({
    required this.id,
    required this.bookId,
    required this.title,
    required this.order,
    required this.createdAt,
  });
}

// 示例数据
class SampleVolumes {
  static final List<Volume> volumes = [
    Volume(
      id: 'v1',
      bookId: '1',
      title: '第一卷 入门',
      order: 0,
      createdAt: DateTime(2025, 12, 1),
    ),
    Volume(
      id: 'v2',
      bookId: '1',
      title: '第二卷 成长',
      order: 1,
      createdAt: DateTime(2025, 12, 15),
    ),
    Volume(
      id: 'v3',
      bookId: '1',
      title: '第三卷 涅槃',
      order: 2,
      createdAt: DateTime(2026, 1, 10),
    ),
  ];
}
