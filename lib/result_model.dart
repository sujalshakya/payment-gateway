enum Status { success, failed, cancellation }

class Result<T> {
  final Status status;
  final T? data;
  final String? message;

  Result._({required this.status, this.data, this.message});

  factory Result.success(T data) {
    return Result._(status: Status.success, data: data);
  }

  factory Result.failed(String message) {
    return Result._(status: Status.failed, message: message);
  }

  factory Result.cancellation(String message) {
    return Result._(status: Status.cancellation, message: message);
  }

  bool get isSuccess => status == Status.success;
  bool get isFailed => status == Status.failed;
  bool get isCancelled => status == Status.cancellation;
}
