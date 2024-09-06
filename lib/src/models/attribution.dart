/// It is your responsibility to display attribution via atleast one of the following methods.
///
/// https://developers.google.com/tenor/guides/attribution
enum TenorAttributionType {
  /// Use this attribution during the GIF browsing experience.
  poweredBy,

  /// Use this attribution as the placeholder text in your search box. If you have your own SearchFieldWidget and intend to use this attribution you must implement it yourself.
  searchTenor,

  /// Use this attribution in the footer of a shared GIF. Must be implemented yourself.
  viaTenor,
}
