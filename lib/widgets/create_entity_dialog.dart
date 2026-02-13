import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xinzuo_app/providers/app_provider.dart';
import 'package:xinzuo_app/models/entity.dart';

class CreateEntityDialog extends StatefulWidget {
  final EntityType defaultType;
  
  const CreateEntityDialog({
    super.key,
    this.defaultType = EntityType.character,
  });

  @override
  State<CreateEntityDialog> createState() => _CreateEntityDialogState();
}

class _CreateEntityDialogState extends State<CreateEntityDialog> {
  final _nameController = TextEditingController();
  final _aliasController = TextEditingController();
  final _descController = TextEditingController();
  late EntityType _selectedType;
  
  @override
  void initState() {
    super.initState();
    _selectedType = widget.defaultType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aliasController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '新建设定',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 类型选择
                  const Text(
                    '类型',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF757575),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: EntityType.values.map((type) {
                      final isSelected = _selectedType == type;
                      return ChoiceChip(
                        label: Text(_getTypeLabel(type)),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedType = type);
                          }
                        },
                        selectedColor: const Color(0xFF5C6BC0).withOpacity(0.2),
                        backgroundColor: const Color(0xFFF5F5F5),
                        side: BorderSide.none,
                        labelStyle: TextStyle(
                          color: isSelected 
                              ? const Color(0xFF5C6BC0)
                              : const Color(0xFF757575),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  // 名称
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: '名称 *',
                      hintText: '请输入名称',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  // 别名
                  TextField(
                    controller: _aliasController,
                    decoration: const InputDecoration(
                      labelText: '别名/外号',
                      hintText: '可选',
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 简介
                  TextField(
                    controller: _descController,
                    decoration: const InputDecoration(
                      labelText: '简介',
                      hintText: '描述这个设定的背景信息',
                      alignLabelWithHint: true,
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 24),
                  // 按钮
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('取消'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _nameController.text.trim().isEmpty
                              ? null
                              : _createEntity,
                          child: const Text('创建'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeLabel(EntityType type) {
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

  void _createEntity() {
    final entity = Entity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bookId: '1',
      type: _selectedType,
      name: _nameController.text.trim(),
      alias: _aliasController.text.trim().isEmpty 
          ? null 
          : _aliasController.text.trim(),
      description: _descController.text.trim().isEmpty 
          ? null 
          : _descController.text.trim(),
      createdAt: DateTime.now(),
    );
    
    context.read<AppProvider>().createEntity(entity);
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('创建成功')),
    );
  }
}
