import 'package:flutter/material.dart';
import 'package:outty/core/constants/color_constants.dart';
import 'package:outty/core/constants/text_styles.dart';
import 'package:outty/core/routes/route_names.dart';
import 'package:outty/features/chat/providers/chat_provider.dart';
import 'package:outty/shared/layouts/main_layout.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final chatProvider = Provider.of<ChatProvider>(context);
    final chatRooms = chatProvider.chatRooms;

    final List<Map<String, dynamic>> newMatches = [
      {
        'id': '1',
        'name': 'Jessica',
        'images': ['images/user11.jpg'],
        'isOnline': true,
        'age': 28,
        'distance': '3 miles away',
        'distanceValue': 3.0,
        'bio': 'Love hiking and outdoor adventures',
        'interests': ['Hiking', 'Photography', 'Travel'],
        'occupation': 'Photographer',
        'education': 'Art Institute',
      },
      {
        'id': '2',
        'name': 'Michael',
        'images': ['images/user51.jpg'],
        'isOnline': false,
        'age': 32,
        'distance': '5 miles away',
        'distanceValue': 5.0,
        'bio': 'Software engineer who loves coffee and hiking',
        'interests': ['Coding', 'Coffee', 'Hiking'],
        'occupation': 'Software Engineer',
        'education': 'Stanford University',
      },
      {
        'id': '3',
        'name': 'Sophia',
        'images': ['images/user21.jpg'],
        'isOnline': true,
        'age': 27,
        'distance': '1 mile away',
        'distanceValue': 1.0,
        'bio': 'Artist and yoga enthusiast',
        'interests': ['Art', 'Yoga', 'Music'],
        'occupation': 'Graphic Designer',
        'education': 'RSID',
      },
      {
        'id': '4',
        'name': 'David',
        'images': ['images/user41.jpg'],
        'isOnline': false,
        'age': 30,
        'distance': '7 mile away',
        'distanceValue': 7.0,
        'bio': 'Fitness coach who loves outdoor activies',
        'interests': ['Fitness', 'Nutrition', 'Sports'],
        'occupation': 'Personal Trainer',
        'education': 'University of Michigan',
      },
    ];
    return MainLayout(
      currentIndex: 1,
      child: Scaffold(
        backgroundColor: isDarkMode
            ? AppColors.backgroundDark
            : Colors.grey.shade50,
        appBar: AppBar(
          title: Text(
            'Messages',
            style: TextStyle(
              color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          backgroundColor: isDarkMode
              ? AppColors.backgroundDark
              : Colors.grey.shade50,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: isDarkMode ? Colors.white : Colors.grey.shade800,
              ),
            ),
          ],
        ),
        body: chatProvider.isLoading
            ? Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'New Matches',
                            style: AppTextStyles.h3Light.copyWith(
                              color: isDarkMode
                                  ? Colors.white
                                  : AppColors.textPrimaryLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, RouteNames.discover);
                            },
                            child: Text(
                              'See All',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 110,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: newMatches.length,
                        itemBuilder: (context, index) {
                          final match = newMatches[index];
                          return GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              AppColors.primary,
                                              Colors.purple,
                                            ],
                                          ),
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isDarkMode
                                                ? AppColors.backgroundDark
                                                : Colors.white,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              32,
                                            ),
                                            child: SizedBox(
                                              width: 64,
                                              height: 64,
                                              child: Image.asset(
                                                match['images'][0],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (match['isOnline'])
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            width: 14,
                                            height: 14,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: isDarkMode
                                                    ? AppColors.backgroundDark
                                                    : Colors.white,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),
                                  Text(
                                    match['name'],
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : AppColors.textPrimaryLight,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                      child: Text(
                        'Messages',
                        style: AppTextStyles.h3Light.copyWith(
                          color: isDarkMode
                              ? Colors.white
                              : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  chatRooms.isEmpty
                      ? SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade200,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    size: 48,
                                    color: isDarkMode
                                        ? Colors.grey.shade500
                                        : Colors.grey.shade400,
                                  ),
                                ),

                                const SizedBox(height: 24),
                                Text(
                                  'No Messages yet',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.grey.shade800,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Text(
                                    'Start matching with people to begin conversations',
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                const SizedBox(height: 32),

                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      RouteNames.discover,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text('Discover People'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final chatRoom = chatRooms[index];
                            return Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.grey.shade900
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    RouteNames.chat,
                                    arguments: chatRoom,
                                  );
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.1),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(28),
                                              child: SizedBox(
                                                width: 56,
                                                height: 56,
                                                child: Image.asset(
                                                  chatRoom.matchImage,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (chatRoom.isMatchOnline)
                                            Positioned(
                                              right: 0,
                                              bottom: 0,
                                              child: Container(
                                                width: 14,
                                                height: 14,
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: isDarkMode
                                                        ? Colors.grey.shade900
                                                        : Colors.white,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),

                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  chatRoom.matchName,
                                                  style: TextStyle(
                                                    color: isDarkMode
                                                        ? Colors.white
                                                        : AppColors
                                                              .textPrimaryLight,
                                                    fontWeight:
                                                        chatRoom.unreadCount > 0
                                                        ? FontWeight.bold
                                                        : FontWeight.w500,
                                                  ),
                                                ),

                                                Text(
                                                  _formatTime(
                                                    chatRoom.lastActivity ??
                                                        chatRoom.createdAt,
                                                  ),
                                                  style: TextStyle(
                                                    color:
                                                        chatRoom.unreadCount > 0
                                                        ? AppColors.primary
                                                        : (isDarkMode
                                                              ? Colors
                                                                    .grey
                                                                    .shade500
                                                              : Colors
                                                                    .grey
                                                                    .shade600),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        chatRoom.unreadCount > 0
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    chatRoom
                                                            .lastMessage
                                                            ?.content ??
                                                        'No messages yet',
                                                    style: TextStyle(
                                                      color:
                                                          chatRoom.unreadCount >
                                                              0
                                                          ? (isDarkMode
                                                                ? Colors.white
                                                                : AppColors
                                                                      .textPrimaryLight)
                                                          : (isDarkMode
                                                                ? Colors
                                                                      .grey
                                                                      .shade400
                                                                : Colors
                                                                      .grey
                                                                      .shade700),
                                                      fontWeight:
                                                          chatRoom.unreadCount >
                                                              0
                                                          ? FontWeight.w500
                                                          : FontWeight.normal,
                                                      fontSize: 14,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                if (chatRoom.unreadCount > 0)
                                                  Container(
                                                    padding: EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Text(
                                                      chatRoom.unreadCount
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }, childCount: chatRooms.length),
                        ),
                ],
              ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 1) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
