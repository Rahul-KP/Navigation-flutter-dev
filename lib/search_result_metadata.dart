import 'package:here_sdk/core.dart';
import 'package:here_sdk/search.dart';

class SearchResultMetadata implements CustomMetadataValue {
  Place searchResult;

  SearchResultMetadata(Place place) : searchResult = place;

  @override
  String getTag() {
    return "SearchResult Metadata";
  }

  @override
  void release() {
    // Deprecated. Nothing to do here.
  }
}