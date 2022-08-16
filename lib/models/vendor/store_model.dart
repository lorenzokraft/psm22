import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:quiver/strings.dart';

import '../../common/constants.dart';
import '../../services/index.dart';
import '../entities/vacation_settings.dart';

class StoreModel with ChangeNotifier {
  final Services _service = Services();
  final String langCode;

  StoreModel({
    this.langCode = '',
  });

  List<Store>? _stores;
  List<Store>? lstFeaturedStores;
  bool isLoading = true;
  String? message;
  int _currentPage = 0;
  String _currentNameSearch = '';
  bool _isEnd = false;

  bool get isEnd => _isEnd;

  List<Store>? get stores => _stores;

  Future<List<Store>?> getFeaturedStores() async {
    if (lstFeaturedStores != null) {
      if (lstFeaturedStores!.isNotEmpty) {
        return lstFeaturedStores;
      }
    }
    try {
      var list = await _service.api.getFeaturedStores()!;
      lstFeaturedStores = list;
    } catch (err) {
      printLog('err $err');
    }
    return lstFeaturedStores;
  }

  Future<List<Store>> getListStore({lang, page}) async {
    var stores = await _service.api.searchStores(page: page)!;
    var lstStores = <Store>[];

    for (var store in stores) {
      if (store.long != null && store.lat != null) {
        lstStores.add(store);
      }
    }
    return lstStores;
  }

  // Can use search
  Future<void> loadStore({String name = '', Function? onFinish}) async {
    isLoading = true;
    notifyListeners();
    if (_currentNameSearch != name) {
      _currentPage = 1;
      _currentNameSearch = name;
      _stores = null;
    } else {
      _currentPage++;
    }

    var data = await _service.api.searchStores(
      keyword: name,
      page: _currentPage,
    )!;

    if (data.isEmpty) {
      if (onFinish != null) {
        onFinish();
      }
      _isEnd = true;
      isLoading = false;
      _stores ??= [];
      notifyListeners();
      return;
    }

    _stores = [...stores ?? [], ...data];
    isLoading = false;
    if (onFinish != null) {
      onFinish();
    }
    notifyListeners();
  }
}

class Store {
  int? id;
  String? name;
  String? email;
  String? chatEmail;
  double? rating;
  String? image;
  String? address;
  String? banner;
  String? phone;
  String? website;
  bool? isFeatured;
  double? lat;
  double? long;
  Map<String, String>? socials;
  StoreHour? storeHour;
  VacationSettings? vacationSettings;
  String? link;

  Store.fromDokanJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];

    if (parsedJson['first_name'] != null && parsedJson['last_name'] != null) {
      name = '${parsedJson["first_name"]} ${parsedJson["last_name"]}';
    }

    link = parsedJson['shop_url'];

    if (parsedJson['name'] != null) {
      name = parsedJson['name'];
    }
    if (parsedJson['shop_name'] != null) {
      name = parsedJson['shop_name'];
    }
    if (parsedJson['store_name'] != null) {
      name = parsedJson['store_name'];
    }
    email = parsedJson['email'] ?? '';
    chatEmail = email;
    rating = 0.0;
    if (parsedJson['rating'] != null) {
      if (parsedJson['rating']['rating'] != null &&
          double.tryParse(parsedJson['rating']['rating']) != null) {
        rating = double.parse("${parsedJson["rating"]["rating"]}");
      }
    }

    name = HtmlUnescape().convert(name!);

    final String? stringLocation = parsedJson['location'];

    if (stringLocation?.isNotEmpty ?? false) {
      final arrLocation = stringLocation!.split(',');
      lat = arrLocation[0] != '' ? double.parse(arrLocation[0]) : 0;
      long = arrLocation[1] != '' ? double.parse(arrLocation[1]) : 0;
    }

    if (parsedJson['gravatar'] != null) {
      image = parsedJson['gravatar'] is String ? parsedJson['gravatar'] : null;
    }
    address =
        parsedJson['address'] is Map ? parsedJson['address']['street_1'] : '';
    banner = parsedJson['banner'] is String && isNotBlank(parsedJson['banner'])
        ? parsedJson['banner']
        : null;
    phone = parsedJson['phone'];
    isFeatured = parsedJson['featured'] ?? false;

    final time = parsedJson['store_open_close']?['time'];

    if (time != null && time is Map && time.isNotEmpty) {
      storeHour = StoreHour.fromDokan(time);
    }

    try {
      if (parsedJson['social'] is Map) {
        Map social = parsedJson['social'] ?? {};

        String? key = social.keys
            .firstWhere((o) => isNotBlank(social[o]), orElse: () => '');
        if (isNotBlank(key)) {
          website = social[key];
        }
      }
    } catch (e, trace) {
      printLog(trace);
      printLog(e.toString());
    }
  }

  Store.fromWCFMJson(Map<String, dynamic> parsedJson) {
    id = int.parse("${parsedJson["vendor_id"]}");
    name = HtmlUnescape().convert(parsedJson['vendor_shop_name']);
    email = parsedJson['vendor_email'];
    link = parsedJson['shop_url'];
    chatEmail = parsedJson['chat_email'] ?? email;
    rating = double.parse((parsedJson['store_rating'] != null &&
            parsedJson['store_rating'].toString().isNotEmpty)
        ? parsedJson['store_rating'].toString()
        : '0.0');
    address = parsedJson['vendor_address'];

    if (parsedJson['settings'] != null && parsedJson['settings'] is Map) {
      image = parsedJson['settings']['gravatar'].toString().isNotEmpty &&
              parsedJson['settings']['gravatar'].toString().contains('http')
          ? parsedJson['settings']['gravatar']
          : null;
      banner = parsedJson['settings']['mobile_banner'].toString().isNotEmpty &&
              parsedJson['settings']['mobile_banner']
                  .toString()
                  .contains('http')
          ? parsedJson['settings']['mobile_banner']
          : null;
      if (isBlank(banner)) {
        banner = parsedJson['settings']['banner'].toString().isNotEmpty &&
                parsedJson['settings']['banner'].toString().contains('http')
            ? parsedJson['settings']['banner']
            : null;
      }
      if (isBlank(banner)) {
        banner = parsedJson['mobile_banner'] ??
            parsedJson['vendor_banner'] ??
            parsedJson['vendor_list_banner'];
      }
      if (isBlank(image) && parsedJson['vendor_shop_logo'] != false) {
        image = parsedJson['vendor_shop_logo'];
      }
      try {
        lat = double.parse(parsedJson['settings']['store_lat']);
        long = double.parse(parsedJson['settings']['store_lng']);
      } catch (e) {
        lat = null;
        long = null;
      }

      phone = '';
      if (parsedJson['settings']['phone'] is List) {
        if (parsedJson['settings']['phone'].isNotEmpty) {
          phone = parsedJson['settings']['phone'][0];
        }
      }
      if (parsedJson['settings']['phone'] is String) {
        phone = parsedJson['settings']['phone'];
      }
      final _socials = parsedJson['settings']['social'];
      if (_socials != null && _socials is Map) {
        socials = Map<String, String>.from(_socials);
        if (socials!['fb'] != null) {
          socials!['facebook'] = socials!['fb'].toString();
          socials!.remove('fb');
        }
      }

      if (parsedJson['settings']['wcfm_store_hours'] != null) {
        storeHour =
            StoreHour.fromWCFM(parsedJson['settings']['wcfm_store_hours']);
      }
      vacationSettings = VacationSettings.fromJson(parsedJson['settings']);
    } else {
      banner = parsedJson['mobile_banner'] ??
          parsedJson['vendor_shop_logo'] ??
          parsedJson['vendor_banner'] ??
          parsedJson['vendor_list_banner'];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'rating': rating,
      'image': image,
      'address': address,
      'banner': banner,
      'phone': phone,
      'website': website
    };
  }

  Store.fromLocalJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
      email = json['email'];
      rating = json['rating'];
      image = json['image'];
      address = json['address'];
      banner = json['banner'];
      phone = json['phone'];
      website = json['website'];
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }
}

class StoreHour {
  bool? isDisablePurchase;

  List<int> offDays = [];
  List<StoreWorkingHour> workingHours = [];

  StoreHour.fromWCFM(json) {
    isDisablePurchase = ((json['disable_purchase'] ?? 'no') == 'yes');
    final dayTime = json['day_times'];
    if (dayTime != null) {
      for (var i = 0; i < dayTime.length; i++) {
        workingHours.add(StoreWorkingHour.fromWCFM(i + 1, dayTime[i]));
      }
    }
    if (json['off_days'] != null) {
      for (var time in json['off_days']) {
        offDays.add(int.parse(time));
      }
    }
  }

  StoreHour.fromDokan(Map json) {
    isDisablePurchase = false;
    json.forEach((key, value) {
      int weekday;
      switch (key) {
        case 'monday':
          weekday = 1;
          break;
        case 'tuesday':
          weekday = 2;
          break;
        case 'wednesday':
          weekday = 3;
          break;
        case 'thursday':
          weekday = 4;
          break;
        case 'friday':
          weekday = 5;
          break;
        case 'saturday':
          weekday = 6;
          break;
        case 'sunday':
          weekday = 7;
          break;
        default:
          weekday = 1;
          break;
      }
      if ((value['status'] ?? 'close') == 'close') {
        offDays.add(weekday);
      }
      workingHours.add(StoreWorkingHour.fromDokan(weekday, value));
    });
  }

  bool isOpen() {
    if (!isOffDay()) {
      final now = DateTime.now();
      if (workingHours[now.weekday - 1].hours.isEmpty) {
        return true;
      }
      for (var hour in workingHours[now.weekday - 1].hours) {
        if (hour.start != null && hour.end != null) {
          if (now.isAfter(hour.start!) && now.isBefore(hour.end!)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool isOffDay() {
    final now = DateTime.now();
    return offDays.contains(now.weekday);
  }
}

class StoreWorkingHour {
  int? weekday;
  List<WorkingHour> hours = [];

  StoreWorkingHour.fromWCFM(this.weekday, dayTimes) {
    if (dayTimes is List) {
      for (var hour in dayTimes) {
        if (hour['start'].isNotEmpty && hour['end'].isNotEmpty) {
          hours.add(WorkingHour.fromWCFM(hour['start'], hour['end']));
        }
      }
    }
    if (dayTimes is Map) {
      dayTimes.forEach((key, value) {
        if (value is Map && value['start'].isNotEmpty && value['end'].isNotEmpty) {
          hours.add(WorkingHour.fromWCFM(value['start'], value['end']));
        }
      });
    }
  }

  StoreWorkingHour.fromDokan(this.weekday, json) {
    try {
      if ((json['status'] ?? 'close') != 'close') {
        var openTime = json['opening_time'];
        var closeTime = json['closing_time'];
        if (openTime != null && closeTime != null) {
          openTime = openTime.replaceAll('h', ':');
          closeTime = closeTime.replaceAll('h', ':');
          if (openTime.length == 4) {
            openTime = '0$openTime';
          }
          if (closeTime.length == 4) {
            closeTime = '0$closeTime';
          }
          hours.add(WorkingHour.fromDokan(openTime, closeTime));
        }
      }
    } catch (e) {
      printLog(e.toString());
    }
  }
}

class WorkingHour {
  DateTime? start;
  DateTime? end;

  WorkingHour.fromWCFM(String startTime, String endTime) {
    final now = DateTime.now();
    start = DateTime.parse(
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} $startTime:00');
    end = DateTime.parse(
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} $endTime:00');
  }

  WorkingHour.fromDokan(String startTime, String endTime) {
    final now = DateTime.now();
    start = DateTime.parse(
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} $startTime:00');
    end = DateTime.parse(
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} $endTime:00');
  }
}
