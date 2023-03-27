part of 'models.dart';

EventAck eventAckFromJson(String str) => EventAck.fromJson(json.decode(str));

String eventAckToJson(EventAck data) => json.encode(data.toJson());

class EventAck {
  EventAck({
    this.event,
    this.kw,
  });

  String? event;
  KwEventACK? kw;

  factory EventAck.fromJson(Map<String, dynamic> json) => EventAck(
        event: json["event"],
        kw: json["kw"] == null ? null : KwEventACK.fromJson(json["kw"]),
      );

  Map<String, dynamic> toJson() => {
        "event": event,
        "kw": kw?.toJson(),
      };
}

class KwEventACK {
  KwEventACK({
    this.result,
    this.comment,
    this.username,
    this.dstService,
    this.servicesRoles,
    this.jwtPayload,
    this.mdIev,
  });

  int? result;
  String? comment;
  String? username;
  String? dstService;
  ServicesRoles? servicesRoles;
  dynamic jwtPayload;
  MdIev? mdIev;

  factory KwEventACK.fromJson(Map<String, dynamic> json) => KwEventACK(
        result: json["result"],
        comment: json["comment"],
        username: json["username"],
        dstService: json["dst_service"],
        servicesRoles: json["services_roles"] == null ? null : ServicesRoles.fromJson(json["services_roles"]),
        jwtPayload: json["jwt_payload"],
        mdIev: json["__md_iev__"] == null ? null : MdIev.fromJson(json["__md_iev__"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "comment": comment,
        "username": username,
        "dst_service": dstService,
        "services_roles": servicesRoles?.toJson(),
        "jwt_payload": jwtPayload,
        "__md_iev__": mdIev?.toJson(),
      };
}

class MdIevEventACK {
  MdIevEventACK({
    this.ieventGateStack,
    this.command,
    this.mdYuno,
  });

  List<IeventGateStack>? ieventGateStack;
  List<dynamic>? command;
  MdYuno? mdYuno;

  factory MdIevEventACK.fromJson(Map<String, dynamic> json) => MdIevEventACK(
        ieventGateStack: json["ievent_gate_stack"] == null
            ? []
            : List<IeventGateStack>.from(json["ievent_gate_stack"]!.map((x) => IeventGateStack.fromJson(x))),
        command: json["__command__"] == null ? [] : List<dynamic>.from(json["__command__"]!.map((x) => x)),
        mdYuno: json["__md_yuno__"] == null ? null : MdYuno.fromJson(json["__md_yuno__"]),
      );

  Map<String, dynamic> toJson() => {
        "ievent_gate_stack": ieventGateStack == null ? [] : List<dynamic>.from(ieventGateStack!.map((x) => x.toJson())),
        "__command__": command == null ? [] : List<dynamic>.from(command!.map((x) => x)),
        "__md_yuno__": mdYuno?.toJson(),
      };
}

class MdYuno {
  MdYuno({
    this.realmName,
    this.yunoRole,
    this.yunoName,
    this.yunoId,
    this.pid,
    this.user,
  });

  String? realmName;
  String? yunoRole;
  String? yunoName;
  String? yunoId;
  int? pid;
  String? user;

  factory MdYuno.fromJson(Map<String, dynamic> json) => MdYuno(
        realmName: json["realm_name"],
        yunoRole: json["yuno_role"],
        yunoName: json["yuno_name"],
        yunoId: json["yuno_id"],
        pid: json["pid"],
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "realm_name": realmName,
        "yuno_role": yunoRole,
        "yuno_name": yunoName,
        "yuno_id": yunoId,
        "pid": pid,
        "user": user,
      };
}

class ServicesRoles {
  ServicesRoles({
    this.agent,
  });

  List<String>? agent;

  factory ServicesRoles.fromJson(Map<String, dynamic> json) => ServicesRoles(
        agent: json["agent"] == null ? [] : List<String>.from(json["agent"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "agent": agent == null ? [] : List<dynamic>.from(agent!.map((x) => x)),
      };
}
