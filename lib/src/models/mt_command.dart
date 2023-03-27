part of 'models.dart';

MtCommand mtCommandFromJson(String str) => MtCommand.fromJson(json.decode(str));

String mtCommandToJson(MtCommand data) => json.encode(data.toJson());

class MtCommand {
  MtCommand({
    this.event,
    this.command,
    this.date,
    this.kw,
  });

  String? event;
  String? command;
  String? date;
  KwCommand? kw;

  factory MtCommand.fromJson(Map<String, dynamic> json) => MtCommand(
        event: json["event"],
        command: json["command"],
        date: json["date"],
        kw: json["kw"] == null ? null : KwCommand.fromJson(json["kw"]),
      );

  Map<String, dynamic> toJson() => {
        "event": event,
        "command": command,
        "date": date,
        "kw": kw?.toJson(),
      };
}

class KwCommand {
  KwCommand({
    this.mdIev,
    this.command,
    this.temp,
  });

  MdIevCommand? mdIev;
  String? command;
  Temp? temp;

  factory KwCommand.fromJson(Map<String, dynamic> json) => KwCommand(
        mdIev: json["__md_iev__"] == null ? null : MdIevCommand.fromJson(json["__md_iev__"]),
        command: json["__command__"],
        temp: json["__temp__"] == null ? null : Temp.fromJson(json["__temp__"]),
      );

  Map<String, dynamic> toJson() => {
        "__md_iev__": mdIev?.toJson(),
        "__command__": command,
        "__temp__": temp?.toJson(),
      };
}

class MdIevCommand {
  MdIevCommand({
    this.ieventGateStack,
    this.command,
  });

  List<IeventGateStack>? ieventGateStack;
  List<String>? command;

  factory MdIevCommand.fromJson(Map<String, dynamic> json) => MdIevCommand(
        ieventGateStack: json["ievent_gate_stack"] == null
            ? []
            : List<IeventGateStack>.from(json["ievent_gate_stack"]!.map((x) => IeventGateStack.fromJson(x))),
        command: json["__command__"] == null ? [] : List<String>.from(json["__command__"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "ievent_gate_stack": ieventGateStack == null ? [] : List<dynamic>.from(ieventGateStack!.map((x) => x.toJson())),
        "__command__": command == null ? [] : List<dynamic>.from(command!.map((x) => x)),
      };
}
