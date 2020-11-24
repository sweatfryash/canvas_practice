import 'dart:math';
import 'package:flutter/material.dart';

class CircleProgressPage extends StatelessWidget {

 final ValueNotifier<VoidCallback> startAnimation = ValueNotifier(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff6bb3e7),
      appBar: AppBar(
        title: Text('进度'),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 100,
          ),
          Text(
            '空气湿度',
            style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.9)),
          ),
          SizedBox(height: 10),
          CircleProgress(
            size: Size.square(180),
            progress: 0.66,
            startAnimation: startAnimation,
            primaryColor: Colors.white,
            child: Center(
              child: Text(
                '66%',
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
          ),
          ValueListenableBuilder(
            builder: (BuildContext context, value, Widget child) {
              return OutlinedButton(
                  onPressed: value,
                  child: Text('start'));
            },
            valueListenable: startAnimation,
          ),
        ],
      ),
    );
  }
}

class CircleProgress extends StatefulWidget {
  const CircleProgress(
      {Key key,
      @required this.progress,
      this.startAnimation,
      this.size = const Size.square(150),
      this.child,
      this.primaryColor = Colors.blue,
      this.paintWidth = 11.0,
      this.duration = const Duration(milliseconds: 500),
      this.curve = Curves.ease})
      : super(key: key);

  final Size size;
  final double progress;
  final ValueNotifier<VoidCallback> startAnimation;
  final Widget child;
  final Color primaryColor;
  final double paintWidth;
  final Duration duration;
  final Curve curve;

  @override
  _CircleProgressState createState() => _CircleProgressState();
}

class _CircleProgressState extends State<CircleProgress> with SingleTickerProviderStateMixin {

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.startAnimation != null) {
        widget.startAnimation.value = () {
          _controller.forward(from: 0);
        };
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CircleProgressPainter(
          progress: widget.progress,
          animationProgress: CurveTween(curve: widget.curve).animate(_controller),
          primaryColor: widget.primaryColor,
          paintWidth: widget.paintWidth),
      child: Container(
        width: widget.size.width,
        height: widget.size.height,
        child: widget.child,
      ),
    );
  }
}

class _CircleProgressPainter extends CustomPainter {
  _CircleProgressPainter(
      {this.primaryColor,
      this.paintWidth,
      this.progress,
      this.animationProgress,
      this.leftNum,
      this.rightNum})
      : super(repaint: animationProgress);
  final double progress;
  final Animation<double> animationProgress;
  final double leftNum;
  final double rightNum;

  final Paint _paint = Paint();
  final Color primaryColor;
  final halfSpaceRadians = pi / 4.5;
  final double paintWidth;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    _paint
      ..color = primaryColor.withOpacity(0.4)
      ..strokeWidth = paintWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    Rect rect = Rect.fromCenter(
        center: Offset(0, 0), height: size.height - paintWidth, width: size.width - paintWidth);
    canvas.rotate(pi / 2);
    canvas.drawArc(rect, halfSpaceRadians, (pi - halfSpaceRadians) * 2, false, _paint);
    _paint.color = primaryColor;
    if (animationProgress != null) {
      canvas.drawArc(rect, halfSpaceRadians, (pi - halfSpaceRadians) * 2 * animationProgress.value * progress,
          false, _paint);
    } else {
      canvas.drawArc(rect, halfSpaceRadians, (pi - halfSpaceRadians) * 2 * progress, false, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CircleProgressPainter oldDelegate) =>
      oldDelegate.animationProgress != animationProgress || oldDelegate.progress != progress;
}
