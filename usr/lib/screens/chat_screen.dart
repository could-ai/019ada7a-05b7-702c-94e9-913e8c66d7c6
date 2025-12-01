import 'package:flutter/material.dart';
import '../models/message.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Initial mock data
  final List<Message> _messages = [
    Message(text: "Hello! How are you?", isMe: false, timestamp: DateTime.now().subtract(const Duration(minutes: 5))),
    Message(text: "I'm doing great, thanks! Working on a Flutter chat app.", isMe: true, timestamp: DateTime.now().subtract(const Duration(minutes: 4))),
    Message(text: "That sounds awesome! Flutter is great for cross-platform apps.", isMe: false, timestamp: DateTime.now().subtract(const Duration(minutes: 3))),
  ];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final text = _controller.text.trim();
    
    setState(() {
      _messages.add(
        Message(
          text: text,
          isMe: true,
          timestamp: DateTime.now(),
        ),
      );
      _controller.clear();
    });

    // Simulate a reply after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(
            Message(
              text: "Echo: $text", // Simple echo bot for now
              isMe: false,
              timestamp: DateTime.now(),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              // Using reverse: true so the list starts from the bottom
              reverse: true, 
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                // Because of reverse: true, index 0 is the bottom-most item (last in list)
                final message = _messages[_messages.length - 1 - index];
                return ChatBubble(message: message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
