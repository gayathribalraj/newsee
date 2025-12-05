import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cross_cache/cross_cache.dart';
import 'package:flyer_chat_image_message/flyer_chat_image_message.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;
import 'package:newsee/widgets/query_json.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:insta_image_viewer/insta_image_viewer.dart';

class ChatWidget extends StatefulWidget {
  final String userName;
  final String queryType;

  const ChatWidget({
    super.key,
    required this.userName,
    required this.queryType,
  });

  @override
  ChatWidgetState createState() => ChatWidgetState();
}

class ChatWidgetState extends State<ChatWidget> {
  final _chatController = InMemoryChatController();
  final _crossCache = CrossCache();
  final _scrollController = ScrollController();
  List<Map<String, dynamic>> storedMessages = [];

  @override
  void initState() {
    super.initState();
    loadMessagesFromPrefs();
  }

  Future<void> saveMessagesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> jsonMessages =
        storedMessages.map((msg) {
          final message = Map<String, dynamic>.from(msg);
          message["createdAt"] =
              (msg["createdAt"] as DateTime).toIso8601String();
          return jsonEncode(message);
        }).toList();

    await prefs.setStringList("chat${widget.userName}", jsonMessages);
  }

  Future<void> loadMessagesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? jsonMessages = prefs.getStringList("chat${widget.userName}");

    if (jsonMessages == null || jsonMessages.isEmpty) {
      // First time — Load your predefined messages
      storedMessages = initialMessages();
    } else {
      storedMessages =
          jsonMessages.map((jsonStr) {
            Map<String, dynamic> msg = jsonDecode(jsonStr);
            msg["createdAt"] = DateTime.parse(msg["createdAt"]);
            return msg;
          }).toList();
    }

    // Insert into UI
    for (var msg in storedMessages) {
      if (msg["type"] == "text") {
        _chatController.insertMessage(
          TextMessage(
            id: msg["id"],
            authorId: msg["authorId"],
            createdAt: msg["createdAt"],
            text: msg["text"],
          ),
        );
      } else if (msg["type"] == "image" &&
          msg["source"] != null &&
          msg["source"] != "") {
        _chatController.insertMessage(
          ImageMessage(
            id: msg["id"],
            authorId: msg["authorId"],
            createdAt: msg["createdAt"],
            source: msg["source"],
            size: msg["size"],
          ),
        );
      }
    }

    setState(() {});
  }

  Future<XFile?> compressImageToWebP() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) {
      return null;
    }

    // Get the temporary directory
    final Directory tempDir = await getTemporaryDirectory();
    // Define the target path with a .webp extension
    final String targetPath = p.join(
      tempDir.path,
      '${DateTime.now().millisecondsSinceEpoch}.webp',
    );

    // Compress the file and get the result as an XFile
    final XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
      pickedFile.path,
      targetPath,
      format: CompressFormat.webp,
      quality: 80,
      minWidth: 1000,
      minHeight: 1000,
    );

    return compressedFile;
  }

  void _handleAttachmentTap() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    await _crossCache.downloadAndSave(image.path);

    Map<String, dynamic> imageData = {
      "id": '${Random().nextInt(100000)}',
      "authorId": "user1",
      "createdAt": DateTime.now(),
      "text": "",
      "type": "image",
      "source": image.path,
      "size": await image.length(),
    };

    setState(() {
      storedMessages.add(imageData);

      _chatController.insertMessage(
        ImageMessage(
          id: imageData["id"],
          authorId: imageData["authorId"],
          createdAt: imageData["createdAt"],
          source: imageData["source"],
          size: imageData["size"],
        ),
      );
    });

    await saveMessagesToPrefs();
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    _crossCache.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.userName} • ${widget.queryType}')),
      body: ChangeNotifierProvider.value(
        value: _scrollController,
        child: Chat(
          builders: Builders(
            chatAnimatedListBuilder: (context, itemBuilder) {
              return ChatAnimatedList(
                scrollController: _scrollController,
                itemBuilder: itemBuilder,
                shouldScrollToEndWhenAtBottom: false,
              );
            },
            imageMessageBuilder:
                (
                  context,
                  message,
                  index, {
                  required bool isSentByMe,
                  MessageGroupStatus? groupStatus,
                }) => GestureDetector(
                  onTap: () {
                     
                    showDialog(
                      context: context,
                      builder: (_) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: EdgeInsets.zero,
                          child: InstaImageViewer(
                            child: Image.file(
                              File(message.source),
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: FlyerChatImageMessage(
                    message: message,
                    index: index,
                    showTime: true,
                    showStatus: true,
                  ),
                ),
          ),

          chatController: _chatController,
          currentUserId: 'user1',

          onMessageSend: (text) {
            Map<String, dynamic> textData = {
              "id": '${Random().nextInt(100000)}',
              "authorId": 'user1',
              "createdAt": DateTime.now().toUtc(),
              "text": text,
              "type": "text",
              "source": "",
              "size": "",
            };
            setState(() {
              storedMessages.add(textData);
              final textMessage = TextMessage(
                id: textData['id'],
                authorId: textData['authorId'],
                createdAt: textData['createdAt'],
                text: textData['text'],
              );
              _chatController.insertMessage(textMessage);
              saveMessagesToPrefs();
            });
          },
          onAttachmentTap: () async {
            _handleAttachmentTap();
            await saveMessagesToPrefs();
          },

          resolveUser: (UserID id) async {
            if (id == 'user1') {
              return User(id: id, name: widget.userName);
            }
            return null;
          },
        ),
      ),
    );
  }
}
