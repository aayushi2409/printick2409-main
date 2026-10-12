import 'package:flutter/material.dart';
import 'package:printick/providers/notification_provider.dart';
import 'package:printick/screens/user/notifications/notification_screen.dart';
import 'package:printick/screens/user/profile/profile_screen.dart';
// import 'package:printick/services/supabase_service.dart';
import '../upload/upload_screen.dart';
import 'package:provider/provider.dart';
import 'package:printick/providers/auth_provider.dart';
import 'package:printick/screens/user/orders/orders_screen.dart';
// import 'package:printick/screens/user/order/order_screen.dart';
import 'package:printick/services/global_queue_service.dart';

import 'package:printick/services/admin_notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final PageController _controller = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  List<Widget> get _screens => [
    _buildHomeContent(),
    const UploadScreen(),
    const OrdersScreen(), // 🔥 dynamic logic
    // const OrdersScreen(),
    const ProfileScreen(),
  ];
  @override
  void initState() {
    super.initState(); // ✅ ALWAYS FIRST

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    Future.delayed(const Duration(seconds: 2), _autoSlide);

    /// 🔥 ADD THIS (AUTH VALIDATION)
    Future.microtask(() {
      context.read<AppAuthProvider>().validateUser();
    });
  }

  String _getPrinterText(String status) {
    switch (status) {
      case "offline":
        return "🔴 Offline";
      case "active":
        return "🟢 Active";
      default:
        return "⚪ Idle";
    }
  }

  Color _getPrinterColor(String status) {
    switch (status) {
      case "offline":
        return const Color.fromARGB(255, 167, 46, 37);
      case "active":
        return const Color.fromARGB(255, 52, 132, 55);
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _autoSlide() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 4));

      if (_currentPage < 5) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,

      onPopInvokedWithResult: (didPop, result) {
        /// 🔥 IF NOT HOME TAB
        if (_selectedIndex > 0) {
          setState(() {
            _selectedIndex=0;
            // _selectedIndex--;
          });

          return;
        }

        /// 🔥 EXIT APP
        Navigator.pop(context);
      },

      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: _screens),

        /// 🔽 BOTTOM NAV
        bottomNavigationBar: NavigationBar(
          height: 70,
          backgroundColor: Colors.white,
          elevation: 10,
          indicatorColor: const Color(0xFF4D48FF).withOpacity(0.12),
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: "Home",
            ),

            NavigationDestination(
              icon: Icon(Icons.upload_file_outlined),
              selectedIcon: Icon(Icons.upload_file_rounded),
              label: "Upload",
            ),

            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long_rounded),
              label: "Orders",
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person_rounded),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 183, 191, 242),
            Color.fromARGB(255, 229, 177, 228),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            /// 🔝 HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Greeting
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hello 👋",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 25, 25, 44),
                        ),
                      ),
                      const SizedBox(height: 1),

                      Consumer<AppAuthProvider>(
                        builder: (context, auth, child) {
                          if (!auth.isProfileLoaded) {
                            return const SizedBox(
                              height: 20,
                              child: LinearProgressIndicator(),
                            );
                          }

                          final firstName = (auth.name ?? "User")
                              .split(" ")
                              .first;

                          return Text(
                            firstName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  /// Icons
                  Row(
                    children: [
                      _iconButton(Icons.search),
                      const SizedBox(width: 10),
                      Consumer<NotificationProvider>(
                        builder: (context, provider, child) {
                          return Stack(
                            clipBehavior: Clip.none,

                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const NotificationScreen(),
                                    ),
                                  );
                                },

                                child: _iconButton(
                                  Icons.notifications_none_rounded,
                                ),
                              ),

                              if (provider.unreadCount > 0)
                                Positioned(
                                  right: -2,
                                  top: -4,

                                  child: Container(
                                    padding: const EdgeInsets.all(6),

                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),

                                    child: Text(
                                      provider.unreadCount > 9
                                          ? '9+'
                                          : provider.unreadCount.toString(),

                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// 🔥 BODY
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 220,
                    child: PageView(
                      controller: _controller,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      children: [
                        _featureCard(
                          title: "Upload and Print Effortlessly 🚀",
                          subtitle:
                              "Do your work freely, We'll handle the printing",
                          icon: Icons.print_rounded,
                        ),

                        _featureCard(
                          title: "No More “Bheed-Bhaad” 😌",
                          subtitle: "Skip library lines and waiting Time",
                          icon: Icons.groups_rounded,
                        ),

                        _featureCard(
                          title: "Pick Anytime ⏰",
                          subtitle:
                              "Collect your prints from library When it's Ready",
                          icon: Icons.flash_on_rounded,
                        ),
                        _featureCard(
                          title: "Token-Based Orders 🎟️",
                          subtitle: "Place your order based on available slots",
                          icon: Icons.confirmation_number_rounded,
                        ),

                        _featureCard(
                          title: "Smart Queue System 🔢",
                          subtitle:
                              "Your print will be processed as per your turn",
                          icon: Icons.schedule_rounded,
                        ),

                        _featureCard(
                          title: "Only ₹1 per page💸",
                          subtitle: "Affordable for every student",
                          icon: Icons.currency_rupee_rounded,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 16 : 8,
                        curve: Curves.easeInOutCubic,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? const Color(0xFF4D48FF)
                              : const Color.fromARGB(255, 62, 62, 62),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 25),

                  //// 🔥 PREMIUM LIVE STATUS CARD
                  Container(
                    height: 280,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 224, 224, 241),
                          Color.fromARGB(255, 188, 162, 241),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 🔹 TITLE + LIVE INDICATOR
                          Row(
                            children: [
                              const Text(
                                "Library Printing Status",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),

                              /// LIVE DOT
                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  double scale = 1 + (_animation.value * 0.8);

                                  return Transform.scale(
                                    scale: scale,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.green.withOpacity(
                                              0.95,
                                            ),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 22),

                          /// 🔹 STATUS ITEMS
                          StreamBuilder<Map<String, dynamic>>(
                            stream: GlobalQueueService.streamGlobalStatus(),
                            builder: (context, queueSnapshot) {
                              if (!queueSnapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              final queue = queueSnapshot.data!['queue'];
                              final time = queueSnapshot.data!['time'];

                              return StreamBuilder<String>(
                                stream:
                                    GlobalQueueService.streamPrinterStatus(),
                                builder: (context, statusSnapshot) {
                                  if (!statusSnapshot.hasData) {
                                    return const SizedBox();
                                  }

                                  final status = statusSnapshot.data!;

                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _StatusItem(
                                        icon: Icons.print,
                                        label: "(Printer status)",
                                        value: _getPrinterText(status),
                                        color: _getPrinterColor(status),
                                      ),

                                      _StatusItem(
                                        icon: Icons.people,
                                        label: "(People in Line)",
                                        value: status == "offline"
                                            ? "--"
                                            : "$queue in line",
                                        color: const Color.fromARGB(
                                          255,
                                          174,
                                          49,
                                          40,
                                        ),
                                      ),

                                      _StatusItem(
                                        icon: Icons.timer,
                                        label:
                                            "(Waiting Time If you order now)",
                                        value: status == "offline"
                                            ? "--"
                                            : queue == 0
                                            ? "2 min"
                                            : "~$time min",
                                        color: const Color.fromARGB(
                                          255,
                                          27,
                                          126,
                                          207,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔘 ICON BUTTON
  static Widget _iconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 20),
    );
  }

  Widget _featureCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4D48FF), Color(0xFF7A64FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4D48FF).withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                ),
              ],
            ),
          ),

          /// ICON
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatusItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Color.fromARGB(172, 0, 0, 0),
            ),
          ),
        ],
      ),
    );
  }
}
