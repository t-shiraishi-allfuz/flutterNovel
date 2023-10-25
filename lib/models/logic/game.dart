import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_novel/models/member.dart';
import 'package:flutter_novel/models/message.dart';
import 'package:flutter_novel/models/user_play_data.dart';
import 'package:flutter_novel/utils/googleapi_settings.dart';

// ゲームデータ管理
class GameLogic {
	final String uid;
	final UserPlayDataModel user_play_data;
	final List<MessageModel> message_list;

	GameLogic({
		required this.uid,
		required this.user_play_data,
		required this.message_list,
	});

	@override
	String toString() {
		return 'UserModel('
			'uid: $uid,'
			'user_play_data: $user_play_data,'
			'message_list: $message_list,'
		')';
	}

	static Future<GameLogic> getData(String uid) async {
		final userPlayData = await UserPlayDataModel.getUserPlayDataByUid(uid);

		// メンバーデータ取得
		String range1 = "chara!A:B";
		final memberData = await GoogleApiSettings.createGoogleSheetsApiGetUrl(range1);

		final List<MemberModel> memberList = [];

		for (final member in memberData) {
			final addMember = getMemberData(member);	
			memberList.add(addMember);
		}

		// 進行中のシナリオデータ取得
		String range2 = "shene"+ userPlayData.shene.toString() +"!A:C";
		final messageData = await GoogleApiSettings.createGoogleSheetsApiGetUrl(range2);

		final List<MessageModel> messageList = [];

		for (final message in messageData) {
			final addMessage = getMessageData(message, memberList);
			messageList.add(addMessage);
		}

		return GameLogic(
			uid: uid,
			user_play_data: userPlayData,
			message_list: messageList,
		);
	}

	// メンバーデータを加工
	static MemberModel getMemberData(dynamic member) {
		String name = member[0] as String;
		String member_id = member[1] as String;

		return MemberModel(
			name: name,
			member_id: member_id,
		);
	} 

	// メッセージデータを加工
	static MessageModel getMessageData(dynamic message, List<MemberModel> memberList) {
		String member_id = message[0] as String;
		int member_index = int.parse(member_id);
		String memberName = memberList[member_index - 1].name;
		String body = message[1] as String;
		String bg = message[2] as String;
		String chara_image = "images/chara/chara_${member_id}_1.png";

		return MessageModel(
			member_id: member_id,
			name: memberName,
			body: body,
			bg: bg,
			chara_image: chara_image,
		);
	}
}
