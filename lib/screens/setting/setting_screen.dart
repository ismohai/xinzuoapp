import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:xinzuo_app/providers/app_provider.dart';
import 'package:xinzuo_app/models/entity.dart';
import 'package:xinzuo_app/widgets/entity_card.dart';
import 'package:xinzuo_app/widgets/create_entity_dialog.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadSampleData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('设定集'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: () => _showCreateEntityDialog(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF212121),
          unselectedLabelColor: const Color(0xFF757575),
          indicatorColor: const Color(0xFF5C6BC0),
          indicatorWeight: 2,
          tabs: const [
            Tab(text: '人物'),
            Tab(text: '道具'),
            Tab(text: '地点'),
            Tab(text: '势力'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEntityList(EntityType.character),
          _buildEntityList(EntityType.item),
          _buildEntityList(EntityType.location),
          _buildEntityList(EntityType.faction),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateEntityDialog(context),
        child: const Icon(Iconsax.add),
      ),
    );
  }

  Widget _buildEntityList(EntityType type) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final entities = provider.getEntitiesByType(type);
        
        if (entities.isEmpty) {
          return _buildEmptyState(type);
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: entities.length,
          itemBuilder: (context, index) {
            final entity = entities[index];
            return EntityCard(
              entity: entity,
              onTap: () => _showEntityDetail(context, entity),
              onDelete: () => _confirmDelete(context, entity),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(EntityType type) {
    String emptyText;
    IconData emptyIcon;
    
    switch (type) {
      case EntityType.character:
        emptyText = '暂无人物设定';
        emptyIcon = Iconsax.user;
        break;
      case EntityType.item:
        emptyText = '暂无道具设定';
        emptyIcon = Iconsax.box;
        break;
      case EntityType.location:
        emptyText = '暂无地点设定';
        emptyIcon = Iconsax.location;
        break;
      case EntityType.faction:
        emptyText = '暂无势力设定';
        emptyIcon = Iconsax.buildings;
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            emptyIcon,
            size: 64,
            color: const Color(0xFFBDBDBD),
          ),
          const SizedBox(height: 16),
          Text(
            emptyText,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => _showCreateEntityDialog(context, type),
            icon: const Icon(Iconsax.add, size: 18),
            label: const Text('添加设定'),
          ),
        ],
      ),
    );
  }

  void _showCreateEntityDialog(BuildContext context, [EntityType? type]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateEntityDialog(
        defaultType: type ?? EntityType.character,
      ),
    );
  }

  void _showEntityDetail(BuildContext context, Entity entity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EntityDetailSheet(entity: entity),
    );
  }

  void _confirmDelete(BuildContext context, Entity entity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除「${entity.name}」吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              context.read<AppProvider>().deleteEntity(entity.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已删除')),
              );
            },
            child: const Text('删除', style: TextStyle(color: Color(0xFFE53935))),
          ),
        ],
      ),
    );
  }
}

class _EntityDetailSheet extends StatelessWidget {
  final Entity entity;
  
  const _EntityDetailSheet({required this.entity});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 拖拽指示条
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 头像和名称
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _getGradientColors(),
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            entity.name[0],
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entity.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (entity.alias != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                '「${entity.alias}」',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF757575),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // 标签
                  Row(
                    children: [
                      _buildTag(entity.typeLabel, const Color(0xFF5C6BC0)),
                      const SizedBox(width: 8),
                      _buildTag(entity.statusLabel, _getStatusColor()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // 描述
                  const Text(
                    '简介',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      entity.description ?? '暂无简介',
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Color(0xFF424242),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // 时间线按钮
                  OutlinedButton.icon(
                    onPressed: () {
                      // TODO: 显示时间线
                    },
                    icon: const Icon(Iconsax.clock, size: 18),
                    label: const Text('查看时间线'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 44),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (entity.status) {
      case EntityStatus.alive:
      case EntityStatus.active:
        return const Color(0xFF43A047);
      case EntityStatus.dead:
      case EntityStatus.inactive:
        return const Color(0xFFE53935);
    }
  }

  List<Color> _getGradientColors() {
    final hash = entity.name.hashCode;
    final gradients = [
      [const Color(0xFF667eea), const Color(0xFF764ba2)],
      [const Color(0xFFf093fb), const Color(0xFFf5576c)],
      [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
      [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
      [const Color(0xFFfa709a), const Color(0xFFfee140)],
    ];
    return gradients[hash.abs() % gradients.length];
  }
}
