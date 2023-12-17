import 'package:eve_app/utils/app_utils.dart';
import 'package:flutter_test/flutter_test.dart';

Future main() async {
  group("Url utils:", (() {
    test('getUrlParams should return a map with the params of the given URL', () {
      String url1 = "https://www.google.com/search?client=firefox&q=flutter";
      Map<String, String> expectedParams = {"client": "firefox", "q": "flutter"};
      Map<String, String> noteExpectedParams = {"a": "aa", "b": "bb"};
      Map<String, String> actualParams = AppUtils.urlAndNetworkUtils.getUrlParams(url1);
      expect(actualParams, isNot(noteExpectedParams));
      expect(actualParams, expectedParams);
    });

    test('getUrlWithoutParams should return the url without params', () {
      String url1 = "https://www.google.com/search?client=firefox&q=flutter";
      String expectedResukt = "https://www.google.com/search";
      String actualResult = AppUtils.urlAndNetworkUtils.getUrlWithoutParams(url1);
      expect(actualResult, expectedResukt);
    });
  }));
}
