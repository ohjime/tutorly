import 'dart:async';

import 'package:cross_cache/cross_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:flyer_chat_image_message/flyer_chat_image_message.dart';
import 'package:flyer_chat_text_message/flyer_chat_text_message.dart';
import 'package:tutorly/chat/exports.dart';
import 'package:uuid/uuid.dart';

class ChatRoom extends StatefulWidget {
  final String otherUserName;
  final String currentUserId;
  final String chatId;
  final List<Message> initialMessages;

  const ChatRoom({
    super.key,
    required this.currentUserId,
    required this.chatId,
    required this.initialMessages,
    required this.otherUserName,
  });

  @override
  ChatRoomState createState() => ChatRoomState();
}

class ChatRoomState extends State<ChatRoom> {
  // Helps cache images to avoid flickering when scrolling
  final _crossCache = CrossCache();

  // Chat controller to manage messages
  late final ChatController _chatController;

  get uuid => Uuid();

  @override
  void initState() {
    super.initState();
    _chatController = InMemoryChatController(messages: widget.initialMessages);
    // Here is where you would initalize flutter_chat_firebase_core
  }

  @override
  void dispose() {
    _chatController.dispose();
    _crossCache.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.otherUserName)),
      body: Stack(
        children: [
          Chat(
            builders: Builders(
              textMessageBuilder:
                  (context, message, index) =>
                      FlyerChatTextMessage(message: message, index: index),
              imageMessageBuilder:
                  (context, message, index) =>
                      FlyerChatImageMessage(message: message, index: index),
              inputBuilder:
                  (context) => ChatInput(
                    topWidget: InputActionBar(
                      buttons: [
                        InputActionButton(
                          icon: Icons.bookmark_add,
                          title: 'Schedule a Session',
                          onPressed: () => _addItem(null),
                        ),
                      ],
                    ),
                  ),
            ),
            chatController: _chatController,
            crossCache: _crossCache,
            currentUserId: widget.currentUserId,
            onMessageSend: _addItem,
            onMessageTap: _removeItem,
            resolveUser: (id) {
              // Need to replace to use flutter_chat_firebase_core,
              // but not sure what it does.
              final users = const {
                'john': User(id: 'john'),
                'jane': User(id: 'jane'),
              };
              return Future.value(users[id]);
            },
            theme: ChatTheme.fromThemeData(theme),
          ),
        ],
      ),
    );
  }

  void _addItem(String? text) async {
    // 1. Create a PartialText message (from flutter_chat_types)
    final partialText = types.PartialText(
      text: text ?? lorem(paragraphs: 1, words: 20),
    );

    try {
      // 2. Send to Firebase first:
      //    This inserts a doc in Firestore with a unique ID.
      //    By default, sendMessage does not return the doc ID directly,
      //    but the message will appear in the Firestore collection
      //    and eventually in the FirebaseChatCore.instance.messages(...) stream.
      FirebaseChatCore.instance.sendMessage(partialText, widget.chatId);

      // 3. Insert into your local ChatController so you see the message immediately.
      //    If you want the same ID that Firestore generates, you’ll need to
      //    either (a) listen to the stream of messages from Firestore
      //    or (b) rely on the fact that flutter_chat_core will re-emit the
      //    official message with its final ID.
      //    For now, you can use a placeholder ID or skip the local insert
      //    and rely purely on the Firestore stream.

      // Example: create a local placeholder message
      final placeholderId = uuid.v4(); // or just use your own local ID
      final message = TextMessage(
        id: placeholderId,
        authorId: widget.currentUserId,
        createdAt: DateTime.now().toUtc(),
        text: partialText.text,
        isOnlyEmoji: isOnlyEmoji(partialText.text),
        status: MessageStatus.sent,
      );

      // Insert the local placeholder
      await _chatController.insert(message);

      // You could optionally update the placeholder once you know the final doc ID
      // if you have a callback or a stream that tells you the real ID from Firestore.
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void _removeItem(Message item, {int? index, TapUpDetails? details}) async {
    await _chatController.remove(item);
    // Attempt to delete the emssage in flutter_chat_firebase_core
  }
}
