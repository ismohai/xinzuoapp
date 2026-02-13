class Entity {
  final String id;
  final String bookId;
  final EntityType type;
  final String name;
  final String? alias;
  final String? description;
  final String? avatar;
  final EntityStatus status;
  final DateTime createdAt;
  
  const Entity({
    required this.id,
    required this.bookId,
    required this.type,
    required this.name,
    this.alias,
    this.description,
    this.avatar,
    this.status = EntityStatus.alive,
    required this.createdAt,
  });
  
  String get typeLabel {
    switch (type) {
      case EntityType.character:
        return '人物';
      case EntityType.item:
        return '道具';
      case EntityType.location:
        return '地点';
      case EntityType.faction:
        return '势力';
    }
  }
  
  String get statusLabel {
    switch (status) {
      case EntityStatus.alive:
        return '存活';
      case EntityStatus.dead:
        return '死亡';
      case EntityStatus.active:
        return '活跃';
      case EntityStatus.inactive:
        return '消亡';
    }
  }
}

enum EntityType {
  character,
  item,
  location,
  faction,
}

enum EntityStatus {
  alive,    // 存活（人物）
  dead,     // 死亡（人物）
  active,   // 活跃（势力/地点）
  inactive, // 消亡（势力/地点）
}

// 示例数据
class SampleEntities {
  static final List<Entity> entities = [
    Entity(
      id: 'e1',
      bookId: '1',
      type: EntityType.character,
      name: '林逸',
      alias: '逸仙子',
      description: '主角，天资聪颖，性格坚毅。出身寒门，凭借天赋与努力踏入修仙之路。',
      status: EntityStatus.alive,
      createdAt: DateTime(2025, 12, 1),
    ),
    Entity(
      id: 'e2',
      bookId: '1',
      type: EntityType.character,
      name: '南宫婉儿',
      alias: '婉儿',
      description: '女主角，世家千金，外表冷艳内心温柔。与主角有情感纠葛。',
      status: EntityStatus.alive,
      createdAt: DateTime(2025, 12, 5),
    ),
    Entity(
      id: 'e3',
      bookId: '1',
      type: EntityType.item,
      name: '斋神剑',
      description: '上古神器，蕴含混沌之力，为主角所得。',
      status: EntityStatus.active,
      createdAt: DateTime(2025, 12, 20),
    ),
    Entity(
      id: 'e4',
      bookId: '1',
      type: EntityType.location,
      name: '天绝崖',
      description: '险地，主角在此获得重大机缘。',
      status: EntityStatus.active,
      createdAt: DateTime(2026, 1, 5),
    ),
    Entity(
      id: 'e5',
      bookId: '1',
      type: EntityType.faction,
      name: '青云宗',
      description: '修仙大派，主角所在的宗门。',
      status: EntityStatus.active,
      createdAt: DateTime(2025, 12, 1),
    ),
  ];
}
