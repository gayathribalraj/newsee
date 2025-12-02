/*
 @author     : Gayathri B
   @date       : 02/12/2025
   @desc       : Query Details page displaying chat conversation.
                Shows chat messages between user and support staff with message input.
 */

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isCurrentUser;
  final DateTime timestamp;
  final String senderName;
  final String? imageUrl;
  final String? fileName;
  final String? fileExtension;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isCurrentUser,
    required this.timestamp,
    required this.senderName,
    this.imageUrl,
    this.fileName,
    this.fileExtension,
  });
}

class QueryDetails extends StatefulWidget {
  final String userName;
  final String queryType;

  const QueryDetails({
    Key? key,
    required this.userName,
    required this.queryType,
  }) : super(key: key);

  @override
  State<QueryDetails> createState() => _QueryDetailsState();
}

class _QueryDetailsState extends State<QueryDetails> {
  late ScrollController _scrollController;
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> messages = [];
  final List<PlatformFile> selectedFiles = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadInitialMessages();
  }

  void _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (result != null) {
        setState(() {
          selectedFiles.addAll(result.files);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _uploadFiles() {
    if (selectedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No files selected'),
          duration: Duration(milliseconds: 800),
        ),
      );
      return;
    }

    for (var file in selectedFiles) {
      final fileName = file.name;
      final fileExtension = fileName.split('.').last;

      setState(() {
        messages.add(
          ChatMessage(
            id: DateTime.now().toString(),
            text: 'File: $fileName',
            isCurrentUser: true,
            timestamp: DateTime.now(),
            senderName: widget.userName,
            fileName: fileName,
            fileExtension: fileExtension,
          ),
        );
      });
    }

    setState(() {
      selectedFiles.clear();
    });

    _scrollToBottom();

    // Simulate a reply from support
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          messages.add(
            ChatMessage(
              id: DateTime.now().toString(),
              text: 'Files received! We will review them shortly.',
              isCurrentUser: false,
              timestamp: DateTime.now(),
              senderName: 'Support Team',
            ),
          );
        });
        _scrollToBottom();
      }
    });
  }

  void _loadInitialMessages() {
    messages.addAll([
      ChatMessage(
        id: '1',
        text: 'Hello, I have a question about my loan application status.',
        isCurrentUser: true,
        timestamp: DateTime.now().subtract(Duration(minutes: 10)),
        senderName: widget.userName,
      ),
      ChatMessage(
        id: '2',
        text: 'Hi ${widget.userName}! I\'d be happy to help you with your query.',
        isCurrentUser: false,
        timestamp: DateTime.now().subtract(Duration(minutes: 8)),
        senderName: 'Support Team',
      ),
      ChatMessage(
        id: '3',
        text:
            'Regarding your ${widget.queryType} - your application is currently under review.',
        isCurrentUser: false,
        timestamp: DateTime.now().subtract(Duration(minutes: 5)),
        senderName: 'Support Team',
      ),
      ChatMessage(
        id: '4',
        text:
            'Thank you! When can I expect an update? Is there anything else I need to provide?',
        isCurrentUser: true,
        timestamp: DateTime.now().subtract(Duration(minutes: 2)),
        senderName: widget.userName,
      ),
      ChatMessage(
        id: '5',
        text:
            'You should receive an update within 2-3 business days. We will notify you via email.',
        isCurrentUser: false,
        timestamp: DateTime.now().subtract(Duration(seconds: 30)),
        senderName: 'Support Team',
      ),
    ]);
    setState(() {});
    Future.delayed(Duration(milliseconds: 300), _scrollToBottom);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final messageText = _messageController.text;

      setState(() {
        messages.add(
          ChatMessage(
            id: DateTime.now().toString(),
            text: messageText,
            isCurrentUser: true,
            timestamp: DateTime.now(),
            senderName: widget.userName,
          ),
        );
      });

      _messageController.clear();
      _scrollToBottom();

      // Simulate a reply from support
      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            messages.add(
              ChatMessage(
                id: DateTime.now().toString(),
                text:
                    'Thank you for your message. We will get back to you shortly.',
                isCurrentUser: false,
                timestamp: DateTime.now(),
                senderName: 'Support Team',
              ),
            );
          });
          _scrollToBottom();
        }
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                'https://api.lorem.space/image?w=200&h=200&random=${widget.userName}',
              ),
              radius: 20,
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.queryType,
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(messages[index]);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isCurrentUser = message.isCurrentUser;
    final hasFile = message.fileName != null;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isCurrentUser)
              Padding(
                padding: EdgeInsets.only(left: 12, bottom: 4),
                child: Text(
                  message.senderName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isCurrentUser ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(isCurrentUser ? 18 : 2),
                  bottomRight: Radius.circular(isCurrentUser ? 2 : 18),
                ),
              ),
              child: hasFile
                  ? _buildFileWidget(message)
                  : Text(
                      message.text,
                      style: TextStyle(
                        color: isCurrentUser ? Colors.white : Colors.black87,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                _formatTime(message.timestamp),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileWidget(ChatMessage message) {
    final fileName = message.fileName ?? 'File';
    final fileExtension = message.fileExtension ?? 'unknown';
    final isImage = ['jpg', 'jpeg', 'png', 'gif'].contains(fileExtension.toLowerCase());
    final isPdf = fileExtension.toLowerCase() == 'pdf';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isImage
                ? Icons.image
                : isPdf
                    ? Icons.picture_as_pdf
                    : Icons.description,
            color: message.isCurrentUser ? Colors.white : Colors.black87,
            size: 24,
          ),
        ),
        SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                fileName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: message.isCurrentUser ? Colors.white : Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                fileExtension.toUpperCase(),
                style: TextStyle(
                  color: message.isCurrentUser
                      ? Colors.white70
                      : Colors.black54,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // File preview section
          if (selectedFiles.isNotEmpty)
            Container(
              color: Colors.grey[100],
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 8),
                    child: Text(
                      'Selected Files (${selectedFiles.length})',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedFiles.length,
                      itemBuilder: (context, index) {
                        final file = selectedFiles[index];
                        final fileExtension = file.name.split('.').last;

                        return Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Stack(
                            children: [
                              Container(
                                width: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      fileExtension.toLowerCase() == 'pdf'
                                          ? Icons.picture_as_pdf
                                          : Icons.description,
                                      color: Colors.blue,
                                      size: 28,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      fileExtension.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: -8,
                                right: -8,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedFiles.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          // Input section
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.blue),
                  onPressed: _pickFile,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      suffixIcon: Icon(Icons.emoji_emotions, color: Colors.grey),
                    ),
                    maxLines: 1,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                if (selectedFiles.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.cloud_upload, color: Colors.green),
                    onPressed: _uploadFiles,
                    tooltip: 'Upload files',
                  )
                else
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.blue),
                    onPressed: _sendMessage,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}

