import 'package:mover/app/common/config/config.dart';
import 'package:mover/app/common/endpoint/amplify_endpoint.dart';
import 'package:mover/app/common/utils/remote_config.dart';
import 'package:mover/app/pages/mod_order/endpoints/mod_search_endpoint.dart';

import '../models/mod_model.dart';

class ModSearchRepository {
  List<ModModel> statsModels = [];

  ModSearchConfig config = RemoteConfigService.getModSearchRequestConfig();

  setConfig(ModSearchConfig _config) {
    config = _config;
  }

  Future<List<ModModel>> searchMods(ModSearchRequest _req) async {
    List<dynamic> _repository = [];
    List<ModModel> _tmp = [];
    List<ModModel> _result = [];
    ModSearchEndpoint _endpoint = ModSearchEndpoint(_getQuery(_req), Config.searchRpcUrl);
    // TODO : Implement GraphQL query
    // await _endpoint.init();

    // const _batchSize = 100;
    // int _offset = 0;
    // while (true) {
    //   List<dynamic> _list = await _endpoint.query(
    //       nFirst: _batchSize, nOffset: _offset, networkOnly: true);

    //   if (_list.isEmpty) {
    //     // receive data is empty
    //     break;
    //   }

    //   _repository.addAll(_list);
    //   _offset = _repository.length;
    //   print("ret ${_list.last["id"]} : count ${_repository.length}");
    //   if (_list.length < _batchSize) {
    //     // finishing fetch all data
    //     break;
    //   }
    // }
    _tmp.addAll(searchResultToModel(_repository));

    if (_tmp.isEmpty) {
      // no data found
      return [];
    }

    // fetch found user data from Amplify
    // for (var modModel in _tmp) {
    //   final _user = await AmplifyEndpoint().getUser(modModel.user.wallet);
    //   final _employmentReqest = await AmplifyEndpoint().getEmploymentRequestList(modModel.user.wallet);
    //   if (null != _user) {
    //     _result.add(ModModel(
    //       user: _user,
    //       rating: modModel.rating,
    //       employmentRequests: _employmentReqest,
    //     ));
    //   }
    // }

    final _userList = await AmplifyEndpoint().getAllUser();
    if (_userList == null) {
      return [];
    }
    for (var user in _userList) {
      final _employmentRequest = await AmplifyEndpoint().getEmploymentRequestList(user.wallet);
      if (_employmentRequest.isNotEmpty) {
        _result.add(ModModel(
          user: user,
          rating: ModRatingModel(
            total: 3,
            expDao: 0,
            isEns: true,
          ),
          employmentRequests: _employmentRequest,
        ));
      }
    }
    print(_result);

    // filter all user from Amplify
    List<ModModel> _filterdResult = _filterByEmploymentCondition(_req, _result);

    return _filterdResult;
  }

  List<ModModel> searchResultToModel(List<dynamic> _data) {
    return statsModelsMockData;
  }

  String _getQuery(ModSearchRequest _req) {
    String _query = "query ReadRepositories(\$nFirst: Int!,\$nOffset: Int!){ moderator(first:\$nFirst, offset:\$nOffset";
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
            _filter += "{$key:{graterThanOrEqualTo:\"${e.item["min"]}\"}},";
          }
          if (null != e.item["max"]) {
            _filter += "{$key:{lessThanOrEqualTo:\"${e.item["max"]}\"}},";
          }
        } else if ("selectable" == e.header.type) {
          if (null != e.item["min"]) {
            _filter += "{$key:{graterThanOrEqualTo:\"${e.item["min"]}\"}},";
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
    _query += ") { nodes { id, daos } } }";
    print(_query);
    return _query;
  }

  List<ModModel> _filterByEmploymentCondition(ModSearchRequest _modSearchRequest, List<ModModel> _result) {
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
            if ((null != _modSearchRequest.items["price"]!.item["min"]) && (null != _modSearchRequest.items["price"]!.item["max"])) {
              // min <= price <= max
              filter &= ((_modSearchRequest.items["price"]!.item["min"] <= request.price) && (request.price <= _modSearchRequest.items["price"]!.item["max"]));
            } else if (null != _modSearchRequest.items["price"]!.item["min"]) {
              // min <= price
              filter &= (_modSearchRequest.items["price"]!.item["min"] <= request.price);
            } else if (null != _modSearchRequest.items["price"]!.item["max"]) {
              // price <= max
              filter &= (request.price <= _modSearchRequest.items["price"]!.item["max"]);
            }
          }
          // =====================================================
          // period
          if (_modSearchRequest.items.containsKey("periodOfEmployment")) {
            if ((null != _modSearchRequest.items["periodOfEmployment"]!.item["min"]) && (null != _modSearchRequest.items["periodOfEmployment"]!.item["max"])) {
              // =====================================================
              // min <= period <= max
              filter &= (_modSearchRequest.items["periodOfEmployment"]!.item["min"] <= request.periodMonth) || (request.periodMonth <= _modSearchRequest.items["periodOfEmployment"]!.item["max"]);
            } else if (null != _modSearchRequest.items["periodOfEmployment"]!.item["min"]) {
              // =====================================================
              // min <= period
              filter &= (_modSearchRequest.items["periodOfEmployment"]!.item["min"] <= request.periodMonth);
            } else if (null != _modSearchRequest.items["periodOfEmployment"]!.item["max"]) {
              // =====================================================
              // price <= max
              filter &= (request.periodMonth <= _modSearchRequest.items["periodOfEmployment"]!.item["max"]);
            }
          }

          return filter;
        });

        // =====================================================
        // add filterd user to result
        if (_request.toList().isNotEmpty) {
          _filterdResult.add(ModModel(user: modModel.user, rating: modModel.rating, employmentRequests: _request.toList()));
        }
      }
    }
    return _filterdResult;
  }
}
