import 'dart:js_interop';

@JS('grecaptcha.enterprise')
extension type RecaptchaEnterprise._(JSObject _) implements JSObject {
  external JSPromise<JSString> execute(JSString siteKey, JSObject options);
  external void ready(JSFunction callback);
}

@JS('grecaptcha.enterprise')
external RecaptchaEnterprise get grecaptchaEnterprise;

class RecaptchaService {
  static Future<String?> execute(String siteKey, String action) async {
    try {
      final options = {'action': action}.jsify() as JSObject;
      final promise = grecaptchaEnterprise.execute(siteKey.toJS, options);
      final result = await promise.toDart;
      return result.toDart;
    } catch (e) {
      print('Recaptcha Enterprise error: $e');
      return null;
    }
  }
}
