# Tenor Flutter


> An opinionated yet customizable Flutter package for searching and selecting from a list of GIFs/Stickers from the [Tenor GIF search API](https://developers.google.com/tenor/guides/quickstart).

<p align="center">
  <a href="https://pub.dartlang.org/packages/tenor_flutter"><img src="https://img.shields.io/pub/v/tenor_flutter.svg" alt="Tenor Flutter Pub Package" /></a>
  <a href="https://opensource.org/license/bsd-3-clause"><img src="https://img.shields.io/badge/License-BSD_3--Clause-blue.svg" alt="License BSD 3-Clause" /></a>
  <a href="https://github.com/flyclops/tenor_flutter/stargazers"><img src="https://img.shields.io/github/stars/flyclops/tenor_flutter?style=flat" alt="Tenor Flutter Issues" /></a>
  <a href="https://github.com/flyclops/tenor_flutter/issues"><img src="https://img.shields.io/github/issues/flyclops/tenor_flutter" alt="Tenor Flutter Issues" /></a>
</p>


<p align="center"><img src="https://github.com/flyclops/tenor_flutter/raw/main/example/assets/demo.gif" width="200" alt="Tenor Flutter Demo"/></p>

<p align="center"><strong><sup>Show some ❤️ and <a href="https://github.com/flyclops/tenor_flutter">star the repo</a> to support this package.</sup></strong></p>

## What to know

- In order to start using Tenor Flutter you must obtain an API key by registering your project with [Tenor](https://developers.google.com/tenor/guides/quickstart).
- Tenor requires proper [attribution](https://developers.google.com/tenor/guides/attribution) for projects using their API. This package enables "Powered By Tenor" and "Search Tenor" by default. You are only required to have one.

## Obtaining Tenor API v2 key

1. Log in to the [Google Cloud Console](https://console.cloud.google.com)
2. Create a [new project](https://console.cloud.google.com/projectcreate)
3. Go to the Google Cloud Marketplace and find the [Tenor API](https://console.cloud.google.com/marketplace/product/google/tenor.googleapis.com)
4. Click `Enable` to activate it
5. In the navigation menu, go to the `APIs & Services` tab and select [Credentials](https://console.cloud.google.com/apis/credentials)
6. Click `+ Create Credentials` and choose `API key`
7. Copy the generated API key
8. Provide this API key as a parameter to `TenorClient`

## Usage

### Installation

```
flutter pub add tenor_flutter
```

<sup>Having trouble? Read the pub.dev <a href="https://pub.dev/packages/tenor_flutter/install">installation page</a>.</sup>

### Import

Import the package into the dart file where it will be used:

```
import 'package:tenor_flutter/tenor_flutter.dart';
```

### Initialize

You must pass in a valid `apiKey` provided by [Tenor](https://developers.google.com/tenor/guides/quickstart). It's **strongly recommended** to also pass in a `clientKey` as this will help you distinguish which project is making the requests.

```
var tenorClient = Tenor(apiKey: 'YOUR_API_KEY', clientKey: 'YOUR_PROJECT_NAME');
```

## Example

For more elaborate examples feel free to check out [example/lib/main.dart](https://github.com/Flyclops/tenor_flutter/blob/main/example/lib/main.dart).

Here's how to display the UI as a bottom sheet and then print the user's selection. If `null` is returned, it means the user closed the sheet without choosing a GIF.

```
final tenorClient = Tenor(apiKey: 'YOUR_API_KEY', clientKey: 'YOUR_PROJECT_NAME');
final TenorResult? result = await tenorClient.showAsBottomSheet(context: context);
print(result?.media.tinygif?.url);
```

## Don't need the UI?

If you're seeking a solution that allows for full customization without the need of dependencies then consider [Tenor Dart](https://github.com/Flyclops/tenor_dart).

## Sponsors

<table>
  <tr>
    <td><p align="center"><a href="https://flyclops.com/"><img src="https://github.com/Flyclops/tenor_flutter/blob/main/example/assets/flyclops_logo_github.png?raw=true" alt="Flyclops"/></a></p></td>
    <td><p align="center"><a href="https://flyclops.com/games/domino.html"><img src="https://github.com/Flyclops/tenor_flutter/blob/main/example/assets/domino_logo_github.png?raw=true" alt="Domino!"/></a></p></td>
  </tr>
  <tr>
    <td><p align="center"><a href="https://flyclops.com/">Flyclops</a> is a independent mobile games studio specializing in casual multi-player games, both asynchronous turn-based, and real-time. Flyclops’s games have been played by millions across&nbsp;the&nbsp;globe.</p></td>
    <td><p align="center"><a href="https://flyclops.com/games/domino.html">Domino!</a> is super addictive, fast-paced, multiplayer dominoes done right for <a href="http://j.mp/domino_FREE">iOS</a> and <a href="http://flycl.ps/domino_android">Android</a>. This easy-to-learn but impossible-to-master strategy game is beautifully designed and endlessly&nbsp;entertaining!</p></td>
  </tr>
</table>

## What's next?

- Documentation
- Tests *([Contributions](https://github.com/Flyclops/tenor_flutter/blob/main/CONTRIBUTING.md) welcome)* ^_^
- Further improvements
