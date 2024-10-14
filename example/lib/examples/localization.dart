import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:tenor_flutter/tenor_flutter.dart';

class Localization extends StatefulWidget {
  const Localization({super.key});

  @override
  State<Localization> createState() => LocalizationState();
}

class LocalizationState extends State<Localization> {
  // replace apiKey with an api key provided by Tenor > https://developers.google.com/tenor/guides/quickstart
  var tenor = Tenor(
    apiKey: FlutterConfig.get('TENOR_API_KEY'),
    country: 'es',
    locale: 'es_ES',
  );
  // define a result that we can display later
  TenorResult? selectedResult;

  @override
  Widget build(BuildContext context) {
    final selectedGif = selectedResult?.media.tinyGif ??
        selectedResult?.media.tinyGifTransparent;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Localization Example'),
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
                : const Text('No se seleccionó ningún GIF'),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              final result = await tenor.showAsBottomSheet(
                context: context,
                searchFieldHintText: 'Buscar Tenor',
                tabs: [
                  TenorTab(
                    name: 'Caritas',
                    view: TenorViewEmojis(
                      client: tenor,
                    ),
                  ),
                  TenorTab(
                    name: 'Fotos',
                    view: TenorViewGifs(
                      client: tenor,
                      featuredCategory: '📈 Destacada',
                    ),
                  ),
                  TenorTab(
                    name: 'Pegatinas',
                    view: TenorViewStickers(
                      client: tenor,
                    ),
                  ),
                ],
              );
              setState(() {
                selectedResult = result;
              });
            },
            tooltip: 'Localization',
            child: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
    );
  }
}
