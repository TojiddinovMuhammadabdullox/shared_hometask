import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  bool _isCustomColor = false;
  final Color _customBackgroundColor = Colors.blueGrey;
  double _fontSize = 16.0;  

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _isCustomColor = prefs.getBool('isCustomColor') ?? false;
      _fontSize = prefs.getDouble('fontSize') ?? 16.0;
    });
  }

  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
    prefs.setBool('isCustomColor', _isCustomColor);
    prefs.setDouble('fontSize', _fontSize);
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
      _savePreferences();
    });
  }

  void _toggleBackgroundColor(bool isCustomColor) {
    setState(() {
      _isCustomColor = isCustomColor;
      _savePreferences();
    });
  }

  void _changeFontSize(double newSize) {
    setState(() {
      _fontSize = newSize;
      _savePreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: HomeScreen(
        isDarkMode: _isDarkMode,
        onThemeChanged: _toggleTheme,
        isCustomColor: _isCustomColor,
        onColorChanged: _toggleBackgroundColor,
        customBackgroundColor: _customBackgroundColor,
        fontSize: _fontSize,
        onFontSizeChanged: _changeFontSize,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final bool isCustomColor;
  final ValueChanged<bool> onColorChanged;
  final Color customBackgroundColor;
  final double fontSize;
  final ValueChanged<double> onFontSizeChanged;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.isCustomColor,
    required this.onColorChanged,
    required this.customBackgroundColor,
    required this.fontSize,
    required this.onFontSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Hello World",
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text("Change Mode"),
            value: isDarkMode,
            onChanged: onThemeChanged,
            secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
          ),
          SwitchListTile(
            title: const Text("Change Background Color"),
            value: isCustomColor,
            onChanged: onColorChanged,
            secondary:
                Icon(isCustomColor ? Icons.color_lens : Icons.format_paint),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
              "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text("Font Size: "),
                Expanded(
                  child: Slider(
                    value: fontSize,
                    min: 10.0,
                    max: 40.0,
                    onChanged: onFontSizeChanged,
                    label: "${fontSize.round()}",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: isCustomColor
          ? customBackgroundColor
          : (isDarkMode ? Colors.black : Colors.white),
    );
  }
}
