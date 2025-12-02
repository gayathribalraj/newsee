import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ChatMessage {
  final String id;
  final String text;
  final bool isCurrentUser;
  final DateTime timestamp;
  final String senderName;
  final String? filePath;
  final String? fileName;
  final String? fileType;
  final bool isEdited;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isCurrentUser,
    required this.timestamp,
    required this.senderName,
    this.filePath,
    this.fileName,
    this.fileType,
    this.isEdited = false,
  });

  ChatMessage copyWith({
    String? text,
    DateTime? timestamp,
    bool? isEdited,
  }) {
    return ChatMessage(
      id: id,
      text: text ?? this.text,
      isCurrentUser: isCurrentUser,
      timestamp: timestamp ?? this.timestamp,
      senderName: senderName,
      filePath: filePath,
      fileName: fileName,
      fileType: fileType,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}

class ChatWidget extends StatefulWidget {
  final String userName;
  final String queryType;
  final List<ChatMessage>? initialMessages;

  const ChatWidget({
    Key? key,
    required this.userName,
    required this.queryType,
    this.initialMessages,
  }) : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late ScrollController _scrollController;
  final TextEditingController _messageController = TextEditingController();
  late List<ChatMessage> messages;
  PlatformFile? selectedFile;

  static const Map<String, String> _fileTypeMap = {
    'jpg': 'image', 'jpeg': 'image', 'png': 'image', 'gif': 'image',
    'pdf': 'document', 'doc': 'document', 'docx': 'document',
    'xls': 'document', 'xlsx': 'document', 'txt': 'document',
  };

  static const Map<String, IconData> _fileIconMap = {
    'pdf': Icons.picture_as_pdf, 'doc': Icons.description, 'docx': Icons.description,
    'xls': Icons.table_chart, 'xlsx': Icons.table_chart,
    'jpg': Icons.image, 'jpeg': Icons.image, 'png': Icons.image, 'gif': Icons.image,
    'txt': Icons.text_fields,
  };

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    messages = widget.initialMessages ?? [];
    _loadDefaultMessages();
  }

  void _loadDefaultMessages() {
    if (messages.isEmpty) {
      messages = [
        ChatMessage(id: '1', text: 'Hello, I have a question about my loan application status.',
            isCurrentUser: true, timestamp: DateTime.now().subtract(Duration(minutes: 10)), senderName: widget.userName),
        ChatMessage(id: '2', text: 'Hi ${widget.userName}! I\'d be happy to help you with your query.',
            isCurrentUser: false, timestamp: DateTime.now().subtract(Duration(minutes: 8)), senderName: 'Support Team'),
        ChatMessage(id: '3', text: 'Regarding your ${widget.queryType} - your application is currently under review.',
            isCurrentUser: false, timestamp: DateTime.now().subtract(Duration(minutes: 5)), senderName: 'Support Team'),
        ChatMessage(id: '4', text: 'Thank you! When can I expect an update? Is there anything else I need to provide?',
            isCurrentUser: true, timestamp: DateTime.now().subtract(Duration(minutes: 2)), senderName: widget.userName),
        ChatMessage(id: '5', text: 'You should receive an update within 2-3 business days. We will notify you via email.',
            isCurrentUser: false, timestamp: DateTime.now().subtract(Duration(seconds: 30)), senderName: 'Support Team'),
      ];
      setState(() {});
    }
    Future.delayed(Duration(milliseconds: 300), _scrollToBottom);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'jpg', 'jpeg', 'png', 'gif', 'txt'],
      );
      if (result != null) setState(() => selectedFile = result.files.first);
    } catch (e) {
      _showSnackBar('Error picking file: $e');
    }
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty || selectedFile != null) {
      setState(() {
        messages.add(ChatMessage(
          id: DateTime.now().toString(),
          text: _messageController.text,
          isCurrentUser: true,
          timestamp: DateTime.now(),
          senderName: widget.userName,
          filePath: selectedFile?.path,
          fileName: selectedFile?.name,
          fileType: _getFileType(selectedFile?.name),
        ));
      });
      _messageController.clear();
      selectedFile = null;
      _scrollToBottom();

      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            messages.add(ChatMessage(
              id: DateTime.now().toString(),
              text: 'Thank you for your message. We will get back to you shortly.',
              isCurrentUser: false,
              timestamp: DateTime.now(),
              senderName: 'Support Team',
            ));
          });
          _scrollToBottom();
        }
      });
    }
  }

  String _getFileType(String? fileName) => fileName == null ? 'other' : (_fileTypeMap[fileName.split('.').last.toLowerCase()] ?? 'other');
  IconData _getFileIcon(String? fileName) => fileName == null ? Icons.insert_drive_file : (_fileIconMap[fileName.split('.').last.toLowerCase()] ?? Icons.insert_drive_file);
  
  String _getFileSize(String? filePath) {
    if (filePath == null) return '';
    try {
      final bytes = File(filePath).lengthSync();
      if (bytes < 1024) return '$bytes B';
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } catch (_) {
      return '';
    }
  }

  String _formatTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showSnackBar(String msg) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), duration: Duration(milliseconds: 1500)),
      );

  void _handleAction(String action, ChatMessage msg) {
    switch (action) {
      case 'edit':
        _messageController.text = msg.text;
        showDialog(context: context, builder: (c) => AlertDialog(
          title: Text('Edit Message'),
          content: TextField(controller: _messageController, maxLines: 3, decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Edit...')),
          actions: [
            TextButton(onPressed: () { _messageController.clear(); Navigator.pop(c); }, child: Text('Cancel')),
            TextButton(onPressed: () {
              setState(() {
                final idx = messages.indexWhere((m) => m.id == msg.id);
                if (idx != -1) messages[idx] = msg.copyWith(text: _messageController.text, isEdited: true);
              });
              _messageController.clear();
              Navigator.pop(c);
              _showSnackBar('Message updated');
            }, child: Text('Update')),
          ],
        ));
        break;
      case 'delete':
        showDialog(context: context, builder: (c) => AlertDialog(
          title: Text('Delete Message'),
          content: Text('Are you sure?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c), child: Text('Cancel')),
            TextButton(onPressed: () {
              setState(() => messages.removeWhere((m) => m.id == msg.id));
              Navigator.pop(c);
              _showSnackBar('Message deleted');
            }, child: Text('Delete', style: TextStyle(color: Colors.red))),
          ],
        ));
        break;
      case 'copy':
        if (msg.text.isNotEmpty) _showSnackBar('Copied: "${msg.text.substring(0, 20)}..."');
        break;
      case 'reply':
        _messageController.text = '@${msg.senderName} ';
        _showSnackBar('Replying to ${msg.senderName}');
        break;
      case 'share':
        _showSnackBar('Shared: "${msg.text}"');
        break;
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
        title: Row(children: [
          CircleAvatar(backgroundImage: NetworkImage('https://api.lorem.space/image?w=200&h=200&random=${widget.userName}'), radius: 20),
          SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.userName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(widget.queryType, style: TextStyle(fontSize: 12, color: Colors.white70)),
          ]),
        ]),
        elevation: 0,
      ),
      body: Column(children: [
        Expanded(child: ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          itemCount: messages.length,
          itemBuilder: (c, i) => _buildMessageBubble(messages[i]),
        )),
        _buildMessageInput(),
      ]),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final isCurrentUser = msg.isCurrentUser;
    final actions = msg.isCurrentUser ? ['edit', 'copy', 'delete', 'reply', 'share'] : ['copy', 'reply', 'share'];
    
    return Padding(padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Align(alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
          if (!isCurrentUser) Padding(padding: EdgeInsets.only(left: 12, bottom: 4),
            child: Text(msg.senderName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600]))),
          GestureDetector(onLongPress: () => showModalBottomSheet(context: context, builder: (c) => Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
            child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
              ...actions.map((a) => ListTile(
                leading: Icon([Icons.edit, Icons.copy, Icons.delete, Icons.reply, Icons.share][['edit', 'copy', 'delete', 'reply', 'share'].indexOf(a)], 
                    color: [Colors.blue, Colors.teal, Colors.red, Colors.green, Colors.purple][actions.indexOf(a)], size: 24),
                title: Text(['Edit', 'Copy', 'Delete', 'Reply', 'Share'][actions.indexOf(a)], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                onTap: () { Navigator.pop(c); _handleAction(a, msg); },
                contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              )),
              SizedBox(height: 12),
            ])),
          )),
            child: Container(constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: isCurrentUser ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(isCurrentUser ? 18 : 2), bottomRight: Radius.circular(isCurrentUser ? 2 : 18))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (msg.text.isNotEmpty) Text(msg.text, style: TextStyle(color: isCurrentUser ? Colors.white : Colors.black87, fontSize: 14, height: 1.4)),
                if (msg.fileName != null) ...[
                  SizedBox(height: msg.text.isNotEmpty ? 8 : 0),
                  msg.fileType == 'image' && msg.filePath != null ? ClipRRect(borderRadius: BorderRadius.circular(8),
                    child: Image.file(File(msg.filePath!), width: 200, height: 150, fit: BoxFit.cover)) :
                  GestureDetector(onTap: () => _showSnackBar('Opening: ${msg.filePath}'),
                    child: Container(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: isCurrentUser ? Colors.blue.withOpacity(0.2) : Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(_getFileIcon(msg.fileName), color: isCurrentUser ? Colors.white : Colors.black87, size: 20),
                        SizedBox(width: 8),
                        Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(msg.fileName ?? 'File', style: TextStyle(color: isCurrentUser ? Colors.white : Colors.black87, fontWeight: FontWeight.w500, fontSize: 12), overflow: TextOverflow.ellipsis),
                          if (_getFileSize(msg.filePath).isNotEmpty) Text(_getFileSize(msg.filePath), style: TextStyle(color: isCurrentUser ? Colors.white70 : Colors.black54, fontSize: 10)),
                        ])),
                        SizedBox(width: 8),
                        Icon(Icons.download, color: isCurrentUser ? Colors.white : Colors.black87, size: 18),
                      ]),
                    )),
                ],
              ]),
            )),
          Padding(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(_formatTime(msg.timestamp), style: TextStyle(fontSize: 11, color: Colors.grey[500]))),
        ]),
      ),
    );
  }

  Widget _buildMessageInput() => Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[300]!))),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      if (selectedFile != null) Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blue.withOpacity(0.3))),
        child: Row(children: [
          Icon(_getFileIcon(selectedFile!.name), color: Colors.blue, size: 20),
          SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(selectedFile!.name, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.black87), overflow: TextOverflow.ellipsis),
            Text('${(selectedFile!.size / 1024).toStringAsFixed(1)} KB', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
          ])),
          SizedBox(width: 8),
          GestureDetector(onTap: () => setState(() => selectedFile = null), child: Icon(Icons.close, color: Colors.red, size: 18)),
        ]),
      ),
      Row(children: [
        IconButton(icon: Icon(Icons.attach_file, color: Colors.blue), onPressed: _pickFile),
        Expanded(child: TextField(controller: _messageController, decoration: InputDecoration(
          hintText: 'Type your message...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.grey[300]!)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10), suffixIcon: Icon(Icons.emoji_emotions, color: Colors.grey)),
          maxLines: 1, textInputAction: TextInputAction.send, onSubmitted: (_) => _sendMessage())),
        IconButton(icon: Icon(Icons.send, color: Colors.blue), onPressed: _sendMessage),
      ]),
    ]),
  );
}
