import 'dart:convert';
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final FirebaseRemoteConfig _remoteConfig =
      FirebaseRemoteConfig.instance;

  static const Map<String, dynamic> _defaultRemoteConfig = {
    "BlockStats":
        "{\"url\":\"https://api.subquery.network/sq/AstarStats/astarstats-aggregate-block-data__QXN0Y\"}"
  };

  static Future<void> fetchRemoteConfig() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await _remoteConfig.fetchAndActivate();
  }

  static Future<void> setDefaultBlockStatsConfig() async {
    await _remoteConfig.setDefaults(_defaultRemoteConfig);
  }

  static ModSearchConfig getModSearchRequestConfig() {
    final decoded = _getConfig('modSearchRequest');
    final _modSearchRequest = ModSearchConfig.fromJson(decoded);
    return _modSearchRequest;
  }

  static Map<String, dynamic> _getConfig(String key) {
    final data = _remoteConfig.getValue(key);
    final Map<String, dynamic> decoded = json.decode(data.asString());
    return decoded;
  }
}

class ModSearchConfig {
  ModSearchConfig({
    required this.uri,
    required this.request,
  });

  factory ModSearchConfig.fromJson(Map<String, dynamic> data) {
    final Map<String, dynamic> _elems = data["request"] as Map<String, dynamic>;
    final List<ModSearchConfigElem> _items = _elems.entries.map((e) {
      return ModSearchConfigElem.fromJson(e.key, e.value);
    }).toList();
    return ModSearchConfig(uri: data['uri'], request: _items);
  }

  final String uri;
  final List<ModSearchConfigElem> request;
}

class ModSearchConfigElem {
  ModSearchConfigElem({
    required this.header,
    required this.items,
  });

  factory ModSearchConfigElem.fromJson(String key, Map<String, dynamic> elem) {
    return ModSearchConfigElem(
        header: ModSearchConfigHeader.fromJson(key, elem),
        items: elem["items"]);
  }

  final ModSearchConfigHeader header;
  final List<dynamic> items;
}

class ModSearchRequest {
  ModSearchRequest({
    required this.items,
  });

  Map<String, ModSearchRequestItem> items;
}

class ModSearchRequestItem {
  ModSearchRequestItem({
    required this.header,
    required this.item,
  });

  factory ModSearchRequestItem.fromJson(String key, dynamic elem) {
    return ModSearchRequestItem(
        header: ModSearchConfigHeader.fromJson(key, elem), item: elem);
  }

  @override
  String toString() {
    return "${header.toString()} $item";
  }

  final ModSearchConfigHeader header;
  final dynamic item;
}

class ModSearchConfigHeader {
  ModSearchConfigHeader({
    required this.key,
    required this.name,
    required this.omitName,
    required this.type,
  });

  factory ModSearchConfigHeader.fromJson(
      String key, Map<String, dynamic> elem) {
    return ModSearchConfigHeader(
        key: key,
        name: elem["name"],
        omitName: elem["omitName"],
        type: elem["type"]);
  }

  @override
  String toString() {
    return "{key: $key name: $name omitName: $omitName type: $type}";
  }

  final String key;
  final String name;
  final String omitName;
  final String type;
}

class ToggleRangeModel {
  ToggleRangeModel({
    required this.key,
    required this.min,
    required this.max,
  });

  factory ToggleRangeModel.parseItem(dynamic _item) {
    return ToggleRangeModel(
        key: _item["key"], min: _item["min"], max: _item["max"]);
  }

  final String key;
  final int? min;
  final int? max;
}

class ToggleBoolRangeModel {
  ToggleBoolRangeModel({
    required this.key,
    required this.val,
  });

  factory ToggleBoolRangeModel.parseItem(dynamic _item) {
    return ToggleBoolRangeModel(key: _item["key"], val: _item["val"]);
  }

  final String key;
  final bool val;
}

class SelectableRangeModel {
  SelectableRangeModel({
    required this.key,
    required this.val,
  });

  factory SelectableRangeModel.parseItem(dynamic _item) {
    return SelectableRangeModel(key: _item["key"], val: _item["val"]);
  }

  final String key;
  final String val;
}
