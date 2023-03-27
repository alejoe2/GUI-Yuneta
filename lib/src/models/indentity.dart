part of 'models.dart';

Identity identityFromJson(String str) => Identity.fromJson(json.decode(str));

String identityToJson(Identity data) => json.encode(data.toJson());

class Identity {
  Identity({
    this.event,
    this.kw,
  });

  String? event;
  Kw? kw;

  factory Identity.fromJson(Map<String, dynamic> json) => Identity(
        event: json["event"],
        kw: json["kw"] == null ? null : Kw.fromJson(json["kw"]),
      );

  Map<String, dynamic> toJson() => {
        "event": event,
        "kw": kw?.toJson(),
      };
}

class Kw {
  Kw({
    this.yunoRole,
    this.yunoId,
    this.yunoName,
    this.yunoTag,
    this.yunoVersion,
    this.yunoRelease,
    this.yunetaVersion,
    this.playing,
    this.pid,
    this.watcherPid,
    this.jwt,
    this.username,
    this.launchId,
    this.yunoStartdate,
    this.id,
    this.requiredServices,
    this.mdIev,
    this.temp,
  });

  String? yunoRole;
  String? yunoId;
  String? yunoName;
  String? yunoTag;
  String? yunoVersion;
  String? yunoRelease;
  String? yunetaVersion;
  bool? playing;
  int? pid;
  int? watcherPid;
  String? jwt;
  String? username;
  int? launchId;
  String? yunoStartdate;
  String? id;
  List<dynamic>? requiredServices;
  MdIev? mdIev;
  Temp? temp;

  factory Kw.fromJson(Map<String, dynamic> json) => Kw(
        yunoRole: json["yuno_role"],
        yunoId: json["yuno_id"],
        yunoName: json["yuno_name"],
        yunoTag: json["yuno_tag"],
        yunoVersion: json["yuno_version"],
        yunoRelease: json["yuno_release"],
        yunetaVersion: json["yuneta_version"],
        playing: json["playing"],
        pid: json["pid"],
        watcherPid: json["watcher_pid"],
        jwt: json["jwt"],
        username: json["username"],
        launchId: json["launch_id"],
        yunoStartdate: json["yuno_startdate"],
        id: json["id"],
        requiredServices:
            json["required_services"] == null ? [] : List<dynamic>.from(json["required_services"]!.map((x) => x)),
        mdIev: json["__md_iev__"] == null ? null : MdIev.fromJson(json["__md_iev__"]),
        temp: json["__temp__"] == null ? null : Temp.fromJson(json["__temp__"]),
      );

  Map<String, dynamic> toJson() => {
        "yuno_role": yunoRole,
        "yuno_id": yunoId,
        "yuno_name": yunoName,
        "yuno_tag": yunoTag,
        "yuno_version": yunoVersion,
        "yuno_release": yunoRelease,
        "yuneta_version": yunetaVersion,
        "playing": playing,
        "pid": pid,
        "watcher_pid": watcherPid,
        "jwt": jwt,
        "username": username,
        "launch_id": launchId,
        "yuno_startdate": yunoStartdate,
        "id": id,
        "required_services": requiredServices == null ? [] : List<dynamic>.from(requiredServices!.map((x) => x)),
        "__md_iev__": mdIev?.toJson(),
        "__temp__": temp?.toJson(),
      };
}

class MdIev {
  MdIev({
    this.ieventGateStack,
    this.command,
  });

  List<IeventGateStack>? ieventGateStack;
  List<String>? command;

  factory MdIev.fromJson(Map<String, dynamic> json) => MdIev(
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

class IeventGateStack {
  IeventGateStack({
    this.dstYuno,
    this.dstRole,
    this.dstService,
    this.srcYuno,
    this.srcRole,
    this.srcService,
    this.user,
    this.host,
  });

  String? dstYuno;
  String? dstRole;
  String? dstService;
  String? srcYuno;
  String? srcRole;
  String? srcService;
  String? user;
  String? host;

  factory IeventGateStack.fromJson(Map<String, dynamic> json) => IeventGateStack(
        dstYuno: json["dst_yuno"],
        dstRole: json["dst_role"],
        dstService: json["dst_service"],
        srcYuno: json["src_yuno"],
        srcRole: json["src_role"],
        srcService: json["src_service"],
        user: json["user"],
        host: json["host"],
      );

  Map<String, dynamic> toJson() => {
        "dst_yuno": dstYuno,
        "dst_role": dstRole,
        "dst_service": dstService,
        "src_yuno": srcYuno,
        "src_role": srcRole,
        "src_service": srcService,
        "user": user,
        "host": host,
      };
}

class Temp {
  Temp({
    this.username,
  });

  String? username;

  factory Temp.fromJson(Map<String, dynamic> json) => Temp(
        username: json["__username__"],
      );

  Map<String, dynamic> toJson() => {
        "__username__": username,
      };
}
