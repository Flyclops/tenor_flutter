/// Adds query parameters to an existing URL.
///
/// Takes a [url] string and a [Map] of query parameters to add.
/// Returns a new URL string with the combined query parameters.
/// If the URL already contains query parameters, they will be preserved
/// and merged with the new parameters.
String addQueryParameters({
  required Map<String, String> parameters,
  required String url,
}) {
  var oldUri = Uri.parse(url);
  Map<String, String> combinedParams = Map.from(oldUri.queryParameters)
    ..addAll(parameters);
  final newUri = oldUri.replace(queryParameters: combinedParams);
  return newUri.toString();
}
