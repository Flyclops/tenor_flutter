## 1.0.1

- chore: Add discontinued notice

[All Code Changes](https://github.com/Flyclops/tenor_flutter/compare/1.0.0...1.0.1)

## 1.0.0
- chore: bump minimum Dart SDK version to 3.7
- chore: bump `extended_image` to `^10.0.1`
- chore: bump `provider` to `^6.1.5+1`

[All Code Changes](https://github.com/Flyclops/tenor_flutter/compare/0.1.2...1.0.0)

## 0.1.2

- fix: the endless loop can still happen if you switch between tabs quickly and time it perfectly while still loading gifs.

[All Code Changes](https://github.com/Flyclops/tenor_flutter/compare/0.1.1...0.1.2)

## 0.1.1

- fix: if you switch tabs very quickly before the initial gif fetch then you will get stuck in an endless loop and crash the app.

[All Code Changes](https://github.com/Flyclops/tenor_flutter/compare/0.1.0...0.1.1)

## 0.1.0

- feat: Integrate [tenor_dart's](https://pub.dev/packages/tenor_dart) new `TenorResult.source` parameter to track which tab the GIF was selected from for analytics
- fix: not being able to scroll down to load more on tablets or when using display zoom on iPad
- refactor: `TenorViewEmojis`, `TenorViewGifs`, `TenorViewStickers` and `TenorTabView` now have a `gifsPerRow` parameter instead of `mediaWidth` to be more explicit and support a wider range of devices

[All Code Changes](https://github.com/Flyclops/tenor_flutter/compare/0.0.5...0.1.0)

## 0.0.5

- fix: error when only one tab is passed in

[All Code Changes](https://github.com/Flyclops/tenor_flutter/compare/0.0.4...0.0.5)

## 0.0.4

- feature: add `coverAppBar` _(false)_ to disable calculations preventing bottom sheet from covering AppBar
- refactor: expose `animationStyle` as a parameter of `TenorStyle`
- refactor: expose `initialExtent` as a parameter of `showAsBottomSheet()`, defaults to `maxExtent` if not used
- refactor: expose `snapSizes` as a parameter of `showAsBottomSheet()`
- refactor: expose `useSafeArea` as a parameter of `showAsBottomSheet()`

[All Code Changes](https://github.com/Flyclops/tenor_flutter/compare/0.0.3...0.0.4)

## 0.0.3

- chore: write tests
- chore: updated/added examples and broke them up for a better experience
- fix: category was displaying `searchTerm` and now it's displaying `name` as that is localized from Tenor
  - added `stripHashtag` _(true)_ to `TenorCategoryStyle` so you can display a hashtag before each category name if you'd like _(comes like that from Tenor)_
- fix: issue where featured category could not be localized
- refactor: expose `keyboardDismissBehavior` as a parameter of `showAsBottomSheet()`
- refactor: expose `searchFieldHintText` as a parameter of `showAsBottomSheet()` to make localization easier

[All Code Changes](https://github.com/Flyclops/tenor_flutter/compare/0.0.2...0.0.3)

## 0.0.2

- chore: write tests
- refactor: support `tenor_dart` changes

[All Code Changes](https://github.com/Flyclops/tenor_flutter/compare/0.0.1...0.0.2)

## 0.0.1

- Initial version
