// シナリオデータ
class MessageModel {
  final String memberId;
  final String name;
  final String body;
  final String? charaImage;
  final String bg;
  final dynamic? effect;
  final dynamic? function;
  final int? nextScene;

  MessageModel({
    required this.memberId,
    required this.name,
    required this.body,
    this.charaImage,
    required this.bg,
    this.effect,
    this.function,
    this.nextScene,
  });

  @override
  String toString() {
    return 'MessageModel('
        'memberId: $memberId,'
        'name: $name,'
        'body: $body,'
        'charaImage: $charaImage,'
        'bg: $bg,'
        'effect: $effect,'
        'function: $function,'
        'nextScene: $nextScene,'
        ')';
  }
}
