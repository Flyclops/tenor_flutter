import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:tenor_flutter/tenor_flutter.dart';

void main() async {
  // only used to load api key from .env file, not required
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tenor Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Tenor Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // replace apiKey with an api key provided by Tenor > https://developers.google.com/tenor/guides/quickstart
  var tenor = Tenor(apiKey: FlutterConfig.get('TENOR_API_KEY'));

  TenorResult? selectedResult;

  void _defaultPicker() async {
    final result = await tenor.showAsBottomSheet(context: context);
    setState(() {
      selectedResult = result;
    });
  }

  void _themedPicker() async {
    final result = await tenor.showAsBottomSheet(
      context: context,
      style: TenorStyle(
        color: const Color(0xFF2b2d31),
        searchFieldStyle: const TenorSearchFieldStyle(
          fillColor: Color(0xFF1e1f22),
          hintStyle: TextStyle(
            color: Color(0xFFb5bac1),
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        attributionStyle: const TenorAttributionStyle(
          brightnes: Brightness.dark,
        ),
        tabBarStyle: TenorTabBarStyle(
          decoration: BoxDecoration(
            color: const Color(0xFF1e1f22),
            border: Border.all(
              color: const Color(0xFF2b2d31),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          indicator: BoxDecoration(
            color: const Color(0xFF404249),
            borderRadius: BorderRadius.circular(7),
          ),
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelColor: const Color(0xFFb5bac1),
          labelColor: Colors.white,
        ),
        selectedCategoryStyle: const TenorSelectedCategoryStyle(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 15,
            color: Colors.white,
          ),
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        tabViewStyle: const TenorTabViewStyle(
          mediaBackgroundColor: Color(0xFF404249),
        ),
      ),
    );
    setState(() {
      selectedResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedGif = selectedResult?.media.tinygif ??
        selectedResult?.media.tinygifTransparent;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            selectedResult != null && selectedGif != null
                ? Image.network(
                    selectedGif.url,
                    width: selectedGif.dimensions.width,
                    height: selectedGif.dimensions.height,
                  )
                : const Text('No GIF selected'),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _defaultPicker,
            tooltip: 'Default',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16),
          Theme(
            data: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: true,
            ),
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: _themedPicker,
              tooltip: 'Themed',
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
