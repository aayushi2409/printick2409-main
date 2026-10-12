import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:printick/providers/notification_provider.dart';
import 'package:printick/screens/user/notifications/widgets/notification_card.dart';

class NotificationScreen
    extends StatefulWidget {

  const NotificationScreen({
    super.key,
  });

  @override
  State<NotificationScreen>
      createState() =>
          _NotificationScreenState();
}

class _NotificationScreenState
    extends State<NotificationScreen> {

  @override
  void initState() {

    super.initState();

    Future.microtask(() {

      context
          .read<NotificationProvider>()
          .initialize();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFF7F8FC),

      appBar: AppBar(

        elevation: 0,

        backgroundColor:
            Colors.transparent,

        surfaceTintColor:
            Colors.transparent,

        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),

        // actions: [

        //   TextButton(

        //     onPressed: () {

        //       context
        //           .read<NotificationProvider>()
        //           .markAllAsRead();
        //     },

        //     child: const Text(
        //       'Mark all read',
        //     ),
        //   ),
        // ],
      ),
      floatingActionButtonLocation:
    FloatingActionButtonLocation.centerFloat,
    bottomNavigationBar: SafeArea(

  child: Padding(

    padding: const EdgeInsets.fromLTRB(
      18,
      0,
      18,
      14,
    ),

    child: Row(

      children: [

        /// MARK ALL READ
        Expanded(

          child: InkWell(

            borderRadius:
                BorderRadius.circular(18),

            onTap: () async {

              await context
                  .read<NotificationProvider>()
                  .markAllAsRead();
            },

            child: Container(

              height: 52,

              decoration: BoxDecoration(

                color:
                    Colors.white,

                borderRadius:
                    BorderRadius.circular(18),

                border: Border.all(
                  color:
                      Colors.black.withOpacity(0.05),
                ),
              ),

              child: const Row(

                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  Icon(
                    Icons.done_all_rounded,
                    size: 20,
                    color: Color(0xFF6C63FF),
                  ),

                  SizedBox(width: 8),

                  Text(
                    "Mark All Read",
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        /// CLEAR ALL
        Expanded(

          child: InkWell(

            borderRadius:
                BorderRadius.circular(18),

            onTap: () async {

              final shouldDelete =
                  await showDialog<bool>(

                context: context,

                builder: (context) {

                  return AlertDialog(

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(24),
                    ),

                    title: const Text(
                      "Delete Notifications?",
                    ),

                    content: const Text(
                      "Did you read all notifications? This action cannot be undone.",
                    ),

                    actions: [

                      TextButton(

                        onPressed: () {

                          Navigator.pop(
                            context,
                            false,
                          );
                        },

                        child: const Text(
                          "Cancel",
                        ),
                      ),

                      ElevatedButton(

                        style:
                            ElevatedButton.styleFrom(

                          backgroundColor:
                              const Color.fromARGB(255, 203, 29, 17),
                        ),

                        onPressed: () {

                          Navigator.pop(
                            context,
                            true,
                          );
                        },

                        child: const Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );

              if (shouldDelete == true) {

                await context
                    .read<NotificationProvider>()
                    .deleteAllNotifications();
              }
            },

            child: Container(

              height: 52,

              decoration: BoxDecoration(

                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 158, 46, 44),
                    Colors.red.shade500,
                  ],
                ),

                borderRadius:
                    BorderRadius.circular(18),
              ),

              child: const Row(

                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  Icon(
                    Icons.delete_sweep_rounded,
                    size: 20,
                    color: Colors.white,
                  ),

                  SizedBox(width: 8),

                  Text(
                    "Clear All",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  ),
),
      body: Consumer<NotificationProvider>(

        builder: (
          context,
          provider,
          child,
        ) {

          if (provider.isLoading) {

            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (provider.notifications.isEmpty) {

            return Center(

              child: Column(

                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  Icon(
                    Icons.notifications_off_rounded,
                    size: 90,
                    color: Colors.grey.shade400,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'No notifications yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Your order updates will appear here',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(

            onRefresh: () async {

              await provider.initialize();
            },

            child: ListView.builder(

              physics:

  const AlwaysScrollableScrollPhysics(
    parent: BouncingScrollPhysics(),
  ),

              padding: const EdgeInsets.all(18),

              itemCount:
                  provider.notifications.length,

              itemBuilder: (
                context,
                index,
              ) {

                final notification =
                    provider.notifications[index];

    return Dismissible(

  key: Key(notification.id),

  direction:
      DismissDirection.endToStart,

  background: Container(

    margin: const EdgeInsets.only(
      bottom: 14,
    ),

    padding: const EdgeInsets.only(
      right: 24,
    ),

    alignment: Alignment.centerRight,

    decoration: BoxDecoration(

      gradient: LinearGradient(
        colors: [
           const Color.fromARGB(255, 158, 46, 44),
                    Colors.red.shade500,
        ],
      ),

      borderRadius:
          BorderRadius.circular(24),
    ),

    child: const Icon(
      Icons.delete_rounded,
      color: Colors.white,
      size: 28,
    ),
  ),

  onDismissed: (_) async {

    await provider.deleteNotification(
      notification.id,
    );
  },

  child: NotificationCard(

    notification: notification,

    onTap: () async {

      await provider.markAsRead(
        notification.id,
      );
    },
  ),
);
              },
            ),
          );
        },
      ),
    );
  }
}