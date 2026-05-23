import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../features/map/screens/map_screen.dart';
import '../features/docs/presentation/screens/docs_list_screen.dart';
import '../features/chat/screens/chat_screen.dart';
import '../features/contribution/presentation/screens/contribution_screen.dart';
import '../features/profile/screens/profile_screen.dart';

/// ─── Main Navigation Shell ────────────────────────────────────────────────────
/// Hosts the 5 primary tabs with a custom bottom navigation bar.
/// Tab order: Map (default) | Documentation | AI Chat | Contribuer | Profile
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key, this.initialIndex = 0});

  /// Default to the Map tab (index 0) as the "home" tab.
  final int initialIndex;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  static const _screens = [
    MapScreen(),
    DocsListScreen(),
    ChatScreen(),
    ContributionScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

/// Custom styled bottom navigation bar.
class _AppBottomNavBar extends StatelessWidget {
  const _AppBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItem(icon: Icons.map_outlined, activeIcon: Icons.map_rounded, label: AppStrings.navMap),
    _NavItem(icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book_rounded, label: AppStrings.navDocs),
    _NavItem(icon: Icons.chat_bubble_outline_rounded, activeIcon: Icons.chat_bubble_rounded, label: AppStrings.navChat),
    _NavItem(icon: Icons.add_circle_outline_rounded, activeIcon: Icons.add_circle_rounded, label: AppStrings.navContribute),
    _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: AppStrings.navProfile),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: _items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isActive = currentIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Map tab (home) gets a special pill indicator
                      if (index == 0)
                        _MapTabIcon(isActive: isActive, item: item)
                      else
                        _DefaultTabIcon(isActive: isActive, item: item),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

/// Regular tab icon + label.
class _DefaultTabIcon extends StatelessWidget {
  const _DefaultTabIcon({required this.isActive, required this.item});

  final bool isActive;
  final _NavItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isActive ? item.activeIcon : item.icon,
          color: isActive ? AppColors.primary : AppColors.textSecondary,
          size: 24,
        ),
        const SizedBox(height: 2),
        Text(
          item.label,
          style: GoogleFonts.hankenGrotesk(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Map (main) tab – gets a larger pill-shaped active indicator.
class _MapTabIcon extends StatelessWidget {
  const _MapTabIcon({required this.isActive, required this.item});

  final bool isActive;
  final _NavItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            isActive ? item.activeIcon : item.icon,
            color: isActive ? AppColors.textLight : AppColors.textSecondary,
            size: 24,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          item.label,
          style: GoogleFonts.hankenGrotesk(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}
