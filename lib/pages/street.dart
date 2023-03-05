import 'package:flutter/material.dart';
import 'package:camerax/camerax.dart';

class street_viewPage extends StatefulWidget {
  const street_viewPage({super.key});

  @override
  State<street_viewPage> createState() => _street_viewPageState();
}

class _street_viewPageState extends State<street_viewPage>
    with TickerProviderStateMixin {
  late CameraController cameraController;
  late AnimationController animationConrtroller;
  late Animation<double> offsetAnimation;
  late Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();
    cameraController = CameraController();
    animationConrtroller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    offsetAnimation = Tween(begin: 0.2, end: 0.8).animate(animationConrtroller);
    opacityAnimation =
        CurvedAnimation(parent: animationConrtroller, curve: OpacityCurve());
    animationConrtroller.repeat();

    start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CameraView(cameraController),
        ],
      ),
    );
  }

  @override
  void dispose() {
    animationConrtroller.dispose();
    cameraController.dispose();
    super.dispose();
  }

  void start() async {
    await cameraController.startAsync();
    try {
      final barcode = await cameraController.barcodes.first;
      display(barcode);
    } catch (e) {
      print(e);
    }
  }

  void display(Barcode barcode) {
    Navigator.of(context).popAndPushNamed('display', arguments: barcode);
  }
}

class OpacityCurve extends Curve {
  @override
  double transform(double t) {
    if (t < 0.1) {
      return t * 10;
    } else if (t <= 0.9) {
      return 1.0;
    } else {
      return (1.0 - t) * 10;
    }
  }
}

class AnimatedLine extends AnimatedWidget {
  final Animation offsetAnimation;
  final Animation opacityAnimation;

  AnimatedLine(
      {Key? key, required this.offsetAnimation, required this.opacityAnimation})
      : super(key: key, listenable: offsetAnimation);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacityAnimation.value,
      child: CustomPaint(
        size: MediaQuery.of(context).size,
        painter: LinePainter(offsetAnimation.value),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final double offset;

  LinePainter(this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    final radius = size.width * 0.45;
    final dx = size.width / 2.0;
    final center = Offset(dx, radius);
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..isAntiAlias = true
      ..shader = RadialGradient(
        colors: [Colors.green, Colors.green.withOpacity(0.0)],
        radius: 0.5,
      ).createShader(rect);
    canvas.translate(0.0, size.height * offset);
    canvas.scale(1.0, 0.1);
    final top = Rect.fromLTRB(0, 0, size.width, radius);
    canvas.clipRect(top);
    canvas.drawCircle(center, radius, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
