import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ChapterDrawer extends StatelessWidget {
  final List<dynamic> chapters;
  final List<dynamic> volumes;
  final String currentChapterId;
  final Function(dynamic) onChapterSelected;
  
  const ChapterDrawer({
    super.key,
    required this.chapters,
    required this.volumes,
    required this.currentChapterId,
    required this.onChapterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(height: 1),
            Expanded(
              child: chapters.isEmpty
                  ? _buildEmptyState()
                  : _buildChapterList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '章节目录',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
            ),
          ),
          IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: () {
              // TODO: 添加新章节
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.document_text,
            size: 48,
            color: Color(0xFFBDBDBD),
          ),
          SizedBox(height: 16),
          Text(
            '暂无章节',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterList() {
    // 按卷分组章节
    final Map<String, List<dynamic>> chaptersByVolume = {};
    for (final chapter in chapters) {
      final volumeId = chapter.volumeId as String;
      chaptersByVolume.putIfAbsent(volumeId, () => []);
      chaptersByVolume[volumeId]!.add(chapter);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: volumes.length,
      itemBuilder: (context, index) {
        final volume = volumes[index];
        final volumeChapters = chaptersByVolume[volume.id] ?? [];
        
        return _buildVolumeSection(volume, volumeChapters);
      },
    );
  }

  Widget _buildVolumeSection(dynamic volume, List<dynamic> volumeChapters) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        volume.title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF212121),
        ),
      ),
      children: volumeChapters.map((chapter) {
        final isSelected = chapter.id == currentChapterId;
        final status = chapter.status.toString();
        
        return _buildChapterTile(chapter, isSelected, status);
      }).toList(),
    );
  }

  Widget _buildChapterTile(dynamic chapter, bool isSelected, String status) {
    Color statusColor;
    switch (status) {
      case 'ChapterStatus.complete':
        statusColor = const Color(0xFF43A047);
        break;
      case 'ChapterStatus.dirty':
        statusColor = const Color(0xFFFFB300);
        break;
      default:
        statusColor = const Color(0xFFBDBDBD);
    }

    return Builder(
      builder: (context) => ListTile(
        dense: true,
        contentPadding: const EdgeInsets.only(left: 32, right: 16),
        leading: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
        title: Text(
          chapter.title,
          style: TextStyle(
            fontSize: 14,
            color: isSelected 
                ? const Color(0xFF5C6BC0)
                : const Color(0xFF424242),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          '${chapter.wordCount}',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF757575),
          ),
        ),
        selected: isSelected,
        selectedTileColor: const Color(0xFFF5F5F5),
        onTap: () {
          Navigator.pop(context);
          onChapterSelected(chapter);
        },
      ),
    );
  }
}
