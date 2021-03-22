// To parse this JSON data, do
//
//     final koResponse = koResponseFromJson(jsonString);

import 'dart:convert';

KoResponse koResponseFromJson(String str) => KoResponse.fromJson(json.decode(str));

String koResponseToJson(KoResponse data) => json.encode(data.toJson());

class KoResponse {
  KoResponse({
    this.ok,
    this.msg,
  });

  bool ok;
  String msg;

  factory KoResponse.fromJson(Map<String, dynamic> json) => KoResponse(
    ok: json["ok"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "msg": msg,
  };
}