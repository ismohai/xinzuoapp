import 'package:flutter/material.dart';

class EditorProvider extends ChangeNotifier {
  // 当前编辑的章节ID
  String? _currentChapterId;
  String? get currentChapterId => _currentChapterId;
  
  // 编辑器内容
  String _content = '';
  String get content => _content;
  
  // 是否有未保存的更改
  bool _hasUnsavedChanges = false;
  bool get hasUnsavedChanges => _hasUnsavedChanges;
  
  // Writer 面板是否展开
  bool _isWriterExpanded = false;
  bool get isWriterExpanded => _isWriterExpanded;
  
  // AI 模式：writer / halo
  String _aiMode = 'writer';
  String get aiMode => _aiMode;
  
  // 设置当前章节
  void setCurrentChapter(String? chapterId, String content) {
    _currentChapterId = chapterId;
    _content = content;
    _hasUnsavedChanges = false;
    notifyListeners();
  }
  
  // 更新内容
  void updateContent(String content) {
    _content = content;
    _hasUnsavedChanges = true;
    notifyListeners();
  }
  
  // 保存内容
  void saveContent() {
    _hasUnsavedChanges = false;
    notifyListeners();
  }
  
  // 切换 Writer 面板
  void toggleWriterPanel() {
    _isWriterExpanded = !_isWriterExpanded;
    notifyListeners();
  }
  
  // 设置 AI 模式
  void setAiMode(String mode) {
    _aiMode = mode;
    notifyListeners();
  }
  
  // 清空编辑器
  void clear() {
    _currentChapterId = null;
    _content = '';
    _hasUnsavedChanges = false;
    notifyListeners();
  }
}
