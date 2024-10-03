import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../models/data_model.dart';

class HomeViewModel extends ChangeNotifier {
  final scrollController = ScrollController();
  final _dio = Dio();
  final String _url = "https://dummyjson.com/posts";
  int _skip = 0;
  bool loading = false;

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  DataModel? dataModel;

  Future<void> fetchData() async {
    final args = {"limit": 10, "skip": _skip};

    setLoading(true);
    final Response res = await _dio.request(_url, queryParameters: args);
    setLoading(false);

    if (res.statusCode != 200)
      return Future.error("Hata: ${res.statusMessage}");

    _skip += 10;

    final DataModel data = DataModel.fromJson(res.data);

    if (dataModel == null) {
      dataModel = data;
    } else {
      dataModel!.posts.addAll(data.posts);
    }

    notifyListeners();
  }

  void listenScrollBottom() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        final bool top = scrollController.position.pixels == 0;
        if (!top && !loading) fetchData();
      }
    });
  }
}
