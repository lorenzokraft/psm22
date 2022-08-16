import 'package:flutter/cupertino.dart';
import '../../../common/enums/load_state.dart';
import '../../../models/entities/brand.dart';
import '../../../services/index.dart';



class BrandLayoutModel extends ChangeNotifier {
  final _services = Services();
  final List<Brand> _brands = [];
  List<Brand> get brands => _brands;
  FSLoadState _state = FSLoadState.loaded;
  FSLoadState get state => _state;
  bool _isDisposed = false;
  var _page = 1;
  final _perPage = 20;

  BrandLayoutModel() {
    getBrands();
  }

  void _updateState(state) {
    _state = state;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future<List<Brand>> getBrands() async {
    _updateState(FSLoadState.loading);
    _page = 1;
    _brands.clear();
    final list =
        await _services.api.getBrands(page: _page, perPage: _perPage) ?? [];
    if (list.isNotEmpty) {
      _brands.addAll(list);
      _updateState(FSLoadState.loaded);
    } else {
      _updateState(FSLoadState.noData);
    }

    return list;
  }

  Future<List<Brand>> loadBrands() async {
    if (_state == FSLoadState.noData) {
      return [];
    }
    _page++;
    final list =
        await _services.api.getBrands(page: _page, perPage: _perPage) ?? [];
    if (list.isNotEmpty) {
      _brands.addAll(list);
      _updateState(FSLoadState.loaded);
    } else {
      _updateState(FSLoadState.noData);
    }

    return list;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
