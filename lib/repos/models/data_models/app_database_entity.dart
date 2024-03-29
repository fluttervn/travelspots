import 'package:floor/floor.dart';
import 'package:travelspots/repos/models/data_models/spot_data_model.dart';
import 'package:travelspots/utils/app_utils.dart';
import 'package:travelspots/utils/string_utils.dart';

@entity
class SpotEntity {
  @primaryKey
  final int id;
  final String uniqueKey;
  final String searchText;
  final String name;
  final int popularity;
  final String address;
  final String province;
  final String district;
  final String districtKey;
  final double lat;
  final double long;
  final String locationLink;
  final String website;
  final String imageLink;
  final String description;
  final String wikiLink;

  /// Create new SpotEntity.
  ///
  /// Note that Floor doesn't have support for named parameter in constructor yet
  SpotEntity(
    this.id,
    this.uniqueKey,
    this.searchText,
    this.name,
    this.popularity,
    this.address,
    this.province,
    this.district,
    this.districtKey,
    this.lat,
    this.long,
    this.locationLink,
    this.website,
    this.imageLink,
    this.description,
    this.wikiLink,
  );

  // for importing data
  factory SpotEntity.fromGoogleJson(
    Map<String, dynamic> itemJson,
    String uniqueKey,
    String province,
  ) {
    // print('fromGoogleJson: $itemJson');
    getOfKey(String key) {
      var val1 = itemJson['gsx\u0024$key'];
      if (val1 != null) {
        return val1['\u0024t'];
      }
      print('... ERROR: not valid value of key=$key for item=$itemJson');
    }

    var id = getOfKey('id');
    var name = getOfKey('name');
    var popularity = getOfKey('popularity');
    var address = getOfKey('address');
    var district = getOfKey('district');
    var districtKey = getOfKey('districtkey');
    var lat = getOfKey('lat');
    var long = getOfKey('long');
    var locationLink = getOfKey('locationlink');
    var description = getOfKey('description');
    var website = getOfKey('website');
    var imageLink = getOfKey('imagelink');
    var wikiLink = getOfKey('wikilink');
    /*print('id is: $id');
    print('name is: $name');
    print('popularity is: $popularity');
    print('address is: $address');
    print('district is: $district');
    print('districtKey is: $districtKey');
    print('lat is: $lat');
    print('long is: $long');
    print('description is: $description');
    print('website is: $website');
    print('imageLink is: $imageLink');
    print('uniqueKey is: uniqueKey');*/

    final searchText = '${convertUnicodeToAsciiText(name)} '
        '${convertUnicodeToAsciiText(address)} '
        '${convertUnicodeToAsciiText(district)} '
        '${convertUnicodeToAsciiText(province)} ';
    return SpotEntity(
      AppUtils.parseIntOrException(id),
      uniqueKey,
      searchText,
      name,
      AppUtils.parseInt(popularity, 4),
      address,
      province,
      district,
      districtKey,
      AppUtils.parseDouble(lat, null),
      AppUtils.parseDouble(long, null),
      locationLink,
      website,
      imageLink,
      description,
      wikiLink,
    );
  }

  factory SpotEntity.fromDatModel(SpotDataModel item) {
    final searchText = '${convertUnicodeToAsciiText(item.name)} '
        '${convertUnicodeToAsciiText(item.address)} '
        '${convertUnicodeToAsciiText(item.district)} '
        '${convertUnicodeToAsciiText(item.province)} ';

    return SpotEntity(
      item.id,
      item.uniqueKey,
      searchText,
      item.name,
      item.popularity,
      item.address,
      item.province,
      item.district,
      item.districtKey,
      item.lat,
      item.long,
      item.locationLink,
      item.website,
      item.imageLink,
      item.description,
      item.wikiLink,
    );
  }

  @override
  String toString() {
    return 'SpotEntity{id: $id, name: $name, address: $address, province: $province, lat: $lat, long: $long}';
  }
}
