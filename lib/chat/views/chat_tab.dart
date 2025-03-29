import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import 'package:tutorly/chat/exports.dart';
import 'package:tutorly/chat/utils/create_random_user.dart';
import 'package:tutorly/chat/utils/get_modern_message.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ChatSearchBar(),
        Expanded(
          child: FutureBuilder<List<types.Room>>(
            future: FirebaseChatCore.instance.rooms().first,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        Text('No Active Chats'),
                        ElevatedButton(
                          onPressed: () async {
                            await createRandomUser();
                          },
                          child: Text('Create Random User'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ChatList(rooms: snapshot.data!);
                }
              } else {
                return SizedBox();
              }
            },
          ),
        ),
      ],
    );
  }
}

class ChatList extends StatelessWidget {
  final List<types.Room> rooms;
  const ChatList({super.key, required this.rooms});

  Widget _buildAvatar(types.Room room) {
    var color = Colors.transparent;

    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
          (u) => u.id != FirebaseAuth.instance.currentUser!.uid,
        );
        color = getUserAvatarNameColor(otherUser);
      } catch (e) {
        // Do nothing if other user is not found.
      }
    }

    final hasImage = room.imageUrl != null;
    final name = room.name ?? '';

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child:
          hasImage
              ? ClipOval(
                child: CachedNetworkImage(
                  imageUrl: room.imageUrl!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          name.isEmpty ? '' : name[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                ),
              )
              : CircleAvatar(
                backgroundColor: color,
                radius: 20,
                child: Text(
                  name.isEmpty ? '' : name[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];
        return GestureDetector(
          onTap: () async {
            final currentUser = FirebaseChatCore.instance.firebaseUser;
            final otherUser = room.users.firstWhere(
              (u) => u.id != currentUser!.uid,
            );
            final List<types.Message> messages =
                await FirebaseChatCore.instance.messages(room).first;
            final initialMessages =
                messages.map((message) => message.toModern()).toList();

            if (!context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ChatRoom(
                      currentUserId: currentUser!.uid,
                      chatId: room.id,
                      otherUserName:
                          '${otherUser.firstName!} ${otherUser.lastName!}',
                      initialMessages: initialMessages,
                    ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(children: [_buildAvatar(room), Text(room.name ?? '')]),
          ),
        );
      },
    );
  }
}
