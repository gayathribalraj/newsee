// import 'package:flutter/material.dart';
// import 'package:chat_bubbles/chat_bubbles.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class QueryInboxDetails extends StatefulWidget {
//   final String title;
//   const QueryInboxDetails({Key? key, required this.title}) : super(key: key);

//   @override
//   State<QueryInboxDetails> createState() => _QueryInboxDetailsState();
// }

// class _QueryInboxDetailsState extends State<QueryInboxDetails> {
//   final AudioPlayer audioPlayer = AudioPlayer();
//   final TextEditingController _textController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   // Audio state
//   Duration duration = Duration.zero;
//   Duration position = Duration.zero;
//   bool isPlaying = false;
//   bool isLoading = false;
//   bool isPause = false;

//   List<Widget> messages = [];

//   @override
//   void initState() {
//     super.initState();
//     _setupAudioPlayer();
//     _loadInitialMessages();
//   }

//   void _setupAudioPlayer() {
//     audioPlayer.onDurationChanged.listen((d) {
//       setState(() => duration = d);
//     });

//     audioPlayer.onPositionChanged.listen((p) {
//       setState(() => position = p);
//     });

//     audioPlayer.onPlayerComplete.listen((_) {
//       setState(() {
//         isPlaying = false;
//         isPause = false;
//         position = Duration.zero;
//       });
//     });
//   }

//   void _loadInitialMessages() {
//     final now = DateTime.now();
//     messages = [
//       BubbleNormalImage(
//         id: 'id001',
//         image: _image(),
//         color: Colors.purpleAccent,
//         tail: true,
//         delivered: true,
//         isSender: false,
//       ),

//       // THIS IS THE FIXED AUDIO BUBBLE
//       StatefulBuilder(
//         builder: (context, setStateAudio) {
//           return BubbleNormalAudio(
//             color: const Color(0xFFE8E8EE),
//             duration: duration.inSeconds.toDouble(),
//             position: position.inSeconds.toDouble(),
//             isPlaying: isPlaying,
//             isLoading: isLoading,
//             isPause: isPause,
//             onSeekChanged: (value) {
//               audioPlayer.seek(Duration(seconds: value.toInt()));
//             },
//             onPlayPauseButtonClick: () async {
//               await _playPauseAudio(setStateAudio); // Pass local setState
//             },
//             sent: true,
//             isSender: true,
//           );
//         },
//       ),

//       BubbleNormal(
//         text: 'bubble normal with tail',
//         isSender: false,
//         color: const Color(0xFF1B97F3),
//         tail: true,
//         textStyle: const TextStyle(fontSize: 20, color: Colors.white),
//       ),
//       BubbleNormal(
//         text: 'bubble normal with tail',
//         isSender: true,
//         color: const Color(0xFFE8E8EE),
//         tail: true,
//         sent: true,
//       ),
//       DateChip(date: DateTime(now.year, now.month, now.day - 2)),
//       const SizedBox(height: 100),
//     ];
//   }

//   Future<void> _playPauseAudio(StateSetter setStateAudio) async {
//     const url = 'https://download.samplelib.com/mp3/sample-15s.mp3';

//     if (isPlaying) {
//       await audioPlayer.pause();
//       setState(() {
//         isPlaying = false;
//         isPause = true;
//       });
//       setStateAudio(() {}); // Force bubble to rebuild
//     } else if (isPause) {
//       await audioPlayer.resume();
//       setState(() {
//         isPlaying = true;
//         isPause = false;
//       });
//       setStateAudio(() {});
//     } else {
//       setState(() => isLoading = true);
//       setStateAudio(() {});
//       await audioPlayer.play(UrlSource(url));
//       setState(() {
//         isPlaying = true;
//         isLoading = false;
//         isPause = false;
//       });
//       setStateAudio(() {});
//     }
//   }

//   void _sendMessage() {
//     if (_textController.text.trim().isEmpty) return;

//     final text = _textController.text.trim();
//     setState(() {
//       messages.insert(messages.length - 1,
//         BubbleNormal(
//           text: text,
//           isSender: true,
//           color: const Color(0xFFE8E8EE),
//           tail: true,
//           sent: true,
//           textStyle: const TextStyle(fontSize: 16),
//         ),
//       );
//     });
//     _textController.clear();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     });
//   }

//   Widget _image() {
//     return Container(
//       constraints: const BoxConstraints(minHeight: 20.0, minWidth: 20.0),
//       child: CachedNetworkImage(
//         imageUrl: 'https://i.ibb.co/JCyT1kT/Asset-1.png',
//         placeholder: (context, url) => const CircularProgressIndicator(),
//         errorWidget: (context, url, error) => const Icon(Icons.error),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.title)),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             controller: _scrollController,
//             padding: const EdgeInsets.only(bottom: 80),
//             child: Column(children: messages),
//           ),

//           // Working Input Bar
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//               color: Colors.white,
//               child: Row(
//                 children: [
//                   InkWell(child: const Icon(Icons.add, size: 28), onTap: () {}),
//                   const SizedBox(width: 8),
//                   InkWell(child: const Icon(Icons.camera_alt, color: Colors.green, size: 28), onTap: () {}),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: TextField(
//                       controller: _textController,
//                       decoration: InputDecoration(
//                         hintText: "Type a message...",
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                       ),
//                       onSubmitted: (_) => _sendMessage(),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   GestureDetector(
//                     onTap: _sendMessage,
//                     child: const CircleAvatar(
//                       radius: 22,
//                       backgroundColor: Colors.blue,
//                       child: Icon(Icons.send, color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     audioPlayer.dispose();
//     _textController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:chat_package/chat_package.dart';
// import 'package:chat_package/models/chat_message.dart';

// class QueryInboxDetails extends StatefulWidget {
//   @override
//   State<QueryInboxDetails> createState() => _QueryInboxDetailsState();
// }

// class _QueryInboxDetailsState extends State<QueryInboxDetails> {
//   late ScrollController _scrollCtrl;
//   final List<ChatMessage> messages = [];

//   final TextEditingController textCtrl = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _scrollCtrl = ScrollController();
//   }

//   @override
//   void dispose() {
//     _scrollCtrl.dispose();
//     textCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Query Inbox Details")),

//       body: ChatScreen(
//         messages: messages,

//         /// Required input controllers
//         scrollController: _scrollCtrl,
//         textEditingController: textCtrl,

//         /// Chat UI colors
//         senderColor: Colors.blue,
//         receiverColor: Colors.grey.shade300,
//         activeAudioSliderColor: Colors.blueAccent,
//         inactiveAudioSliderColor: Colors.grey,

      

//         /// Text message callback
//         onTextSubmit: (ChatMessage msg) {
//           setState(() => messages.add(msg));

//           /// Auto-scroll
//           Future.delayed(Duration(milliseconds: 100), () {
//             _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
//           });
//         }, onImageSelected: (ChatMessage value) {
//           setState(() => messages.add(value));
//           }, onRecordComplete: (ChatMessage value) { 
//           setState(() => messages.add(value));

//           /// Auto-scroll
//           Future.delayed(Duration(milliseconds: 100), () {
//             _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
//           });
//          },

       
//       ),
//     );
//   }
// }
// chat_screen.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String userAvatar;

  const ChatScreen({
    Key? key,
    required this.userName,
    this.userAvatar = '',
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  List<Message> messages = [
    // Static initial messages
    Message(
      text: "Hey! How are you?",
      isMe: false,
      time: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Message(
      text: "I'm good! Just working on some Flutter stuff 🔥",
      isMe: true,
      time: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    Message(
      text: "Nice! What are you building?",
      isMe: false,
      time: DateTime.now().subtract(const Duration(minutes: 20)),
    ),
    Message(
      text: "A WhatsApp clone with clean architecture 😎",
      isMe: true,
      time: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    Message(
      text: "That's awesome! Send me the code later",
      isMe: false,
      time: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
  ];

  bool _isRecording = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      messages.add(Message(
        text: _controller.text.trim(),
        isMe: true,
        time: DateTime.now(),
      ));
    });

    _controller.clear();
    _scrollToBottom();
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

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo, color: Colors.purple),
              title: const Text('Gallery'),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.pink),
              title: const Text('Camera'),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file, color: Colors.blue),
              title: const Text('Document'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Document picker coming soon')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      Navigator.pop(context);
      setState(() {
        messages.add(Message(
          text: null,
          imagePath: pickedFile.path,
          isMe: true,
          time: DateTime.now(),
        ));
      });
      _scrollToBottom();
    }
  }

  void _showMessageOptions(Message message, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.isMe)
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  _editMessage(index);
                },
              ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy'),
              onTap: () {
                Navigator.pop(context);
                // Implement copy
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  messages.removeAt(index);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editMessage(int index) {
    _controller.text = messages[index].text ?? '';
    setState(() {
      messages.removeAt(index);
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.userAvatar.isNotEmpty
                  ? NetworkImage(widget.userAvatar)
                  : null,
              child: widget.userAvatar.isEmpty
                  ? Text(widget.userName[0].toUpperCase())
                  : null,
            ),
            const SizedBox(width: 12),
            Text(widget.userName),
          ],
        ),
        actions: const [
          Icon(Icons.call),
          SizedBox(width: 16),
          Icon(Icons.videocam),
          SizedBox(width: 16),
          Icon(Icons.more_vert),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(8),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              return GestureDetector(
                onLongPress: () => _showMessageOptions(msg, index),
                child: ChatBubble(message: msg),
              );
            },
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.teal),
              onPressed: _showAttachmentOptions,
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Message',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onLongPressStart: (_) {
                setState(() => _isRecording = true);
              },
              onLongPressEnd: (_) {
                setState(() => _isRecording = false);
                // Handle voice message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Voice message recorded')),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.teal,
                child: Icon(
                  _isRecording ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.teal,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _controller.text.trim().isEmpty ? null : _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// models/message.dart
class Message {
  final String? text;
  final String? imagePath;
  final bool isMe;
  final DateTime time;

  Message({
    this.text,
    this.imagePath,
    required this.isMe,
    required this.time,
  }) : assert(text != null || imagePath != null);
}

// widgets/chat_bubble.dart
class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isMe ? Colors.teal : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: message.isMe ? const Radius.circular(16) : const Radius.circular(0),
            bottomRight: message.isMe ? const Radius.circular(0) : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (message.imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(message.imagePath!),
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
            if (message.text != null)
              Text(
                message.text!,
                style: TextStyle(
                  color: message.isMe ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.time),
              style: TextStyle(
                fontSize: 10,
                color: message.isMe ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}