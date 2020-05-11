import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/dialogflow/v2.dart';

import 'package:app_dialog/providers/speech_provider.dart';

class DialogProvider {
  static DialogProvider _instance = DialogProvider();
  static DialogProvider get instance => _instance;

  final _scopes = [
    DialogflowApi.CloudPlatformScope,
    DialogflowApi.DialogflowScope
  ];

  final _dialogController =
      StreamController<GoogleCloudDialogflowV2QueryResult>.broadcast();

  Stream<GoogleCloudDialogflowV2QueryResult> get dialogStream =>
      _dialogController.stream;

  DialogflowApi _api;
  String _projectID, _sessionID;
  AutoRefreshingAuthClient _client;

  init() {
    rootBundle.loadString('assets/credentials.json').then((string) {
      var json = jsonDecode(string);
      _sessionID = json["client_id"];
      _projectID = json["project_id"];
      clientViaServiceAccount(ServiceAccountCredentials.fromJson(json), _scopes)
          .then((client) => _api = DialogflowApi(_client = client))
          .catchError((e) => print('AN ERROR HAS OCURRED WHILE SIGNING IN'));
    });
  }

  makeQuery(String query) {
    var req = GoogleCloudDialogflowV2DetectIntentRequest.fromJson({
      "queryInput": {
        "text": {"text": query, "languageCode": "ES"}
      }
    });

    _api.projects.agent.sessions
        .detectIntent(req, "projects/$_projectID/agent/sessions/$_sessionID")
        .then((res) => _processResult(res.queryResult))
        .catchError((e) => print(e.toString()));
  }

  _processResult(GoogleCloudDialogflowV2QueryResult res) {
    VoiceReader.instance.speak(res.fulfillmentText);
    if (res.action == 'promo') {
      _dialogController.sink.add(res);
    }
    if (res.action == 'list') {
      _dialogController.sink.add(res);
    }
  }

  dispose() {
    _client?.close();
    _dialogController?.close();
  }
}
