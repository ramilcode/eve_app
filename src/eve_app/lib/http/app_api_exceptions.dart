class AppException implements Exception {
  final String? prefix;
  final String? url;
  final String? message;
  final int? statusCode;
  final dynamic errorCode;
  final String? reason;
  final String? description;

  AppException({
    this.prefix,
    this.url,
    this.message,
    this.statusCode,
    this.errorCode,
    this.reason,
    this.description,
  });
  @override
  String toString() {
    return 'AppException(prefix: $prefix, url: $url, message: $message, errorCode: $errorCode, statusCode: $statusCode, reason: $reason)';
  }
}

class AppHTTPException extends AppException {
  AppHTTPException(Map<String, dynamic> appHttpException, String url)
      : super(
          prefix: 'Erreur HTTP',
          url: url,
          message: appHttpException["message"],
          statusCode: appHttpException["status_code"],
          errorCode: appHttpException["error_code"],
          reason:
              appHttpException.keys.contains("detail") && appHttpException["detail"] is! List && appHttpException["detail"].keys.contains("reason")
                  ? appHttpException["detail"]["reason"]
                  : null,
          description: appHttpException["description"] is List || appHttpException["description"] == []
              ? null
              : appHttpException["description"], //custom fixes here too
        );
}
