class KhaltiPidxResponse {
  final String? pidx;
  final String? status;
  final String? message;

  KhaltiPidxResponse({this.pidx, this.status, this.message});

  factory KhaltiPidxResponse.fromJson(Map<String, dynamic> json) {
    return KhaltiPidxResponse(
      pidx: json['pidx'] as String?,
      status: json['status'] as String?,
      message: json['message'] as String?,
    );
  }
}
