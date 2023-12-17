class UrlAndNetworkUtils {
  ///returns params of url, example {"name": "tom", ...}
  Map<String, String> getUrlParams(String url) {
    // xPrint("Login success url: $url");
    Map<String, String> params = {};
    var uri = Uri.parse(url);
    uri.queryParameters.forEach((key, value) {
      params[key] = value;
      // print('$key: $value');
    });
    return params;
  }

  ///returns the url without params
  String getUrlWithoutParams(String url) {
    String urlWithoutParams = url.split("?")[0];
    return urlWithoutParams;
  }
}
