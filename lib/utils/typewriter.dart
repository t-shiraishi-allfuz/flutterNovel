import 'dart:async';
import 'package:flutter/material.dart';

// タイプライター風アニメーション
class TypeWriter extends StatefulWidget {
  final String message;
  final Duration duration;

  const TypeWriter(this.message,
      {super.key, this.duration = const Duration(milliseconds: 100)});

  @override
  State<TypeWriter> createState() => _TypeWriterState();
}

class _TypeWriterState extends State<TypeWriter> {
  int index = 0;
  Timer? _timer;
  late List<String> _textFragments;

  @override
  void initState() {
    super.initState();
    _textFragments = _splitText();
    _startTyping();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // タイプライター風に1文字ずつテキストを描画する
  void _startTyping() {
    _timer = Timer.periodic(widget.duration, (timer) {
      if (index <= _textFragments.length) {
        setState(() {
          index++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  // 1文字ずつ分割
  List<String> _splitText() {
    return widget.message.split('');
  }

  @override
  void didUpdateWidget(covariant TypeWriter oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.message != oldWidget.message) {
      index = 0;
      _timer = 0 as Timer?;

      _textFragments = _splitText();
      _startTyping();
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayedText = _textFragments.take(index).join();

    return Text(
      displayedText,
      style: const TextStyle(color: Colors.white),
    );
  }
}
