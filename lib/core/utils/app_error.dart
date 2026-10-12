class AppError {
  final String message;

  AppError(this.message);

  static String getMessage(dynamic e) {
    if (e.toString().contains("SocketException")) {
      return "No internet connection";
    }

    if (e.toString().contains("timeout")) {
      return "Request timed out";
    }

    return "Something went wrong";
  }
}