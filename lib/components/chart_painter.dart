import 'package:flutter/material.dart';
import 'dart:math';

class ChartPainter extends CustomPainter {
  final List<double> weekData;
  final DateTime startDate;
  double yMin = 0;
  double yMax = 0;
  double xSize = 320.0;
  double ySize = 150.0;
  ChartPainter(this.weekData, this.startDate) {
    yMin = weekData.reduce(min);
    yMax = weekData.reduce(max);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.white;
    canvas.drawPaint(paint);
    var center = Offset(size.width / 2, size.height / 2);
    drawChart(canvas, center);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void drawChart(Canvas canvas, Offset center) {
    var rect = Rect.fromCenter(center: center, width: xSize, height: ySize);
    var borderStyle = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    var titleStyle = const TextStyle(
      color: Colors.black,
      fontSize: 40,
      fontWeight: FontWeight.w900,
    );
    var labelStyle = const TextStyle(
      color: Colors.black,
      fontSize: 13,
      fontWeight: FontWeight.bold,
    );

    drawChartBorders(canvas, borderStyle, rect);
    drawDataPoints(canvas, rect);
    drawText(canvas, rect.topLeft + const Offset(-10, -60), rect.width + 20,
        titleStyle, "Weekly Line Chart");
    drawLabels(canvas, rect, labelStyle);
  }

  void drawChartBorders(Canvas canvas, Paint borderStyle, Rect rect) {
    for (double x = rect.left; x <= rect.right; x += xSize / 6.0) {
      canvas.drawLine(Offset(x, rect.bottom), Offset(x, rect.top), borderStyle);
    }
    for (double y = 0; y <= ySize; y += ySize / 3.0) {
      canvas.drawLine(Offset(rect.left, rect.bottom - y),
          Offset(rect.right, rect.bottom - y), borderStyle);
    }
  }

  void drawDataPoints(Canvas canvas, Rect rect) {
    var yRatio = ySize / (yMax - yMin);
    var p = Path();
    var x = rect.left;
    for (var item in weekData) {
      var y = (item - yMin) * yRatio;
      if (x == rect.left) {
        p.moveTo(x, rect.bottom - y);
      } else {
        p.lineTo(x, rect.bottom - y);
      }
      x += xSize / 6.0;
    }

    p.moveTo(x - xSize / 6.0, rect.bottom);
    p.moveTo(rect.left, rect.bottom);
    canvas.drawPath(
        p,
        Paint()
          ..color = Colors.redAccent
          ..strokeWidth = 3.0
          ..style = PaintingStyle.stroke);
  }

  void drawLabels(Canvas canvas, Rect rect, TextStyle labelStyle) {
    DateTime date = startDate;
    var x = rect.left;
    for (var i = 0; i < 7; i++) {
      Offset offset = Offset(x - 15, rect.bottom + 15);
      if (i == 0) offset = Offset(x - 10, rect.bottom + 15);
      if (i == 6) offset = Offset(x - 20, rect.bottom + 15);
      drawText(canvas, offset, 35, labelStyle,
          date.day.toString() + "." + date.month.toString());
      x += xSize / 6.0;
      date = date.add(const Duration(days: 1));
    }

    drawText(canvas, rect.bottomLeft + const Offset(-35, -10), 50, labelStyle,
        yMin.toString());
    drawText(canvas, rect.topLeft + const Offset(-35, 0), 50, labelStyle,
        yMax.toString());
  }

  drawText(Canvas canvas, Offset position, double width, TextStyle style,
      String text) {
    final textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0, maxWidth: width);
    textPainter.paint(canvas, position);
  }
}
