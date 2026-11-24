import 'package:fintrack_app/FAB%20pages/Categories.dart';
import 'package:fintrack_app/FAB%20pages/Chatbot.dart';
import 'package:fintrack_app/FAB%20pages/Transactions.dart';
import 'package:floaty_nav_bar/floaty_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fintrack_app/Main%20Screens/Analytics.dart';
import 'package:fintrack_app/Main%20Screens/Goals.dart';
import 'package:fintrack_app/Main%20Screens/Homepage.dart';
import 'Main Screens/Budget.dart';

class Navigation extends StatefulWidget {
  final int selectedIndex;
  const Navigation({super.key, this.selectedIndex = 0});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  late int currentIndex;
  bool isMenuOpen = false;

  static const Color _activeGreen = Color(0xFF43A047);

  static const double _fabSize = 56;
  static const double _navMarginH = 16;
  static const double _navMarginBottom = 16;
  static const double _fabGap = 10;
  static const double _menuCircleSize = 48;

  static List<Widget> get _pages => [
        Homepage(),
        Analytics(),
        const Goals(title: null, amount: null),
        BudgetScreen(),
      ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.selectedIndex.clamp(0, _pages.length - 1);
  }

  void _selectTab(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      currentIndex = index;
    });
  }

  void _toggleFabMenu() {
    HapticFeedback.mediumImpact();
    setState(() => isMenuOpen = !isMenuOpen);
  }

  FloatyActionButton get _sharedFab => FloatyActionButton(
        size: _fabSize,
        backgroundColor: _activeGreen,
        foregroundColor: Colors.white,
        heroTag: 'fintrack_main_fab',
        onTap: _toggleFabMenu,
        icon: Icon(
          isMenuOpen ? Icons.close_rounded : Icons.add_rounded,
          size: 28,
          color: Colors.white,
        ),
      );

  List<FloatyTab> _buildTabs() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unselectedIcon = isDark ? Colors.grey.shade300 : Colors.grey.shade700;

    final specs = [
      (title: 'Home', icon: Icons.home_rounded),
      (title: 'Stats', icon: Icons.bar_chart_rounded),
      (title: 'Goals', icon: Icons.flag_rounded),
      (title: 'Budget', icon: Icons.account_balance_wallet_rounded),
    ];

    const selectedTitleStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );

    return [
      for (var i = 0; i < specs.length; i++)
        FloatyTab(
          isSelected: currentIndex == i,
          title: specs[i].title,
          titleStyle: selectedTitleStyle,
          selectedColor: _activeGreen,
          unselectedColor: Colors.transparent,
          onTap: () => _selectTab(i),
          icon: Icon(
            specs[i].icon,
            size: currentIndex == i ? 24 : 22,
            color: currentIndex == i ? Colors.white : unselectedIcon,
          ),
        ),
    ];
  }

  /// Nav pill has border + shadow; FAB is a plain circle (package ties both to one shape).
  Widget _buildBottomBar(
    BuildContext context,
    ColorScheme scheme,
    bool isDark,
  ) {
    final navBg = isDark ? scheme.surfaceContainerHigh : Colors.white;
    final borderColor = isDark
        ? scheme.outline.withValues(alpha: 0.35)
        : const Color(0xFFE2E4E8);
    final navShadow = [
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.06),
        blurRadius: isDark ? 14 : 10,
        offset: Offset(0, isDark ? 5 : 3),
      ),
    ];
    final tabs = _buildTabs();
    final fab = _sharedFab;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          _navMarginH,
          0,
          _navMarginH,
          _navMarginBottom,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: ShapeDecoration(
                    color: navBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide(color: borderColor, width: 1),
                    ),
                    shadows: navShadow,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final tab in tabs)
                        FloatyTabWidget(
                          floatyTab: tab,
                          shape: const CircleShape(),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: _fabGap),
                SizedBox(
                  width: fab.size ?? _fabSize,
                  height: fab.size ?? _fabSize,
                  child: FloatingActionButton(
                    elevation: 4,
                    highlightElevation: 6,
                    shape: const CircleBorder(),
                    backgroundColor: fab.backgroundColor ?? _activeGreen,
                    foregroundColor: fab.foregroundColor ?? Colors.white,
                    heroTag: fab.heroTag,
                    onPressed: fab.onTap,
                    child: fab.icon,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final menuBottom = _stackedMenuBottom(context);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(
            index: currentIndex,
            children: _pages,
          ),
          if (isMenuOpen)
            GestureDetector(
              onTap: () => setState(() => isMenuOpen = false),
              child: Container(
                color: Colors.black54,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          if (isMenuOpen) ..._buildStackedFabMenu(context, menuBottom),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: scheme.copyWith(onPrimary: Colors.white),
        ),
        child: _buildBottomBar(context, scheme, isDark),
      ),
    );
  }

  /// Bottom inset for the lowest speed-dial row (just above the + button).
  double _stackedMenuBottom(BuildContext context) {
    const stackGap = 14.0;
    return MediaQuery.paddingOf(context).bottom +
        _navMarginBottom +
        _fabSize +
        stackGap;
  }

  /// Right inset so speed-dial circles line up with the package + button.
  /// FloatyNavBar centers the [pill | gap | FAB] row inside the horizontal margin.
  double _fabRightInset(BuildContext context) {
    final contentW = MediaQuery.sizeOf(context).width - (_navMarginH * 2);
    const unselectedTabW = 58.0;
    final selectedTitles = ['Home', 'Stats', 'Goals', 'Budget'];
    final selectedW = 88.0 + selectedTitles[currentIndex].length * 7.5;
    final pillW = unselectedTabW * (_pages.length - 1) + selectedW + 8;
    final rowW = pillW + _fabGap + _fabSize;
    final centeringSlack = ((contentW - rowW).clamp(0.0, double.infinity)) / 2;
    return _navMarginH + centeringSlack + (_fabSize - _menuCircleSize) / 2;
  }

  List<Widget> _buildStackedFabMenu(BuildContext context, double menuBase) {
    final items = [
      (icon: Icons.category, label: 'Categories', page: CategoriesPage()),
      (
        icon: Icons.attach_money,
        label: 'Transaction',
        page: const TransactionPage()
      ),
      (icon: Icons.chat, label: 'Chatbot', page: const ChatbotPage()),
    ];

    final rightInset = _fabRightInset(context);

    return [
      for (var i = 0; i < items.length; i++)
        Positioned(
          right: rightInset,
          bottom: menuBase + i * 64,
          child: _buildStackedMenuItem(
            index: i,
            icon: items[i].icon,
            label: items[i].label,
            page: items[i].page,
          ),
        ),
    ];
  }

  Widget _buildStackedMenuItem({
    required int index,
    required IconData icon,
    required String label,
    required Widget page,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 220 + index * 60),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0.0, end: isMenuOpen ? 1.0 : 0.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 16 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            color: Colors.black.withValues(alpha: 0.55),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Material(
            elevation: 6,
            shape: const CircleBorder(),
            color: Colors.white,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => page),
                );
                setState(() => isMenuOpen = false);
              },
              child: SizedBox(
                width: _menuCircleSize,
                height: _menuCircleSize,
                child: Icon(icon, color: _activeGreen, size: 26),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
