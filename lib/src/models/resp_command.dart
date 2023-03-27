part of 'models.dart';

RespCommand respCommandFromJson(String str) => RespCommand.fromJson(json.decode(str));

String respCommandToJson(RespCommand data) => json.encode(data.toJson());

class RespCommand {
  RespCommand({
    this.event,
    this.kw,
  });

  String? event;
  KwRespCommand? kw;

  factory RespCommand.fromJson(Map<String, dynamic> json) => RespCommand(
        event: json["event"],
        kw: json["kw"] == null ? null : KwRespCommand.fromJson(json["kw"]),
      );

  Map<String, dynamic> toJson() => {
        "event": event,
        "kw": kw?.toJson(),
      };
}

class KwRespCommand {
  KwRespCommand({
    this.result,
    this.comment,
    this.schema,
    this.data,
    this.mdIev,
  });

  int? result;
  String? comment;
  dynamic schema;
  dynamic data;
  MdIevRespCommand? mdIev;

  factory KwRespCommand.fromJson(Map<String, dynamic> json) => KwRespCommand(
        result: json["result"],
        comment: json["comment"],
        schema: json["schema"],
        data: json["data"],
        mdIev: json["__md_iev__"] == null ? null : MdIevRespCommand.fromJson(json["__md_iev__"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "comment": comment,
        "schema": schema,
        "data": data,
        "__md_iev__": mdIev?.toJson(),
      };
}

class MdIevRespCommand {
  MdIevRespCommand({
    this.ieventGateStack,
    this.command,
    this.mdYuno,
  });

  List<IeventGateStack>? ieventGateStack;
  List<String>? command;
  MdYuno? mdYuno;

  factory MdIevRespCommand.fromJson(Map<String, dynamic> json) => MdIevRespCommand(
        ieventGateStack: json["ievent_gate_stack"] == null
            ? []
            : List<IeventGateStack>.from(json["ievent_gate_stack"]!.map((x) => IeventGateStack.fromJson(x))),
        command: json["__command__"] == null ? [] : List<String>.from(json["__command__"]!.map((x) => x)),
        mdYuno: json["__md_yuno__"] == null ? null : MdYuno.fromJson(json["__md_yuno__"]),
      );

  Map<String, dynamic> toJson() => {
        "ievent_gate_stack": ieventGateStack == null ? [] : List<dynamic>.from(ieventGateStack!.map((x) => x.toJson())),
        "__command__": command == null ? [] : List<dynamic>.from(command!.map((x) => x)),
        "__md_yuno__": mdYuno?.toJson(),
      };
}
