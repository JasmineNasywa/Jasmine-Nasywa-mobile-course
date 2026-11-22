
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Halo! 👋',
      'isUser': false,
      'time': '09:00',
    },
    {
      'text':
          'Saya Campus Assistant. Saya siap membantu kamu mencari informasi akademik, memahami pengumuman kampus, dan menjawab pertanyaan seputar perkuliahan.',
      'isUser': false,
      'time': '09:00',
    },
  ];

  bool _isTyping = false;

  void _sendMessage([String? suggestedMessage]) {
    final text = suggestedMessage ?? _controller.text.trim();

    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'text': text,
        'isUser': true,
        'time': TimeOfDay.now().format(context),
      });

      _controller.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Simulasi respons untuk preview UI.
    // Nanti bagian ini diganti dengan pemanggilan AiService.
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        _isTyping = false;
        _messages.add({
          'text':
              'Terima kasih atas pertanyaannya! Fitur AI Campus Assistant sedang dalam tahap integrasi.',
          'isUser': false,
          'time': TimeOfDay.now().format(context),
        });
      });

      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF315CDB);
    const backgroundColor = Color(0xFFF7F8FC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF20243A)),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Campus Assistant',
                  style: TextStyle(
                    color: Color(0xFF20243A),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Icons.circle, color: Colors.green, size: 8),
                    SizedBox(width: 5),
                    Text(
                      'AI Assistant',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _messages.clear();
                _isTyping = false;
              });
            },
            icon: const Icon(
              Icons.refresh_rounded,
              color: Color(0xFF555B70),
            ),
            tooltip: 'New conversation',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(18),
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'TODAY',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                ..._messages.map((message) {
                  return _buildMessage(
                    message['text'] as String,
                    message['isUser'] as bool,
                    message['time'] as String,
                  );
                }),

                if (_messages.length <= 2) ...[
                  const SizedBox(height: 20),
                  const Text(
                    'What can I help you with?',
                    style: TextStyle(
                      color: Color(0xFF20243A),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSuggestion(
                    Icons.campaign_outlined,
                    'Cari informasi pengumuman kampus',
                  ),
                  _buildSuggestion(
                    Icons.calendar_month_outlined,
                    'Bantu saya memahami jadwal kuliah',
                  ),
                  _buildSuggestion(
                    Icons.school_outlined,
                    'Tips mengatur waktu belajar',
                  ),
                ],

                if (_isTyping) _buildTypingIndicator(),
              ],
            ),
          ),

          _buildInputArea(primaryColor),
        ],
      ),
    );
  }

  Widget _buildMessage(String text, bool isUser, String time) {
    const primaryColor = Color(0xFF315CDB);

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: primaryColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 9),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isUser ? primaryColor : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(17),
                      topRight: const Radius.circular(17),
                      bottomLeft: Radius.circular(isUser ? 17 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 17),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.025),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isUser ? Colors.white : const Color(0xFF30354A),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 5),
        ],
      ),
    );
  }

  Widget _buildSuggestion(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: InkWell(
        onTap: () => _sendMessage(text),
        borderRadius: BorderRadius.circular(13),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0xFFE8EAF2)),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF315CDB), size: 19),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xFF454B60),
                    fontSize: 12,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
                size: 13,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 16,
          backgroundColor: Color(0xFFE8EDFF),
          child: Icon(
            Icons.smart_toy_rounded,
            color: Color(0xFF315CDB),
            size: 17,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Text(
            'AI sedang mengetik...',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputArea(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFEDEEF3)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: 'Tanyakan sesuatu...',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F6FA),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 13,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 48,
              width: 48,
              child: ElevatedButton(
                onPressed: _isTyping ? null : () => _sendMessage(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                child: const Icon(Icons.send_rounded, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
