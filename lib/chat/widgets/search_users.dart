import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:tutorly/chat/exports.dart';
import 'package:tutorly/chat/utils/get_modern_message.dart';
// Make sure to import your chat core and types packages
// import 'package:your_chat_package/firebase_chat_core.dart';
// import 'package:your_chat_package/types.dart';

class ChatSearchBar extends StatefulWidget {
  const ChatSearchBar({super.key});

  @override
  State<ChatSearchBar> createState() => _ChatSearchBarState();
}

class _ChatSearchBarState extends State<ChatSearchBar> {
  final SearchController _searchController = SearchController();

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: _searchController,
      // Build the search bar
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          hintText: 'Search users',
          controller: controller,
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onTap: () => controller.openView(),
          onChanged: (_) => controller.openView(),
          leading: const Icon(Icons.search),
          trailing: [
            Tooltip(
              message: 'Change brightness mode',
              child: IconButton(icon: Icon(Icons.mic), onPressed: () {}),
            ),
          ],
        );
      },
      // Build the suggestions using a StreamBuilder
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return [
          // The StreamBuilder listens to your Firebase users stream.
          // Replace FirebaseChatCore.instance.users() with your own stream.
          StreamBuilder<List<types.User>>(
            stream:
                FirebaseChatCore.instance.users() as Stream<List<types.User>>?,
            initialData: const [],
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const ListTile(title: Text('No users found'));
              }
              // Get the list of users from the stream
              final users = snapshot.data!;
              // Filter the users based on the search query
              final filteredUsers =
                  users.where((user) {
                    return getUserName(
                      user,
                    ).toLowerCase().contains(controller.text.toLowerCase());
                  }).toList();

              if (filteredUsers.isEmpty) {
                return const ListTile(title: Text('No matching users'));
              }
              // Build a column of suggestion tiles for each user
              return Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    filteredUsers.map((user) {
                      return ListTile(
                        leading: _buildAvatar(user),
                        title: Text(getUserName(user)),
                        onTap: () {
                          _handlePressed(user, context);
                          // Optionally close the search suggestions after selection
                          controller.closeView(controller.text);
                        },
                      );
                    }).toList(),
              );
            },
          ),
        ];
      },
    );
  }
}

void _handlePressed(types.User otherUser, BuildContext context) async {
  final navigator = Navigator.of(context);
  final room = await FirebaseChatCore.instance.createRoom(otherUser);
  final currentUser = FirebaseChatCore.instance.firebaseUser;
  final List<types.Message> messages =
      await FirebaseChatCore.instance.messages(room).first;
  final initialMessages =
      messages.map((message) => message.toModern()).toList();

  navigator.pop();
  await navigator.push(
    MaterialPageRoute(
      builder:
          (context) => ChatRoom(
            currentUserId: currentUser!.uid,
            chatId: room.id,
            otherUserName: '${otherUser.firstName!} ${otherUser.lastName!}',
            initialMessages: initialMessages,
          ),
    ),
  );

  if (!context.mounted) return;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder:
          (context) => ChatRoom(
            currentUserId: currentUser!.uid,
            chatId: room.id,
            otherUserName: '${otherUser.firstName!} ${otherUser.lastName!}',
            initialMessages: initialMessages,
          ),
    ),
  );
}

// Function to build a user avatar
Widget _buildAvatar(types.User user) {
  var color = Colors.transparent;

  final hasImage = user.imageUrl != null;
  final name = getUserName(user);

  return Container(
    margin: const EdgeInsets.only(right: 16),
    child:
        hasImage
            ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: user.imageUrl!,
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
