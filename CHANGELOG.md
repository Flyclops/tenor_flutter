## 0.0.2

- chore: write tests
- chore: updated/added examples and broke them up for a better experience
- fix: category was displaying `searchTerm` and now it's displaying `name` as that is localized from Tenor
  - added `stripHashtag` _(true)_ to `TenorCategoryStyle` so you can display a hashtag before each category name if you'd like _(comes like that from Tenor)_
- fix: issue where featured category could not be localized
- refactor: expose `keyboardDismissBehavior` as a parameter of `showAsBottomSheet()`
- refactor: expose `searchFieldHintText` as a parameter of `showAsBottomSheet()` to make localization easier
- refactor: support `tenor_dart` changes

[All Code Changes](https://github.com/Flyclops/tenor_flutter/compare/0.0.1...0.0.2)

## 0.0.1

- Initial version
