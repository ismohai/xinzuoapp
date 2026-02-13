import 'package:flutter/material.dart';
import 'package:xinzuo_app/models/book.dart';
import 'package:xinzuo_app/models/chapter.dart';
import 'package:xinzuo_app/models/volume.dart';
import 'package:xinzuo_app/models/entity.dart';

class AppProvider extends ChangeNotifier {
  // 当前选中的书籍
  Book? _currentBook;
  Book? get currentBook => _currentBook;
  
  // 书架列表
  List<Book> _books = [];
  List<Book> get books => _books;
  
  // 当前书籍的章节
  List<Volume> _volumes = [];
  List<Volume> get volumes => _volumes;
  
  List<Chapter> _chapters = [];
  List<Chapter> get chapters => _chapters;
  
  // 设定集
  List<Entity> _entities = [];
  List<Entity> get entities => _entities;
  
  // 加载示例数据
  void loadSampleData() {
    _books = SampleBooks.books;
    _entities = SampleEntities.entities;
    notifyListeners();
  }
  
  // 设置当前书籍
  void setCurrentBook(Book book) {
    _currentBook = book;
    // 加载该书的章节数据
    if (book.id == '1') {
      _volumes = SampleVolumes.volumes;
      // 生成示例章节
      _chapters = _generateSampleChapters();
    } else {
      _volumes = [];
      _chapters = [];
    }
    notifyListeners();
  }
  
  List<Chapter> _generateSampleChapters() {
    return List.generate(15, (index) {
      final volumeIndex = index < 5 ? 0 : (index < 10 ? 1 : 2);
      final chapterInVolume = index < 5 ? index : (index < 10 ? index - 5 : index - 10);
      return Chapter(
        id: 'c${index + 1}',
        volumeId: 'v${volumeIndex + 1}',
        title: '第${chapterInVolume + 1}章 章节标题${index + 1}',
        wordCount: 2000 + (index * 100),
        status: index < 10 ? ChapterStatus.complete : ChapterStatus.draft,
        order: index,
        createdAt: DateTime(2025, 12, index + 1),
        updatedAt: DateTime(2026, 2, 1),
      );
    });
  }
  
  // 创建新书
  void createBook(String title) {
    final newBook = Book(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _books.insert(0, newBook);
    notifyListeners();
  }
  
  // 删除书籍
  void deleteBook(String bookId) {
    _books.removeWhere((book) => book.id == bookId);
    if (_currentBook?.id == bookId) {
      _currentBook = null;
    }
    notifyListeners();
  }
  
  // 按类型获取实体
  List<Entity> getEntitiesByType(EntityType type) {
    return _entities.where((e) => e.type == type).toList();
  }
  
  // 创建实体
  void createEntity(Entity entity) {
    _entities.add(entity);
    notifyListeners();
  }
  
  // 删除实体
  void deleteEntity(String entityId) {
    _entities.removeWhere((e) => e.id == entityId);
    notifyListeners();
  }
  
  // 更新章节内容
  void updateChapterContent(String chapterId, String content) {
    final index = _chapters.indexWhere((c) => c.id == chapterId);
    if (index != -1) {
      _chapters[index] = _chapters[index].copyWith(
        content: content,
        wordCount: content.length,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }
}
