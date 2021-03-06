import 'package:mover/app/common/config/config.dart';
import 'package:mover/app/common/endpoint/amplify_endpoint.dart';
import 'package:mover/app/common/utils/remote_config.dart';
import 'package:mover/app/pages/mod_order/endpoints/mod_search_endpoint.dart';
import 'package:mover/models/MoverUser.dart';

import '../models/mod_model.dart';

class ModSearchRepository {
  List<ModModel> statsModels = [];

  ModSearchConfig config = RemoteConfigService.getModSearchRequestConfig();

  setConfig(ModSearchConfig _config) {
    config = _config;
  }

  Future<List<ModModel>> searchMods(ModSearchRequest _req) async {
    List<dynamic> _repository = [];

    ModSearchEndpoint _endpoint =
        ModSearchEndpoint(_getQuery(_req), config.uri);
    await _endpoint.init();

    const _batchSize = 100;
    int _offset = 0;
    while (true) {
      List<dynamic> _list = await _endpoint.query(
          nFirst: _batchSize, nOffset: _offset, networkOnly: true);
      if (_list.isEmpty) {
        // receive data is empty
        break;
      }

      _repository.addAll(_list);
      _offset = _repository.length;
      print("ret ${_list} : count ${_repository.length}");
      if (_list.length < _batchSize) {
        // finishing fetch all data
        break;
      }
    }
    final List<ModRatingModel> searchResultList =
        searchResultToModel(_repository);
    print(searchResultList);
    if (searchResultList.isEmpty) {
      // no data found
      return [];
    }

    // fetch found user data from Amplify
    List<ModModel> _result = [];

    if (_req.items["keyword"]!.item.isEmpty && _req.items.length < 2) {
      // fetch all data
      final _userList = await AmplifyEndpoint().getAllUser();
      if (null == _userList) {
        // no data found
        return [];
      }
      for (var _user in _userList) {
        _result.add(ModModel(
          user: _user,
          rating:
              searchResultList.firstWhere((element) => (element.id == _user.id),
                  orElse: () => ModRatingModel(
                        id: _user.id,
                        total: 0,
                        expDao: 0,
                        isEns: false,
                      )), // from SubQuery
          employmentRequests:
              await AmplifyEndpoint().getEmploymentRequestList(_user.id),
        ));
      }
    } else {
      for (var searchResult in searchResultList) {
        final _user = await AmplifyEndpoint().getUser(searchResult.id);
        if (null != _user) {
          final _employmentReqest =
              await AmplifyEndpoint().getEmploymentRequestList(searchResult.id);
          _result.add(ModModel(
            user: _user,
            rating: searchResult,
            employmentRequests: _employmentReqest,
          ));
        }
      }
    }

    print(_result);

    // filter all user from Amplify
    List<ModModel> _filterdResult = _filterByEmploymentCondition(_req, _result);

    return _filterdResult;
  }

  List<ModRatingModel> searchResultToModel(List<dynamic> _data) {
    return _data
        .map((e) => ModRatingModel(
            id: e["id"], expDao: e["experiencedDaos"], isEns: false, total: 0))
        .toList();
  }

  String _getQuery(ModSearchRequest _req) {
    String _query =
        "query ReadRepositories(\$nFirst: Int!,\$nOffset: Int!){ moderators(first:\$nFirst, offset:\$nOffset";
    String _filter = "";
    _req.items.forEach((key, e) {
      print("$key $e");
      if (("price" == key) || "periodOfEmployment" == key) {
        // NOP
      } else if ("keyword" == key) {
        print("${e.item}");
      } else {
        if ("toggleRange" == e.header.type) {
          "${e.item["key"]} ${e.item["min"]} ${e.item["max"]}";
          if (null != e.item["min"]) {
            _filter += "{$key:{greaterThanOrEqualTo:${e.item["min"]}}},";
          }
          if (null != e.item["max"]) {
            _filter += "{$key:{lessThanOrEqualTo:${e.item["max"]}}},";
          }
        } else if ("selectable" == e.header.type) {
          if (null != e.item["min"]) {
            _filter += "{$key:{greaterThanOrEqualTo:\"${e.item["min"]}\"}},";
          }
          if (null != e.item["max"]) {
            _filter += "{$key:{lessThanOrEqualTo:\"${e.item["max"]}\"}},";
          }
        } else if ("toggleBool" == e.header.type) {
          _filter += "{$key:{EqualTo:${e.item["val"]}}},";
        }
      }
    });
    if (_filter.isNotEmpty) {
      _filter = _filter.substring(0, _filter.length - 1);
      _query += ", filter:{and:[$_filter]}";
    }
    _query += ") { nodes { id, experiencedDaos } } }";
    print(_query);
    return _query;
  }

  List<ModModel> _filterByEmploymentCondition(
      ModSearchRequest _modSearchRequest, List<ModModel> _result) {
    List<ModModel> _filterdResult = [];
    for (var modModel in _result) {
      if (modModel.employmentRequests.isNotEmpty) {
        final _request = modModel.employmentRequests.where((request) {
          bool filter = true;

          // =====================================================
          // Already have employment request
          filter &= (null == request.employerWallet);
          // =====================================================

          // =====================================================
          // Price
          if (_modSearchRequest.items.containsKey("price")) {
            if ((null != _modSearchRequest.items["price"]!.item["min"]) &&
                (null != _modSearchRequest.items["price"]!.item["max"])) {
              // min <= price <= max
              filter &= ((_modSearchRequest.items["price"]!.item["min"] <=
                      request.price) &&
                  (request.price <=
                      _modSearchRequest.items["price"]!.item["max"]));
            } else if (null != _modSearchRequest.items["price"]!.item["min"]) {
              // min <= price
              filter &= (_modSearchRequest.items["price"]!.item["min"] <=
                  request.price);
            } else if (null != _modSearchRequest.items["price"]!.item["max"]) {
              // price <= max
              filter &= (request.price <=
                  _modSearchRequest.items["price"]!.item["max"]);
            }
          }
          // =====================================================
          // period
          if (_modSearchRequest.items.containsKey("periodOfEmployment")) {
            if ((null !=
                    _modSearchRequest
                        .items["periodOfEmployment"]!.item["min"]) &&
                (null !=
                    _modSearchRequest
                        .items["periodOfEmployment"]!.item["max"])) {
              // =====================================================
              // min <= period <= max
              filter &=
                  (_modSearchRequest.items["periodOfEmployment"]!.item["min"] <=
                          request.periodMonth) ||
                      (request.periodMonth <=
                          _modSearchRequest
                              .items["periodOfEmployment"]!.item["max"]);
            } else if (null !=
                _modSearchRequest.items["periodOfEmployment"]!.item["min"]) {
              // =====================================================
              // min <= period
              filter &=
                  (_modSearchRequest.items["periodOfEmployment"]!.item["min"] <=
                      request.periodMonth);
            } else if (null !=
                _modSearchRequest.items["periodOfEmployment"]!.item["max"]) {
              // =====================================================
              // price <= max
              filter &= (request.periodMonth <=
                  _modSearchRequest.items["periodOfEmployment"]!.item["max"]);
            }
          }

          return filter;
        });

        // =====================================================
        // add filterd user to result
        if (_request.toList().isNotEmpty) {
          _filterdResult.add(ModModel(
              user: modModel.user,
              rating: modModel.rating,
              employmentRequests: _request.toList()));
        }
      }
    }
    return _filterdResult;
  }
}

class ModSearchResult {
  final String wallet;
  final String experiencedDaos;

  ModSearchResult({required this.wallet, required this.experiencedDaos});
}
