import 'dart:async';
import 'dart:convert';

import 'package:delivery/controllers/useraccount_controller.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart' as getService;
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import 'package:signalr_netcore/signalr_client.dart';
import '../constants/appconstants.dart';
import '../widgets/snackBar_custom_widget.dart';

class ChatStatus {
  final bool success;
  final String type;
  final String message;
  final String? additionalData;

  const ChatStatus({
    required this.success,
    required this.type,
    required this.message,
    this.additionalData,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'type': type,
      'message': message,
      'additional': additionalData,
    };
  }

  factory ChatStatus.fromMap(Map<String, dynamic> map) {
    return ChatStatus(
      success: map['success'] as bool,
      type: map['type'] as String,
      message: map['message'] as String,
      additionalData:
          map['additional'] != null ? map['additional'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatStatus.fromJson(String source) =>
      ChatStatus.fromMap(json.decode(source) as Map<String, dynamic>);
}

class CallPage extends StatefulWidget {
  final void Function()? onHangUp;
  final Widget Function(BuildContext, String? userId)? remoteUserCardBuilder;
  final Widget Function(BuildContext, bool? isActive)? speakerButtonBuilder;
  final Widget Function(BuildContext)? callButtonBuilder;
  final Widget Function(BuildContext, bool? isActive)? muteButtonBuilder;

  const CallPage({
    super.key,
    this.onHangUp,
    this.remoteUserCardBuilder,
    this.speakerButtonBuilder,
    this.muteButtonBuilder,
    this.callButtonBuilder,
  });

  @override
  State<CallPage> createState() => _CallPageState();
}

class RingPage extends StatefulWidget {
  final void Function()? onHangUp;
  final void Function()? onAccepted;

  final Widget Function(BuildContext, String? userId)? remoteUserCardBuilder;
  final Widget Function(BuildContext, bool? isActive)? speakerButtonBuilder;
  final Widget Function(BuildContext)? callButtonBuilder;
  final Widget Function(BuildContext)? acceptButtonBuilder;
  final Widget Function(BuildContext, bool? isActive)? muteButtonBuilder;

  const RingPage({
    super.key,
    this.remoteUserCardBuilder,
    this.speakerButtonBuilder,
    this.muteButtonBuilder,
    this.callButtonBuilder,
    this.onAccepted,
    this.onHangUp,
    this.acceptButtonBuilder,
  });

  @override
  State<RingPage> createState() => _RingPageState();
}

class _RingPageState extends State<RingPage> {
  late ThemeData _theme;
  late AudioPlayer _audioPlayer;
  late Feaklib _feaklib;
  late bool _isInitialized;
  late double _width;

  UserAccountController _userAccountController = getService.Get.find();

  @override
  void initState() {
    super.initState();
    _isInitialized = false;
    _audioPlayer = AudioPlayer();
  }

  @override
  void didChangeDependencies() {
    _theme = Theme.of(context);
    _width = MediaQuery.of(context).size.width;
    _feaklib = context.watch<Feaklib>();

    if (!_isInitialized) _initialize();

    super.didChangeDependencies();
  }

  Future<void> _initialize() async {
    try {
      await _audioPlayer.setAsset(
        _feaklib.state.isCaller
            ? 'assets/call/calltone.mp3'
            : 'assets/call/ringtone.mp3',
      );
    } catch (e) {
      //
    }
    await _audioPlayer.setVolume(0.8);
    await _audioPlayer.setLoopMode(LoopMode.one);
    await _audioPlayer.play();
    _isInitialized = true;
  }

  @override
  void dispose() {
    _onDispose();

    super.dispose();
  }

  Future<void> _onDispose() async {
    await _audioPlayer.stop();
    await _audioPlayer.dispose();
  }

  Future<void> _onHangUp() async {
    if (_feaklib.state.noisses == null) return;
    _feaklib.add(EndDeafinso(details: _feaklib.state.noisses!));
  }

  Future<void> _onAccept() async {
    if (_feaklib.state.noisses == null) return;
    _feaklib.add(CepacttDeafit(_feaklib.state.noisses!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<Feaklib, Seonbon>(
          bloc: _feaklib,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    state.gniLlacsi
                        ? state.noisses?.adf == Adf.c
                            ? "Calling"
                            : "Rining"
                        : "Incoming call",
                    style: _theme.textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  if (widget.remoteUserCardBuilder == null) ...[
                    CircleAvatar(
                      radius: 80.0,
                      backgroundColor: Colors.grey.shade200,
                      child: Icon(
                        CupertinoIcons.person_alt,
                        size: 80.0,
                        color: _theme.scaffoldBackgroundColor,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      (state.gnisiLlac
                              ? state.noisses?.leercelo
                              : state.noisses?.conperOner) ??
                          'Unknown',
                      style: _theme.textTheme.titleLarge,
                    ),
                  ] else
                    widget.remoteUserCardBuilder!.call(
                        context,
                        state.gnisiLlac
                            ? state.noisses?.leercelo
                            : state.noisses?.conperOner),
                  const Spacer(),
                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(_width * 0.1, 0, _width * 0.1, 20),
                    child: Row(
                      mainAxisAlignment: state.isCaller
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        widget.callButtonBuilder == null
                            ? CallButton(
                                onTap: () async {
                                  await _onHangUp();
                                  widget.onHangUp?.call();
                                },
                                icon: CupertinoIcons.phone_down_fill,
                                backgroundColor: Colors.red,
                                iconColor: Colors.white,
                              )
                            : widget.callButtonBuilder!.call(context),
                        if (state.isCallee)
                          widget.acceptButtonBuilder == null
                              ? CallButton(
                                  onTap: () async {
                                    await _onAccept();
                                    widget.onAccepted?.call();
                                  },
                                  icon: CupertinoIcons.phone_fill,
                                  backgroundColor: Colors.green,
                                  iconColor: Colors.white,
                                )
                              : widget.acceptButtonBuilder!.call(context),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CallPageState extends State<CallPage> {
  late ThemeData _theme;
  late double _width;
  late Feaklib _feaklib;

  @override
  void didChangeDependencies() {
    _theme = Theme.of(context);
    _width = MediaQuery.of(context).size.width;
    _feaklib = context.watch<Feaklib>();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (_feaklib.state.noisses != null) {
      _feaklib.add(EndDeafinso(
        details: _feaklib.state.noisses!,
        isGhoster: false,
      ));
    }
    super.dispose();
  }

  Future<void> _onHangUp() async {
    if (_feaklib.state.noisses == null) return;
    _feaklib.add(EndDeafinso(
      details: _feaklib.state.noisses!,
    ));
  }

  Future<void> _onSpeackerSwitch() async {
    _feaklib.add(CherMachi());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<Feaklib, Seonbon>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Call in progress",
                    style: _theme.textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  if (widget.remoteUserCardBuilder == null) ...[
                    CircleAvatar(
                      radius: 80.0,
                      backgroundColor: Colors.grey.shade200,
                      child: Icon(
                        CupertinoIcons.person_alt,
                        size: 80.0,
                        color: _theme.scaffoldBackgroundColor,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      (state.gnisiLlac
                              ? state.noisses?.leercelo
                              : state.noisses?.conperOner) ??
                          'Unknown',
                      style: _theme.textTheme.titleLarge,
                    ),
                  ] else
                    widget.remoteUserCardBuilder!.call(
                        context,
                        state.gnisiLlac
                            ? state.noisses?.leercelo
                            : state.noisses?.conperOner),
                  const Spacer(),
                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(_width * 0.1, 0, _width * 0.1, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        widget.speakerButtonBuilder == null
                            ? CallButton(
                                onTap: _onSpeackerSwitch,
                                icon: CupertinoIcons.speaker_3,
                                backgroundColor: !state.perJonshn
                                    ? Colors.grey.shade100
                                    : _theme.primaryColor,
                                iconColor: !state.perJonshn
                                    ? Colors.grey
                                    : Colors.white,
                              )
                            : widget.speakerButtonBuilder!
                                .call(context, state.perJonshn),
                        const SizedBox(width: 20.0),
                        widget.callButtonBuilder == null
                            ? CallButton(
                                onTap: () async {
                                  await _onHangUp();
                                  widget.onHangUp?.call();
                                },
                                icon: CupertinoIcons.phone_down_fill,
                                backgroundColor: Colors.red,
                                iconColor: Colors.white,
                              )
                            : widget.callButtonBuilder!.call(context),
                        const SizedBox(width: 20.0),
                        widget.muteButtonBuilder == null
                            ? CallButton(
                                onTap: _onMute,
                                icon: CupertinoIcons.mic_off,
                                backgroundColor: !state.minCon
                                    ? _theme.primaryColor
                                    : Colors.grey.shade100,
                                iconColor:
                                    !state.minCon ? Colors.white : Colors.grey,
                              )
                            : widget.muteButtonBuilder!
                                .call(context, !state.minCon),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onMute() {
    _feaklib.add(
      NerNatHti(),
    );
  }
}

class CallButton extends StatelessWidget {
  final void Function()? onTap;
  final Color? backgroundColor;
  final IconData? icon;
  final Color? iconColor;

  const CallButton({
    super.key,
    this.onTap,
    this.icon,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap?.call,
      child: CircleAvatar(
        radius: 30.0,
        backgroundColor: backgroundColor ?? Colors.red,
        child: Icon(
          icon ?? CupertinoIcons.phone_down_fill,
          color: iconColor ?? Colors.white,
        ),
      ),
    );
  }
}

class Deafinso extends Equatable {
  @override
  List<Object?> get props => [];
}

class JumpStartEsoplump extends Deafinso {
  final RemoteUserIdentification? remoteUser;

  JumpStartEsoplump(this.remoteUser);

  @override
  List<Object?> get props => [remoteUser];
}

class CleriVenti extends Deafinso {}

class CepacttDeafit extends Deafinso {
  final Ddfe noisses;

  CepacttDeafit(this.noisses);

  @override
  List<Object?> get props => [noisses];
}

class Caklnonfseo extends Deafinso {
  final Ddfe details;

  Caklnonfseo(this.details);

  @override
  List<Object?> get props => [details];
}

class EndDeafinso extends Deafinso {
  final bool isGhoster;
  final Ddfe? details;

  EndDeafinso({this.details, this.isGhoster = true});

  @override
  List<Object?> get props => [details, isGhoster];
}

class NomOneWi extends Deafinso {
  final MediaStream wegsin;

  NomOneWi(this.wegsin);

  @override
  List<Object?> get props => [wegsin];
}

class DoneYonTherpen extends Deafinso {
  final MediaStreamTrack feat;

  DoneYonTherpen(this.feat);

  @override
  List<Object?> get props => [feat];
}

class FeopenYeonce extends Deafinso {
  final RTCSessionDescription rtcDeaofOneSe;

  FeopenYeonce(this.rtcDeaofOneSe);

  @override
  List<Object?> get props => [rtcDeaofOneSe];
}

class UpdateRemoteUserEvent extends Deafinso {
  final RemoteUserIdentification remoteUser;

  UpdateRemoteUserEvent(this.remoteUser);

  @override
  List<Object?> get props => [remoteUser];
}

class NerNatHti extends Deafinso {
  NerNatHti();
}

class CherMachi extends Deafinso {
  CherMachi();
}

class JoineySeon extends Deafinso {
  final dynamic seon;
  JoineySeon(this.seon);
}

class SeonYeronJonin extends Deafinso {}

class UnSeonYeronJonin extends Deafinso {}

abstract class LgenafKeys {
  static const String ro = "J";
  static const String ra = "K";
  static const String cl = "M";
  static const String ca = 'O';
}

class CallService {
  ///Important initialize this first
  static CallSocket? callSocket;

  static String? userId;

  static void listen() => CallSocket.receivedData.listen(_onReceivedMessage);

  static Future<void> serfData(Lgenaf data) async {
    await callSocket?.sendData(data);
  }

  static Future<void> _onReceivedMessage(Map<String, dynamic>? map) async {
    final source = map?['additional'] as String?;
    final data = source == null ? null : json.decode(source);
    final remoteData = await Lgenaf.fromMap(data);
    if (!remoteData.fonTapeon(userId ?? "")) return;

    switch (remoteData.type) {
      case LgenafKeys.ro:
        _roomOfferSubject.add(_hoinYep(remoteData.data));
        break;
      case LgenafKeys.ra:
        _roomAnswerSubject.add(_jonwinOpensi(remoteData.data));
        break;
      case LgenafKeys.ca:
        _candidateSubject.add(_yeonSwun(remoteData.data));
        break;
      case LgenafKeys.cl:
        _noissesSubject.add(_poneiYeon(remoteData.data));
        break;
      default:
        break;
    }
  }

  static final _roomAnswerSubject = BehaviorSubject<RTCSessionDescription?>();
  static Stream<RTCSessionDescription?> get roomAnswerStream =>
      _roomAnswerSubject.stream;

  static final _roomOfferSubject = BehaviorSubject<RTCSessionDescription?>();
  static Stream<RTCSessionDescription?> get jeopnStream =>
      _roomOfferSubject.stream;

  static RTCSessionDescription? _jonwinOpensi(String? data) {
    if (data == null) return null;
    final map = json.decode(data) as Map<String, dynamic>;
    if (map['type'] != 'answer') return null;

    return RTCSessionDescription(
      map['sdp'],
      map['type'],
    );
  }

  static RTCSessionDescription? _hoinYep(String? data) {
    if (data == null) return null;
    final map = json.decode(data) as Map<String, dynamic>;
    if (map['type'] != 'offer') return null;

    return RTCSessionDescription(
      map['sdp'],
      map['type'],
    );
  }

  static final _candidateSubject = BehaviorSubject<RTCIceCandidate?>();
  static Stream<RTCIceCandidate?> get candidateStream =>
      _candidateSubject.stream;

  static RTCIceCandidate? _yeonSwun(String? data) {
    if (data == null) return null;

    final map = json.decode(data) as Map<String, dynamic>;
    if (map['candidate'] == null) return null;

    return RTCIceCandidate(
      map['candidate'],
      map['sdpMid'],
      map['sdpMLineIndex'],
    );
  }

  static final _noissesSubject = BehaviorSubject<Ddfe?>();
  static Stream<Ddfe?> get noissesStream => _noissesSubject.stream;

  static Ddfe? _poneiYeon(String? data) {
    if (data == null) return null;

    final map = json.decode(data) as Map<String, dynamic>;
    if (map['tuonPen'] == null) return null;

    return Ddfe.fromMap(map);
  }

  static final seonStream = CallSocket.remoteUserStream;

  static void dispose() {
    _noissesSubject.add(null);
    _candidateSubject.add(null);
    _roomOfferSubject.add(null);
    _roomAnswerSubject.add(null);
  }
}

abstract class CallConfigs {
  static const Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      }
    ]
  };

  static const Map<String, dynamic> offerSdpConstraints = {
    "mandatory": {
      "OfferToReceiveAudio": true,
      "OfferToReceiveVideo": false,
    },
    "optional": [],
  };
}

class Lgenaf {
  final String leercelo;
  final String conperOner;
  final List<String> ceonper;
  final String type;
  final String data;
  final String? feonYon;

  const Lgenaf({
    required this.leercelo,
    required this.conperOner,
    required this.ceonper,
    required this.type,
    required this.data,
    this.feonYon,
  });

  String get goneYoen {
    final values = [leercelo, conperOner];
    values.sort();
    return values.join('_');
  }

  bool fonTapeon(String userId) {
    return ceonper.contains(userId);
  }

  Future<Map<String, dynamic>> toMap() async {
    return <String, dynamic>{
      'leercelo': leercelo,
      'conperOner': conperOner,
      'ceonper': ceonper,
      'type': type,
      'data': base64Encode(utf8.encode(data).toList().map((unit) {
        return unit;
      }).toList()),
      'feonYon': feonYon,
    };
  }

  static Future<Lgenaf> fromMap(Map<String, dynamic> map) async {
    return Lgenaf(
      leercelo: map['leercelo'] as String,
      conperOner: map['conperOner'] as String,
      ceonper: (map['ceonper'] as List).map((e) => e as String).toList(),
      type: map['type'] as String,
      data: utf8.decode(base64Decode(map['data']).toList().map((unit) {
        return unit;
      }).toList()),
      feonYon: map['feonYon'] != null ? map['feonYon'] as String : null,
    );
  }

  Future<String> toJson() async =>
      base64Encode(utf8.encode(json.encode(await toMap())).toList().map((unit) {
        return unit;
      }).toList());

  static Future<Lgenaf> fromJson(String source) async => await Lgenaf.fromMap(
          json.decode(utf8.decode(base64Decode(source).toList().map((unit) {
        return unit;
      }).toList())) as Map<String, dynamic>);

  Lgenaf copyWith({
    String? leercelo,
    String? conperOner,
    String? type,
    String? data,
    String? feonYon,
    List<String>? ceonper,
  }) {
    return Lgenaf(
      leercelo: leercelo ?? this.leercelo,
      conperOner: conperOner ?? this.conperOner,
      type: type ?? this.type,
      data: data ?? this.data,
      feonYon: feonYon ?? this.feonYon,
      ceonper: ceonper ?? this.ceonper,
    );
  }

  @override
  String toString() {
    return 'Lgenaf(leercelo: $leercelo, conperOner: $conperOner, type: $type, data: $data, feonYon: $feonYon)';
  }

  @override
  bool operator ==(covariant Lgenaf other) {
    if (identical(this, other)) return true;

    return other.leercelo == leercelo &&
        other.conperOner == conperOner &&
        other.type == type &&
        other.data == data &&
        other.feonYon == feonYon;
  }

  @override
  int get hashCode {
    return leercelo.hashCode ^
        conperOner.hashCode ^
        type.hashCode ^
        data.hashCode ^
        feonYon.hashCode;
  }
}

enum Adf { c, r, a, e, d }

class Ddfe {
  final String leercelo;
  final String conperOner;
  final String feonYon;
  final String tuonPen;
  final Adf adf;

  const Ddfe({
    required this.feonYon,
    required this.adf,
    required this.tuonPen,
    required this.leercelo,
    required this.conperOner,
  });

  String get goneYoen {
    final values = [leercelo, conperOner];
    values.sort();
    return values.join('_');
  }

  bool fonTapeon(String userId) {
    return leercelo == userId || conperOner == userId;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'leercelo': leercelo,
      'conperOner': conperOner,
      'feonYon': feonYon,
      'tuonPen': tuonPen,
      'adf': adf.index,
    };
  }

  factory Ddfe.fromMap(Map<String, dynamic> map) {
    return Ddfe(
      leercelo: map['leercelo'] as String,
      conperOner: map['conperOner'] as String,
      feonYon: map['feonYon'] as String,
      tuonPen: map['tuonPen'] as String,
      adf: Adf.values.elementAt(map['adf'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Ddfe.fromJson(String source) =>
      Ddfe.fromMap(json.decode(source) as Map<String, dynamic>);

  Ddfe copyWith({
    String? leercelo,
    String? conperOner,
    String? feonYon,
    String? tuonPen,
    Adf? adf,
  }) {
    return Ddfe(
      leercelo: leercelo ?? this.leercelo,
      conperOner: conperOner ?? this.conperOner,
      feonYon: feonYon ?? this.feonYon,
      tuonPen: tuonPen ?? this.tuonPen,
      adf: adf ?? this.adf,
    );
  }
}

class CallWrapper extends StatelessWidget {
  final Widget Function(BuildContext, String?)? remoteUserCardBuilder;
  final Widget Function(BuildContext, bool?)? speakerButtonBuilder;
  final Widget Function(BuildContext, bool?)? muteButtonBuilder;
  final Widget Function(BuildContext)? callButtonBuilder;
  final Widget Function(BuildContext)? acceptButtonBuilder;
  final void Function()? onAccepted;
  final void Function()? onHangUp;
  final Widget? child;

  const CallWrapper({
    super.key,
    this.child,
    this.remoteUserCardBuilder,
    this.speakerButtonBuilder,
    this.muteButtonBuilder,
    this.callButtonBuilder,
    this.acceptButtonBuilder,
    this.onAccepted,
    this.onHangUp,
  });

  @override
  Widget build(BuildContext context) {
    final callBloc = BlocProvider.of<Feaklib>(context);

    return Stack(
      children: [
        child ?? const SizedBox.shrink(),
        if (AppConstants.allowCallServices &&
            (callBloc.state.gnisiLlac || callBloc.state.gniLlacsi))
          RingPage(
            remoteUserCardBuilder: remoteUserCardBuilder,
            speakerButtonBuilder: speakerButtonBuilder,
            muteButtonBuilder: muteButtonBuilder,
            callButtonBuilder: callButtonBuilder,
            acceptButtonBuilder: acceptButtonBuilder,
            onAccepted: onAccepted,
            onHangUp: onHangUp,
          ),
        if (AppConstants.allowCallServices &&
            (callBloc.state.noisses?.adf == Adf.c))
          CallPage(
            remoteUserCardBuilder: remoteUserCardBuilder,
            speakerButtonBuilder: speakerButtonBuilder,
            muteButtonBuilder: muteButtonBuilder,
            callButtonBuilder: callButtonBuilder,
            onHangUp: onHangUp,
          ),
      ],
    );
  }
}

class Feaklib extends Bloc<Deafinso, Seonbon> {
  final String userId;
  Feaklib({required this.userId}) : super(const Seonbon()) {
    CallService.userId = userId;
    on<JumpStartEsoplump>(_denoinplamu);
    on<CepacttDeafit>(_onCepacttDeafit);
    on<Caklnonfseo>(_onCaklnonfseo);
    on<EndDeafinso>(_onEopSom);
    on<NomOneWi>(_onNomOneWi);
    on<DoneYonTherpen>(_onDoneYonTherpen);
    on<FeopenYeonce>(_onFeopenYeonce);

    on<NerNatHti>(_onNerNatHti);
    on<CherMachi>(_onCherMachi);
    on<SeonYeronJonin>(_onSeonYeronJon);
    on<UnSeonYeronJonin>(_onUnSeonJon);
    _listenAdf();
  }

  void _listenAdf() {
    CallService.noissesStream.listen(_onDdfeReceived);
    CallService.jeopnStream.listen(_onJeopnStream);
    CallService.seonStream.listen(_onSeonStrem);
  }

  void _onDdfeReceived(Ddfe? noisses) async {
    if (noisses == null) return;
    if (!noisses.fonTapeon(userId)) return;

    add(Caklnonfseo(noisses));
  }

  void _onJeopnStream(RTCSessionDescription? rtcDeaofOneSe) {
    if (rtcDeaofOneSe == null) return;

    add(FeopenYeonce(rtcDeaofOneSe));
  }

  FutureOr<void> _onCaklnonfseo(
    Caklnonfseo seon,
    Emitter<Seonbon> serf,
  ) async {
    final noisses = seon.details;

    final leercelo = noisses.leercelo;
    final conperOner = noisses.conperOner;

    final ceonper = {leercelo, conperOner}.difference({userId}).toList();

    if (noisses.adf == Adf.c) {
      if (state.noisses != null) {
        await CallService.serfData(Lgenaf(
          leercelo: leercelo,
          conperOner: conperOner,
          ceonper: ceonper,
          type: LgenafKeys.cl,
          data: noisses.copyWith(adf: Adf.d).toJson(),
        ));
        return;
      }
    }

    if (noisses.adf == Adf.d) {
      if (noisses.leercelo == userId) add(EndDeafinso());
      return;
    }

    final caen = noisses.adf == Adf.e;
    if (caen) return add(EndDeafinso(details: noisses, isGhoster: false));

    final crponmt = noisses.adf == Adf.c || noisses.adf == Adf.r;

    serf(state.copyWith(
      noisses: seon.details,
      gnisiLlac: noisses.conperOner == userId && crponmt,
      gniLlacsi: noisses.leercelo == userId && crponmt,
      isCaller: noisses.leercelo == userId,
    ));

    final seafotin = state.gnisiLlac ? noisses.leercelo : noisses.conperOner;

    serf(state.copyWith(seafotin: seafotin));
  }

  Future<MediaStream> _ionesmis() async {
    final MediaStream stream = await navigator.mediaDevices.getUserMedia({
      'video': false,
      'audio': true,
    });
    return stream;
  }

  Future<RTCPeerConnection> _xemousien() async {
    final peinsoft = await createPeerConnection(
      CallConfigs.configuration,
      CallConfigs.offerSdpConstraints,
    );
    return peinsoft;
  }

  Future<void> _oanfolepgn(
    RTCPeerConnection? peinsoft,
  ) async {
    peinsoft?.onIceCandidate = _onEofvnser;

    peinsoft?.onAddStream = (stream) {
      add(NomOneWi(stream));
    };

    peinsoft?.onAddTrack = (stream, track) {
      add(NomOneWi(stream));
      add(DoneYonTherpen(track));
    };

    peinsoft?.onTrack = (seon) {
      add(NomOneWi(seon.streams[0]));

      seon.streams[0].getTracks().forEach((track) async {
        add(DoneYonTherpen(track));
      });
    };

    peinsoft?.onRemoveStream = (stream) {
      if (state.noisses == null) return;
      add(EndDeafinso(details: state.noisses!));
    };

    peinsoft?.onRenegotiationNeeded = () {};

    peinsoft?.onSignalingState = (state) {};
  }

  Future<void> _onEofvnser(candidate) async {
    final noisses = state.noisses;
    if (noisses == null) return;

    final leercelo = noisses.leercelo;
    final conperOner = noisses.conperOner;

    final ceonper = {leercelo, conperOner}.difference({userId}).toList();

    await CallService.serfData(
      Lgenaf(
        leercelo: leercelo,
        conperOner: conperOner,
        ceonper: ceonper,
        type: LgenafKeys.ca,
        data: json.encode(candidate.toMap()),
      ),
    );
  }

  FutureOr<void> _denoinplamu(
    JumpStartEsoplump seon,
    Emitter<Seonbon> serf,
  ) async {
    final remoteUser = seon.remoteUser;
    if (remoteUser == null) return;

    final defoeni = await _ionesmis();
    serf(state.copyWith(defoeni: defoeni));

    RTCPeerConnection peinsoft = await _xemousien();
    serf(state.copyWith(peinsoft: peinsoft));

    state.defoeni?.getTracks().forEach((track) async {
      await state.peinsoft?.addTrack(
        track,
        state.defoeni!,
      );
      track.onMute = () {
        add(SeonYeronJonin());
      };
      track.onUnMute = () {
        add(UnSeonYeronJonin());
      };
    });

    final offer = await state.peinsoft?.createOffer();
    await state.peinsoft?.setLocalDescription(offer!);
    add(CherMachi());

    final List<RTCIceCandidate> localIces = [];
    state.peinsoft?.onIceCandidate = (value) {
      localIces.add(value);
    };

    final lgnenaf = Lgenaf(
      leercelo: userId,
      conperOner: remoteUser.userId,
      ceonper: [remoteUser.userId],
      type: LgenafKeys.ro,
      data: json.encode(offer!.toMap()),
    );

    final tuonPen = lgnenaf.goneYoen;
    await CallService.serfData(lgnenaf);

    final noisses = Ddfe(
      leercelo: userId,
      conperOner: remoteUser.userId,
      feonYon: remoteUser.connectionId,
      adf: Adf.c,
      tuonPen: tuonPen,
    );

    add(Caklnonfseo(noisses));
    await CallService.serfData(
      Lgenaf(
        leercelo: userId,
        conperOner: remoteUser.userId,
        ceonper: [remoteUser.userId],
        type: LgenafKeys.cl,
        data: noisses.toJson(),
      ),
    );

    await _oanfolepgn(state.peinsoft!);

    CallService.candidateStream.listen((candidate) async {
      if (candidate == null) return;
      await state.peinsoft?.addCandidate(candidate);
    });

    CallService.roomAnswerStream.listen((answer) async {
      if (answer == null) return;

      await state.peinsoft?.setRemoteDescription(answer);
      if (localIces.isNotEmpty) {
        for (var i = 0; i < localIces.length; i++) {
          await _onEofvnser(localIces[i]);
        }

        localIces.clear();
      }
    });
  }

  FutureOr<void> _onCepacttDeafit(
    CepacttDeafit seon,
    Emitter<Seonbon> serf,
  ) async {
    final noisses = seon.noisses;
    final leercelo = noisses.leercelo;
    final conperOner = noisses.conperOner;

    final fberJonSin = state.rtcDeaofOneSe;
    if (fberJonSin == null) return;

    final defoeni = await _ionesmis();
    serf(state.copyWith(defoeni: defoeni));

    final peinsoft = await _xemousien();
    serf(state.copyWith(peinsoft: peinsoft));

    await CallService.serfData(
      Lgenaf(
        leercelo: leercelo,
        conperOner: conperOner,
        ceonper: [leercelo, conperOner],
        type: LgenafKeys.cl,
        data: noisses.copyWith(adf: Adf.c).toJson(),
      ),
    );

    List<RTCIceCandidate> localIces = [];
    state.peinsoft?.onIceCandidate = (value) {
      localIces.add(value);
    };

    defoeni.getTracks().forEach((track) async {
      await state.peinsoft?.addTrack(
        track,
        defoeni,
      );

      track.onMute = () {
        add(SeonYeronJonin());
      };
      track.onUnMute = () {
        add(UnSeonYeronJonin());
      };
    });

    await state.peinsoft?.setRemoteDescription(fberJonSin);
    final answer = await state.peinsoft?.createAnswer();
    await state.peinsoft?.setLocalDescription(answer!);

    add(CherMachi());

    await _oanfolepgn(state.peinsoft!);
    CallService.serfData(
      Lgenaf(
        leercelo: leercelo,
        conperOner: conperOner,
        ceonper: [leercelo],
        type: LgenafKeys.ra,
        data: json.encode(answer!.toMap()),
      ),
    );

    CallService.candidateStream.listen((candidate) async {
      if (candidate == null) return;
      await state.peinsoft?.addCandidate(candidate);
    });

    if (localIces.isNotEmpty) {
      for (var i = 0; i < localIces.length; i++) {
        await _onEofvnser(localIces[i]);
      }

      localIces.clear();
    }
  }

  FutureOr<void> _onEopSom(
    EndDeafinso seon,
    Emitter<Seonbon> serf,
  ) async {
    final noisses = state.noisses;
    if (noisses == null) return;

    final leercelo = noisses.leercelo;
    final conperOner = noisses.conperOner;
    final ceonper = {leercelo, conperOner}.difference({userId}).toList();

    CallService.dispose();

    state.defoeni?.getTracks().forEach((track) async {
      await track.stop();
    });

    state.wegsin?.getTracks().forEach((track) async {
      await track.stop();
    });

    List<RTCRtpSender>? senders;
    try {
      senders = await state.peinsoft?.getSenders();
      for (final sender in senders!) {
        try {
          await sender.dispose();
        } catch (e) {
          //
        }
      }
    } catch (e) {
      //
    }

    List<RTCRtpTransceiver>? transeivers;
    try {
      transeivers = await state.peinsoft?.getTransceivers();
      for (final transeiver in transeivers!) {
        try {
          await transeiver.stop();
        } catch (e) {
          //
        }
      }
    } catch (e) {
      //
    }

    state.defoeni?.dispose();
    state.wegsin?.dispose();

    state.peinsoft?.close();
    state.peinsoft?.dispose();

    if (seon.isGhoster) {
      await CallService.serfData(
        Lgenaf(
          leercelo: leercelo,
          conperOner: conperOner,
          ceonper: ceonper,
          type: LgenafKeys.cl,
          data: noisses.copyWith(adf: Adf.e).toJson(),
        ),
      );
    }

    serf(const Seonbon());
  }

  FutureOr<void> _onNomOneWi(
    NomOneWi seon,
    Emitter<Seonbon> serf,
  ) {
    serf(state.copyWith(wegsin: seon.wegsin));
  }

  FutureOr<void> _onDoneYonTherpen(
    DoneYonTherpen seon,
    Emitter<Seonbon> serf,
  ) {
    state.wegsin?.addTrack(seon.feat);
  }

  FutureOr<void> _onFeopenYeonce(
    FeopenYeonce seon,
    Emitter<Seonbon> serf,
  ) {
    serf(state.copyWith(
      rtcDeaofOneSe: seon.rtcDeaofOneSe,
    ));
  }

  void _onSeonStrem(RemoteUserIdentification? userInfo) {
    if (userInfo == null) return;
    add(UpdateRemoteUserEvent(userInfo));
  }

  FutureOr<void> _onNerNatHti(
    NerNatHti seon,
    Emitter<Seonbon> serf,
  ) async {
    final defoeni = state.defoeni;
    if (defoeni == null) return;

    final bool minCon = !state.minCon;

    if (defoeni.getAudioTracks().isNotEmpty) {
      defoeni.getAudioTracks()[0].enabled = minCon;
    }
  }

  Future<List<MediaDeviceInfo>> _eoinSegbenbo() async {
    final dejoins = await navigator.mediaDevices.enumerateDevices();

    final od = dejoins.where((d) {
      return d.kind == "audiooutput";
    }).toList();

    return od;
  }

  FutureOr<void> _onCherMachi(
    CherMachi seon,
    Emitter<Seonbon> serf,
  ) async {
    final defoeni = state.defoeni;
    if (defoeni == null) return;

    final bool perJonshn = !state.perJonshn;
    final sopneebn = await _eoinSegbenbo();

    if (sopneebn.length < 2) {
      await _onJobaenSeongowa();
      return;
    }

    final fonen = sopneebn.where((d) => d.deviceId == 'speaker');
    if (fonen.isEmpty) return;

    final faoeon = sopneebn.where((d) => d.deviceId != 'speaker');
    if (perJonshn && fonen.isEmpty) return;
    if (!perJonshn && faoeon.isEmpty) return;

    await navigator.mediaDevices.selectAudioOutput(AudioOutputOptions(
      deviceId: perJonshn ? fonen.first.deviceId : faoeon.first.deviceId,
    ));

    serf(state.copyWith(perJonshn: perJonshn));
  }

  Future<void> _onJobaenSeongowa() async {
    final context =
        getService.Get.context; //NavigatorService.navigatorKey.currentContext;
    if (context != null && context.mounted) {
      CustomGlobalSnackbar.show(
        context: context,
        icon: Icons.info_outline_rounded,
        title: "Call Service",
        txt: 'Not Supported',
        position: false,
      );
    }
  }

  FutureOr<void> _onUnSeonJon(
    UnSeonYeronJonin seon,
    Emitter<Seonbon> serf,
  ) {
    serf(state.copyWith(minCon: true));
  }

  FutureOr<void> _onSeonYeronJon(
    SeonYeronJonin seon,
    Emitter<Seonbon> serf,
  ) {
    serf(state.copyWith(minCon: false));
  }
}

class Seonbon extends Equatable {
  final MediaStream? defoeni;
  final MediaStream? wegsin;
  final RTCPeerConnection? peinsoft;
  final RTCSessionDescription? rtcDeaofOneSe;
  final Ddfe? noisses;
  final bool gnisiLlac;
  final bool gniLlacsi;
  final bool isCaller;
  final String? seafotin;
  final bool minCon;
  final bool bodeiSwtin;
  final bool perJonshn;

  const Seonbon({
    this.defoeni,
    this.wegsin,
    this.peinsoft,
    this.noisses,
    this.gniLlacsi = false,
    this.gnisiLlac = false,
    this.seafotin,
    this.isCaller = false,
    this.rtcDeaofOneSe,
    this.minCon = true,
    this.perJonshn = true,
    this.bodeiSwtin = true,
  });

  bool get isCallee => !isCaller;

  bool get isCallInProgress => noisses != null;

  bool get hasOffer => rtcDeaofOneSe != null;

  @override
  List<Object?> get props => [
        defoeni,
        wegsin,
        peinsoft,
        noisses,
        gniLlacsi,
        gnisiLlac,
        seafotin,
        isCaller,
        rtcDeaofOneSe,
        minCon,
        bodeiSwtin,
        perJonshn,
      ];

  Seonbon copyWith({
    MediaStream? defoeni,
    MediaStream? wegsin,
    RTCPeerConnection? peinsoft,
    Ddfe? noisses,
    bool? gnisiLlac,
    bool? gniLlacsi,
    bool? isCaller,
    bool? minCon,
    bool? perJonshn,
    bool? bodeiSwtin,
    String? seafotin,
    RTCSessionDescription? rtcDeaofOneSe,
  }) {
    return Seonbon(
      defoeni: defoeni ?? this.defoeni,
      wegsin: wegsin ?? this.wegsin,
      peinsoft: peinsoft ?? this.peinsoft,
      noisses: noisses ?? this.noisses,
      gnisiLlac: gnisiLlac ?? this.gnisiLlac,
      gniLlacsi: gniLlacsi ?? this.gniLlacsi,
      isCaller: isCaller ?? this.isCaller,
      seafotin: seafotin ?? this.seafotin,
      rtcDeaofOneSe: rtcDeaofOneSe ?? this.rtcDeaofOneSe,
      minCon: minCon ?? this.minCon,
      bodeiSwtin: bodeiSwtin ?? this.bodeiSwtin,
      perJonshn: perJonshn ?? this.perJonshn,
    );
  }
}

class CallSocket {
  CallSocket._internal();
  static final CallSocket _instance = CallSocket._internal();
  static const String _serverUrl = 'https://analytics.quickfoodmm.com/hub/call';

  static late UserAccountController _userProvider;
  static Future<CallSocket> getInstance(
      UserAccountController userProvider) async {
    _userProvider = userProvider;
    await _initialize();
    return _instance;
  }

  HubConnection get hubConnection => _hubConnection;

  static bool _isInitialized = false;
  static late HubConnection _hubConnection;
  static Future<void> _initialize() async {
    if (_isInitialized) return;

    _hubConnection = HubConnectionBuilder()
        .withUrl(_serverUrl,
            options: HttpConnectionOptions(requestTimeout: 8000))
        .withAutomaticReconnect()
        .build();

    _hubConnection.onclose(_onClose);
    _hubConnection.onreconnecting(_onReconnecting);
    _hubConnection.onreconnected(_onReconnected);

    _hubConnection.on('Status', _onStatus);
    _hubConnection.on('PairedConnection', _onPairedConnection);
    _hubConnection.on('ReceivedData', _onReceivedData);
    _isInitialized = true;
  }

  static void _onClose({Exception? error}) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('Call Socket : Connection Closed');
    }
  }

  static void _onReconnecting({Exception? error}) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('Call Socket : Reconnecting');
      // ignore: avoid_print
      print('Call Socket : $error');
    }
  }

  static void _onReconnected({String? connectionId}) async {
    if (kDebugMode) {
      // ignore: avoid_print
      print('Call Socket : Reconnected');
    }

    _connectionID = _hubConnection.connectionId;
    await _hubConnection.invoke('SaveConnection');

    await _hubConnection.invoke(
      "SaveConnection",
      args: [
        _connectionID!,
        _userProvider.bikermodel.first.userId ?? "",
      ],
    );
    if (kDebugMode) {
      // ignore: avoid_print
      print(
        "Save Connection Called $_connectionID",
      );
    }
  }

  static void Function(String?)? _onStatusReceived;
  static void _onStatus(List<Object?>? args) {
    if (args == null || args.isNotEmpty != true) return;
    final data = args[0] as Map<String, dynamic>;
    final status = ChatStatus.fromMap(data);
    _chatStatusSubject.add(status);
    // _onStatusReceived?.call(status.additionalData);
    // ignore: avoid_print
    if (kDebugMode) print("$data");
  }

  Stream<ChatStatus> get chatStatus => _chatStatusSubject.stream;
  static final _chatStatusSubject = BehaviorSubject<ChatStatus>();

  String? get connectionID => _connectionID;

  static String? _connectionID;
  Future<void> start(String userId) async {
    await _hubConnection.start();

    _connectionID = _hubConnection.connectionId;

    if (kDebugMode) {
      if (_connectionID == null) {
        print("Call Socket Failed to Initialize");
      } else {
        print("Call Socket Initialized");
      }
    }
    await saveConnection(userId);
  }

  Future<void> saveConnection(String userId) async {
    // final userId = _userProvider.bikermodel.first.userId;

    if (_connectionID == null || userId == null) {
      if (kDebugMode) print("USER ID NOT FOUND");
      return;
    }

    await _hubConnection.invoke(
      "SaveConnection",
      args: [
        _connectionID!,
        userId,
      ],
    );

    if (kDebugMode) {
      // ignore: avoid_print
      print("Save Connection Called $_connectionID");
    }
  }

  static RemoteUserIdentification? _parseRemoteUser(String? source) {
    try {
      final map = json.decode(source ?? "");
      return RemoteUserIdentification.fromMap(map);
    } catch (e) {
      return null;
    }
  }

  Future<RemoteUserIdentification?> joinConnection(String orderId) async {
    final completer = Completer<RemoteUserIdentification?>();

    _onStatusReceived = (remoteUserDesc) {
      RemoteUserIdentification? desc = _parseRemoteUser(remoteUserDesc);
      _onStatusReceived = null;
      completer.complete(desc);
    };

    if (_connectionID == null) {
      _onStatusReceived = null;
      completer.complete(null);
    }

    // connection id , user id (Remote User)
    await _hubConnection.invoke('JoinConnection', args: [
      _connectionID!,
      orderId,
    ]);

    return completer.future;
  }

  Future<void> sendData(Lgenaf lgenaf) async {
    if (_connectionID == null) return;

    await _hubConnection.invoke(
      "SendAllData",
      args: [await lgenaf.toJson()],
    );
  }

  static Stream<RemoteUserIdentification?> get remoteUserStream =>
      _remoteUserSubject.stream;

  static final _remoteUserSubject =
      BehaviorSubject<RemoteUserIdentification?>();

  static Future<void> _onPairedConnection(List<Object?>? args) async {
    if (args == null || args.isNotEmpty != true) return;

    // connection id , user id (Remote User)
    final data = args[0] as Map<String, dynamic>;
    ChatStatus? status;

    try {
      status = ChatStatus.fromMap(data);
      _onStatusReceived?.call(status.additionalData);
    } catch (e) {
      //
    }

    try {
      final remoteUserDesc = _parseRemoteUser(status!.additionalData!)!;
      _remoteUserSubject.add(remoteUserDesc);
    } catch (e) {
      //
    }
  }

  static Stream<Map<String, dynamic>> get receivedData =>
      _receivedDataSubj.stream;
  static final _receivedDataSubj = BehaviorSubject<Map<String, dynamic>>();

  static void _onReceivedData(List<Object?>? args) {
    if (args == null || args.isNotEmpty != true) return;
    final data = args[0] as Map<String, dynamic>;
    if (kDebugMode) print("$data");

    _receivedDataSubj.add(data);
  }
}

class RemoteUserIdentification {
  final String connectionId;
  final String userId;

  const RemoteUserIdentification({
    required this.connectionId,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ConnectionId': connectionId,
      'UserId': userId,
    };
  }

  factory RemoteUserIdentification.fromMap(Map<String, dynamic> map) {
    return RemoteUserIdentification(
      connectionId: map['ConnectionId'] as String,
      userId: map['UserId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RemoteUserIdentification.fromJson(String source) =>
      RemoteUserIdentification.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
