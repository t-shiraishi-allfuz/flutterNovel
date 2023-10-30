import 'package:flutter_novel/models/member.dart';
import 'package:flutter_novel/models/message.dart';
import 'package:flutter_novel/models/user_play_data.dart';
import 'package:flutter_novel/utils/googleapi_settings.dart';

// ゲームデータ管理
// ignore: non_constant_identifier_names
class GameLogic {
  final String uid;
  final UserPlayDataModel userPlayData;
  final List<MessageModel> messageList;

  GameLogic({
    required this.uid,
    required this.userPlayData,
    required this.messageList,
  });

  @override
  String toString() {
    return 'UserModel('
        'uid: $uid,'
        'userPlayData: $userPlayData,'
        'messageList: $messageList,'
        ')';
  }

  static Future<GameLogic> getData(String uid) async {
    final userPlayData = await UserPlayDataModel.getUserPlayDataByUid(uid);

    // メンバーデータ取得
    String range1 = "chara!A:B";
    final memberData =
        await GoogleApiSettings.createGoogleSheetsApiGetUrl(range1);

    final List<MemberModel> memberList = [];

    for (final member in memberData) {
      final addMember = getMemberData(member);
      memberList.add(addMember);
    }

    // 進行中のシナリオデータ取得
    String range2 = "scene${userPlayData.scene}!A2:G";
    final messageData =
        await GoogleApiSettings.createGoogleSheetsApiGetUrl(range2);

    final List<MessageModel> messageList = [];

    for (final message in messageData) {
      final addMessage = getMessageData(message, memberList, userPlayData);
      messageList.add(addMessage);
    }

    return GameLogic(
      uid: uid,
      userPlayData: userPlayData,
      messageList: messageList,
    );
  }

  // メンバーデータを加工
  static MemberModel getMemberData(dynamic member) {
    String name = member[0] as String;
    String memberId = member[1] as String;

    return MemberModel(
      name: name,
      memberId: memberId,
    );
  }

  // メッセージデータを加工
  static MessageModel getMessageData(dynamic message,
      List<MemberModel> memberList, UserPlayDataModel userPlayData) {
    String memberId = message[0] as String;
    int memberIndex = int.parse(memberId);
    String memberName = memberIndex != 0
        ? memberList[memberIndex - 1].name
        : userPlayData.nickname != ""
            ? userPlayData.nickname
            : "？？？？";
    String body = message[1] as String;
    body = body.replaceAll("{nickname}", userPlayData.nickname);
    String? charaImage = message[2].isNotEmpty ? message[2] as String : null;
    String bg = message[3] as String;
    dynamic effect = message.length >= 5 ? message[4] : null;
    dynamic function = message.length >= 6 ? message[5] : null;
    int? nextScene = message.length >= 7 ? int.parse(message[6]) : null;

    return MessageModel(
      memberId: memberId,
      name: memberName,
      body: body,
      charaImage: charaImage,
      bg: bg,
      effect: effect,
      function: function,
      nextScene: nextScene,
    );
  }
}
