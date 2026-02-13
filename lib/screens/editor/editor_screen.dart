import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:xinzuo_app/providers/app_provider.dart';
import 'package:xinzuo_app/providers/editor_provider.dart';
import 'package:xinzuo_app/models/chapter.dart';
import 'package:xinzuo_app/widgets/chapter_drawer.dart';
import 'package:xinzuo_app/widgets/ai_panel.dart';

class EditorScreen extends StatefulWidget {
  final String bookId;
  
  const EditorScreen({super.key, required this.bookId});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  bool _isAiPanelOpen = false;
  String _currentChapterId = '';
  String _currentChapterTitle = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final appProvider = context.read<AppProvider>();
    final editorProvider = context.read<EditorProvider>();
    
    // 如果没有加载数据，加载示例数据
    if (appProvider.books.isEmpty) {
      appProvider.loadSampleData();
    }
    
    // 设置默认章节
    if (appProvider.chapters.isNotEmpty) {
      final chapter = appProvider.chapters.first;
      _setCurrentChapter(chapter);
    }
  }

  void _setCurrentChapter(Chapter chapter) {
    setState(() {
      _currentChapterId = chapter.id;
      _currentChapterTitle = chapter.title;
      _textController.text = chapter.content ?? _getSampleContent(chapter);
    });
    context.read<EditorProvider>().setCurrentChapter(
      chapter.id,
      _textController.text,
    );
  }

  String _getSampleContent(Chapter chapter) {
    // 返回示例内容
    return '''林逸站在天绝崖边，望着脚下翻涌的云海，心中涌起一股难以言喻的情绪。

三个月前，他还只是青云宗的一名普通外门弟子，每日苦苦修炼，却迟迟无法突破筑基期。

然而那颗从古遗迹中得来的神秘珠子，却彻底改变了他的人生轨迹。

"无论前路如何艰险，我都要走下去。"林逸握紧了拳头，眼中闪过一丝坚定。

就在此时，他腰间的斋神剑突然发出一道淡淡的青光，似乎在回应着他的决心……''';
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: ChapterDrawer(
        chapters: context.watch<AppProvider>().chapters,
        volumes: context.watch<AppProvider>().volumes,
        currentChapterId: _currentChapterId,
        onChapterSelected: _setCurrentChapter,
      ),
      body: Column(
        children: [
          _buildTopBar(context),
          Expanded(
            child: Stack(
              children: [
                _buildEditor(context),
                if (_isAiPanelOpen) _buildAiPanelOverlay(context),
              ],
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final book = context.watch<AppProvider>().currentBook;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              // 返回按钮
              IconButton(
                icon: const Icon(Iconsax.arrow_left),
                onPressed: () => context.pop(),
              ),
              // 书名和章节
              Expanded(
                child: GestureDetector(
                  onTap: () => _scaffoldKey.currentState?.openDrawer(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        book?.title ?? '未命名作品',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212121),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentChapterTitle.isEmpty ? '选择章节' : _currentChapterTitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF757575),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Iconsax.arrow_down_1,
                            size: 14,
                            color: Color(0xFF757575),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // 保存按钮
              IconButton(
                icon: const Icon(Iconsax.document_upload),
                onPressed: _saveContent,
              ),
              // 更多选项
              PopupMenuButton<String>(
                icon: const Icon(Iconsax.more),
                onSelected: _handleMenuAction,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'stats',
                    child: Row(
                      children: [
                        Icon(Iconsax.chart_1, size: 20),
                        SizedBox(width: 12),
                        Text('写作统计'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'export',
                    child: Row(
                      children: [
                        Icon(Iconsax.export_1, size: 20),
                        SizedBox(width: 12),
                        Text('导出章节'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'history',
                    child: Row(
                      children: [
                        Icon(Iconsax.clock, size: 20),
                        SizedBox(width: 12),
                        Text('历史版本'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditor(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isAiPanelOpen) {
          setState(() => _isAiPanelOpen = false);
        }
      },
      child: Container(
        color: Colors.white,
        child: TextField(
          controller: _textController,
          focusNode: _focusNode,
          maxLines: null,
          expands: true,
          textAlignVertical: TextAlignVertical.top,
          style: const TextStyle(
            fontSize: 17,
            height: 1.8,
            color: Color(0xFF212121),
            letterSpacing: 0.5,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(20),
            hintText: '开始写作...',
            hintStyle: TextStyle(
              color: Color(0xFFBDBDBD),
            ),
          ),
          onChanged: (text) {
            context.read<EditorProvider>().updateContent(text);
          },
        ),
      ),
    );
  }

  Widget _buildAiPanelOverlay(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AiPanel(
        onClose: () => setState(() => _isAiPanelOpen = false),
        onInsertText: _insertAiText,
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final wordCount = _textController.text.length;
    final hasChanges = context.watch<EditorProvider>().hasUnsavedChanges;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: const Color(0xFFEEEEEE),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // 字数统计
              Row(
                children: [
                  Text(
                    '$wordCount 字',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF757575),
                    ),
                  ),
                  if (hasChanges) ...[
                    const SizedBox(width: 8),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFB300),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
              const Spacer(),
              // AI 按钮
              _buildAiButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAiButton(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isAiPanelOpen = !_isAiPanelOpen),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF5C6BC0), Color(0xFF7986CB)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Iconsax.magicpen,
              size: 18,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            const Text(
              'Writer',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveContent() {
    context.read<EditorProvider>().saveContent();
    context.read<AppProvider>().updateChapterContent(
      _currentChapterId,
      _textController.text,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已保存'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _insertAiText(String text) {
    final currentText = _textController.text;
    final selection = _textController.selection;
    
    String newText;
    if (selection.start >= 0 && selection.end >= 0) {
      // 替换选中内容
      newText = currentText.replaceRange(selection.start, selection.end, text);
    } else {
      // 追加到末尾
      newText = '$currentText\n\n$text';
    }
    
    _textController.text = newText;
    context.read<EditorProvider>().updateContent(newText);
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'stats':
        _showStatsDialog();
        break;
      case 'export':
        _showExportDialog();
        break;
      case 'history':
        _showHistoryDialog();
        break;
    }
  }

  void _showStatsDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '写作统计',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            _buildStatRow('当前章节', '${_textController.text.length} 字'),
            _buildStatRow('今日写作', '2,180 字'),
            _buildStatRow('本周写作', '12,500 字'),
            _buildStatRow('全书总字数', '125,600 字'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF757575),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
            ),
          ),
        ],
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('导出章节'),
        content: const Text('选择导出格式：'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('导出成功')),
              );
            },
            child: const Text('TXT'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('导出成功')),
              );
            },
            child: const Text('DOCX'),
          ),
        ],
      ),
    );
  }

  void _showHistoryDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              '历史版本',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Iconsax.document_text),
                title: Text('版本 ${5 - index}'),
                subtitle: Text(
                  '${DateTime.now().subtract(Duration(hours: index * 2)).toString().substring(0, 16)} · ${(1000 + index * 100)} 字',
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
