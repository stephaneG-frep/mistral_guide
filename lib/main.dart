import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/installation_screen.dart';
import 'screens/api_screen.dart';
import 'screens/prompts_screen.dart';
import 'screens/features_screen.dart';
import 'screens/chat_screen.dart';

// ─── Thèmes ──────────────────────────────────────────────────────────────────
class AppThemes {
  static ThemeData get darkOrange => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFBF5A00),
          secondary: Color(0xFFE07000),
          surface: Color(0xFF1C1108),
          onPrimary: Colors.white,
          onSurface: Color(0xFFF0E0CC),
        ),
        scaffoldBackgroundColor: const Color(0xFF1C1108),
        drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF2A1A08)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2A1A08),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(color: Color(0xFF2A1A08), elevation: 2),
      );

  static ThemeData get lightOrange => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFE65100),
          secondary: Color(0xFFFF6D00),
          surface: Color(0xFFFFF8F0),
          onPrimary: Colors.white,
          onSurface: Color(0xFF3E2000),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8F0),
        drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFFFFF3E0)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF3E0),
          foregroundColor: Color(0xFF3E2000),
          elevation: 0,
        ),
        cardTheme: const CardThemeData(color: Color(0xFFFFF3E0), elevation: 2),
      );
}

// ─── Config thèmes drawer ─────────────────────────────────────────────────────
class ThemeConfig {
  final Color primary;
  final Color accent;
  final Color drawerBg;
  final Color divider;
  final Color selectedTile;
  final Color indicator;
  final Color footerText;
  final Color titleColor;
  final List<Color> headerGradient;
  final List<NavItem> navItems;

  const ThemeConfig({
    required this.primary,
    required this.accent,
    required this.drawerBg,
    required this.divider,
    required this.selectedTile,
    required this.indicator,
    required this.footerText,
    required this.titleColor,
    required this.headerGradient,
    required this.navItems,
  });

  static const darkOrange = ThemeConfig(
    primary: Color(0xFFBF5A00),
    accent: Color(0xFFFFB74D),
    drawerBg: Color(0xFF2A1A08),
    divider: Color(0xFF4A2E10),
    selectedTile: Color(0xFFBF5A00),
    indicator: Color(0xFFFFB74D),
    footerText: Color(0xFF8D6030),
    titleColor: Colors.white,
    headerGradient: [Color(0xFF7C3000), Color(0xFFBF5A00), Color(0xFFE07000)],
    navItems: [
      NavItem(icon: Icons.home_outlined,         label: 'Accueil',         color: Color(0xFFFF8C00)),
      NavItem(icon: Icons.download_outlined,     label: 'Installation',    color: Color(0xFFE07000)),
      NavItem(icon: Icons.code_outlined,         label: 'API & Code',      color: Color(0xFFBF5A00)),
      NavItem(icon: Icons.auto_awesome_outlined, label: 'Prompts',         color: Color(0xFFFFAB40)),
      NavItem(icon: Icons.star_outline,          label: 'Fonctionnalités', color: Color(0xFFE64A19)),
      NavItem(icon: Icons.chat_bubble_outline,   label: 'Chat Mistral',    color: Color(0xFFFF6D00)),
    ],
  );

  static const lightOrange = ThemeConfig(
    primary: Color(0xFFE65100),
    accent: Color(0xFFFF6D00),
    drawerBg: Color(0xFFFFF3E0),
    divider: Color(0xFFFFCC80),
    selectedTile: Color(0xFFE65100),
    indicator: Color(0xFFFF6D00),
    footerText: Color(0xFF8D6E63),
    titleColor: Color(0xFF3E2000),
    headerGradient: [Color(0xFFE65100), Color(0xFFFF6D00), Color(0xFFFF8C00)],
    navItems: [
      NavItem(icon: Icons.home_outlined,         label: 'Accueil',         color: Color(0xFFE65100)),
      NavItem(icon: Icons.download_outlined,     label: 'Installation',    color: Color(0xFFBF360C)),
      NavItem(icon: Icons.code_outlined,         label: 'API & Code',      color: Color(0xFFFF6D00)),
      NavItem(icon: Icons.auto_awesome_outlined, label: 'Prompts',         color: Color(0xFFF57C00)),
      NavItem(icon: Icons.star_outline,          label: 'Fonctionnalités', color: Color(0xFFE64A19)),
      NavItem(icon: Icons.chat_bubble_outline,   label: 'Chat Mistral',    color: Color(0xFFBF360C)),
    ],
  );
}

// ─── App root ────────────────────────────────────────────────────────────────
void main() {
  runApp(const MistralGuideApp());
}

class MistralGuideApp extends StatelessWidget {
  const MistralGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, theme, _) {
        return MaterialApp(
          title: 'Mistral Guide',
          debugShowCheckedModeBanner: false,
          theme: theme == AppTheme.darkOrange ? AppThemes.darkOrange : AppThemes.lightOrange,
          home: const MainScaffold(),
        );
      },
    );
  }
}

// ─── Scaffold principal ──────────────────────────────────────────────────────
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    InstallationScreen(),
    ApiScreen(),
    PromptsScreen(),
    FeaturesScreen(),
    ChatScreen(),
  ];

  ThemeConfig get _cfg =>
      themeNotifier.value == AppTheme.darkOrange ? ThemeConfig.darkOrange : ThemeConfig.lightOrange;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, _, _) => Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _cfg.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Text(
                _cfg.navItems[_selectedIndex].label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: _cfg.titleColor,
                ),
              ),
            ],
          ),
        ),
        drawer: _buildDrawer(context),
        body: _screens[_selectedIndex],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final cfg = _cfg;
    final navItems = cfg.navItems;
    final isLight = themeNotifier.value == AppTheme.lightOrange;

    return Drawer(
      backgroundColor: cfg.drawerBg,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: cfg.headerGradient,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white30, width: 2),
                  ),
                  child: const Icon(Icons.auto_awesome, size: 36, color: Colors.white),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Mistral Guide',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manuel complet Mistral AI',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.72), fontSize: 13),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isSelected = _selectedIndex == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    selected: isSelected,
                    selectedTileColor: cfg.selectedTile.withValues(alpha: 0.18),
                    leading: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? item.color.withValues(alpha: 0.28)
                            : item.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Icon(item.icon,
                          color: isSelected ? cfg.primary : item.color, size: 20),
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        color: isSelected
                            ? cfg.primary
                            : isLight
                                ? const Color(0xFF5D3A1A)
                                : const Color(0xFFB0BEC5),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                    trailing: isSelected
                        ? Container(
                            width: 4,
                            height: 28,
                            decoration: BoxDecoration(
                              color: cfg.indicator,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          )
                        : null,
                    onTap: () {
                      setState(() => _selectedIndex = index);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),

          Divider(color: cfg.divider, height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.palette_outlined,
                    size: 18,
                    color: isLight
                        ? const Color(0xFF8D6030)
                        : Colors.white.withValues(alpha: 0.5)),
                const SizedBox(width: 10),
                Text(
                  isLight ? 'Thème Clair' : 'Thème Sombre',
                  style: TextStyle(
                    color: isLight
                        ? const Color(0xFF8D6030)
                        : Colors.white.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: isLight,
                  onChanged: (val) {
                    themeNotifier.value =
                        val ? AppTheme.lightOrange : AppTheme.darkOrange;
                  },
                  activeThumbColor: const Color(0xFFE65100),
                  activeTrackColor: const Color(0xFFFFCC80),
                  inactiveThumbColor: const Color(0xFFFF8C00),
                  inactiveTrackColor: const Color(0xFF5D3A1A),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Text(
              'v1.0 • Mistral AI Guide',
              style: TextStyle(
                color: cfg.footerText.withValues(alpha: 0.6),
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  final Color color;
  const NavItem({required this.icon, required this.label, required this.color});
}
