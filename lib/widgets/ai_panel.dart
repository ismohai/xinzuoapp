import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class AiPanel extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String) onInsertText;
  
  const AiPanel({
    super.key,
    required this.onClose,
    required this.onInsertText,
  });

  @override
  State<AiPanel> createState() => _AiPanelState();
}

class _AiPanelState extends State<AiPanel> {
  final TextEditingController _inputController = TextEditingController();
  bool _isProcessing = false;
  String _mode = 'writer';
  
  final List<Map<String, String>> _messages = [];

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          _buildModeToggle(),
          Expanded(
            child: _messages.isEmpty 
                ? _buildEmptyState() 
                : _buildMessages(),
          ),
          _buildQuickActions(),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF5C6BC0), Color(0xFF7986CB)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Iconsax.magicpen,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Writer 创作助手',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Iconsax.close_circle),
            onPressed: widget.onClose,
            iconSize: 20,
            color: const Color(0xFF757575),
          ),
        ],
      ),
    );
  }

  Widget _buildModeToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildModeButton(
              'Writer',
              '主动创作',
              Iconsax.edit_2,
              'writer',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildModeButton(
              'Halo',
              '逻辑监护',
              Iconsax.shield_tick,
              'halo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(String label, String subtitle, IconData icon, String mode) {
    final isSelected = _mode == mode;
    
    return GestureDetector(
      onTap: () => setState(() => _mode = mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF5C6BC0).withOpacity(0.1)
              : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: const Color(0xFF5C6BC0))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected 
                  ? const Color(0xFF5C6BC0)
                  : const Color(0xFF757575),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected 
                        ? const Color(0xFF5C6BC0)
                        : const Color(0xFF212121),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: isSelected 
                        ? const Color(0xFF5C6BC0)
                        : const Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _mode == 'writer' ? Iconsax.edit_2 : Iconsax.shield_tick,
            size: 48,
            color: const Color(0xFFBDBDBD),
          ),
          const SizedBox(height: 12),
          Text(
            _mode == 'writer'
                ? '告诉我你想写什么'
                : 'Halo 会自动检测逻辑问题',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(Map<String, String> message) {
    final isUser = message['role'] == 'user';
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser 
              ? const Color(0xFF5C6BC0)
              : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message['content'] ?? '',
          style: TextStyle(
            fontSize: 14,
            color: isUser ? Colors.white : const Color(0xFF212121),
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildQuickAction('续写', Iconsax.arrow_right),
            _buildQuickAction('扩写', Iconsax.maximize),
            _buildQuickAction('缩写', Iconsax.minimize),
            _buildQuickAction('润色', Iconsax.brush_1),
            _buildQuickAction('检查逻辑', Iconsax.shield_tick),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        avatar: Icon(icon, size: 16),
        label: Text(label),
        backgroundColor: const Color(0xFFF5F5F5),
        side: BorderSide.none,
        onPressed: () => _handleQuickAction(label),
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFEEEEEE)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              decoration: const InputDecoration(
                hintText: '输入创作指令...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              maxLines: 1,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: _isProcessing ? null : _sendMessage,
            icon: _isProcessing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Iconsax.send_1),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF5C6BC0),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _handleQuickAction(String action) {
    _inputController.text = action;
    _sendMessage();
  }

  void _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _inputController.clear();
      _isProcessing = true;
    });

    // 模拟 AI 响应
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isProcessing = false;
        _messages.add({
          'role': 'assistant',
          'content': '好的，我来帮你${text}。这里是生成的文本内容...\n\n林逸深吸一口气，体内的真气开始流转。他的眼神变得坚定起来，仿佛已经看到了未来的道路。',
        });
      });
    }
  }
}
