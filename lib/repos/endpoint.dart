/// Endpoint to connect to server
// ignore_for_file: avoid_classes_with_only_static_members
class Endpoint {
  /// Get spots data from Google Sheet
  static final String getSpotsFromGSheet =
      'https://spreadsheets.google.com/feeds/list/{spreadsheetID}/{worksheetID}/public/values?alt=json';
}
