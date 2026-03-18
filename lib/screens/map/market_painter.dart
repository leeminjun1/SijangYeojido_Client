import 'dart:ui';
import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/app_colors.dart';

class MarketPainter extends CustomPainter {
  final List<Store> stores;
  final List<POI> pois;
  final String? selectedStoreId;
  final List<String> routeTargetStoreIds;

  MarketPainter({
    required this.stores,
    required this.pois,
    this.selectedStoreId,
    this.routeTargetStoreIds = const [],
  });

  static const _zones = [
    _ZoneDef('A', 'A구역\n(건어물/농축산)', Rect.fromLTRB(0.1, 0.05, 0.45, 0.95), AppColors.zoneA),
    _ZoneDef('B', 'B구역\n(먹거리/생선)', Rect.fromLTRB(0.55, 0.05, 0.9, 0.95), AppColors.zoneB),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawZones(canvas, size);
    _drawAisles(canvas, size);
    
    if (routeTargetStoreIds.isNotEmpty) {
      _drawRoute(canvas, size);
    }
    
    _drawPOIs(canvas, size);
    _drawStores(canvas, size);
  }

  void _drawBackground(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.mapBackground;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  void _drawZones(Canvas canvas, Size size) {
    for (final zone in _zones) {
      final rect = _scaleRect(zone.rect, size);
      final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(12));

      // Fill
      final fillPaint = Paint()..color = zone.color;
      canvas.drawRRect(rRect, fillPaint);

      // Border
      final borderPaint = Paint()
        ..color = zone.color.withValues(alpha:0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawRRect(rRect, borderPaint);

      // Zone label
      final labelPainter = TextPainter(
        text: TextSpan(
          text: zone.label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B6560),
            height: 1.4,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      labelPainter.layout(maxWidth: rect.width - 16);
      labelPainter.paint(
        canvas,
        Offset(rect.left + 10, rect.top + 8),
      );
    }
  }

  void _drawAisles(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.aisle;

    // Center main aisle
    final centerAisle = _scaleRect(const Rect.fromLTRB(0.45, 0.0, 0.55, 1.0), size);
    canvas.drawRect(centerAisle, paint);

    // Path within A zone
    final aAisle = _scaleRect(const Rect.fromLTRB(0.24, 0.05, 0.31, 0.95), size);
    canvas.drawRect(aAisle, paint);

    // Path within B zone
    final bAisle = _scaleRect(const Rect.fromLTRB(0.69, 0.05, 0.76, 0.95), size);
    canvas.drawRect(bAisle, paint);
    
    // Top and Bottom connection aisles
    final topAisle = _scaleRect(const Rect.fromLTRB(0.0, 0.0, 1.0, 0.05), size);
    canvas.drawRect(topAisle, paint);
    final bottomAisle = _scaleRect(const Rect.fromLTRB(0.0, 0.95, 1.0, 1.0), size);
    canvas.drawRect(bottomAisle, paint);
  }

  void _drawPOIs(Canvas canvas, Size size) {
    for (final poi in pois) {
      final pos = Offset(poi.mapX * size.width, poi.mapY * size.height);
      final color = poi.type.color;

      // Background circle
      final bgPaint = Paint()..color = color.withValues(alpha:0.15);
      canvas.drawCircle(pos, 14, bgPaint);

      // Border circle
      final borderPaint = Paint()
        ..color = color.withValues(alpha:0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(pos, 14, borderPaint);

      // Main entrance logic
      final isEntrance = poi.type == POIType.entrance;
      final iconStr = isEntrance ? '입구' : _poiEmoji(poi.type);

      final labelPainter = TextPainter(
        text: TextSpan(
          text: iconStr,
          style: TextStyle(
            fontSize: isEntrance ? 10 : 12,
            fontWeight: isEntrance ? FontWeight.w800 : FontWeight.w400,
            color: isEntrance ? Colors.white : AppColors.textPrimary,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      
      if (isEntrance) {
        final entPaint = Paint()..color = AppColors.primary;
        canvas.drawCircle(pos, 14, entPaint);
      }

      labelPainter.layout();
      labelPainter.paint(
        canvas,
        Offset(pos.dx - labelPainter.width / 2, pos.dy - labelPainter.height / 2),
      );
    }
  }

  String _poiEmoji(POIType type) {
    switch (type) {
      case POIType.toilet:
        return '🚻';
      case POIType.parking:
        return '🅿';
      case POIType.atm:
        return '💳';
      case POIType.entrance:
        return '🚪';
    }
  }

  void _drawStores(Canvas canvas, Size size) {
    for (final store in stores) {
      final pos = Offset(store.mapX * size.width, store.mapY * size.height);
      final isSelected = store.id == selectedStoreId;

      if (isSelected) {
        // Selection ring
        final selectionPaint = Paint()
          ..color = AppColors.primary.withValues(alpha:0.25)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pos, 18, selectionPaint);
      }

      if (store.status == StoreStatus.open) {
        _drawOpenPin(canvas, pos, isSelected);
      } else {
        _drawClosedPin(canvas, pos, isSelected);
      }

      // Store name label
      final namePainter = TextPainter(
        text: TextSpan(
          text: store.name,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            shadows: const [
              Shadow(
                blurRadius: 2.0,
                color: Colors.white,
                offset: Offset(0, 0),
              ),
              Shadow(
                blurRadius: 4.0,
                color: Colors.white,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      namePainter.layout(maxWidth: 80);
      namePainter.paint(
        canvas,
        Offset(pos.dx - namePainter.width / 2, pos.dy + 14),
      );
    }
  }


  void _drawOpenPin(Canvas canvas, Offset pos, bool isSelected) {
    final path = Path()..addOval(Rect.fromCircle(center: pos, radius: isSelected ? 11 : 9));
    canvas.drawShadow(path, Colors.black, 2, true);

    final outerPaint = Paint()..color = AppColors.textPrimary;
    canvas.drawCircle(pos, isSelected ? 11 : 9, outerPaint);

    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(pos, 4, innerPaint);
  }

  void _drawClosedPin(Canvas canvas, Offset pos, bool isSelected) {
    final path = Path()..addOval(Rect.fromCircle(center: pos, radius: isSelected ? 11 : 9));
    canvas.drawShadow(path, Colors.black, 2, true);

    final outerPaint = Paint()..color = AppColors.textTertiary;
    canvas.drawCircle(pos, isSelected ? 11 : 9, outerPaint);

    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(pos, 4, innerPaint);
  }

  Rect _scaleRect(Rect normalized, Size size) {
    return Rect.fromLTRB(
      normalized.left * size.width,
      normalized.top * size.height,
      normalized.right * size.width,
      normalized.bottom * size.height,
    );
  }

  void _drawRoute(Canvas canvas, Size size) {
    if (routeTargetStoreIds.isEmpty) return;
    
    final entrance = pois.where((p) => p.type == POIType.entrance).firstOrNull;
    if (entrance == null) return;

    final path = Path();
    Offset currentPos = Offset(entrance.mapX * size.width, entrance.mapY * size.height);
    path.moveTo(currentPos.dx, currentPos.dy);
    
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    for (final storeId in routeTargetStoreIds) {
      final targetStore = stores.where((s) => s.id == storeId).firstOrNull;
      if (targetStore == null) continue;

      final end = Offset(targetStore.mapX * size.width, targetStore.mapY * size.height);
      
      // Routing strategy: 90-degree turns via center aisle
      final midX = size.width * 0.5;
      path.lineTo(midX, currentPos.dy); 
      path.lineTo(midX, end.dy);
      path.lineTo(end.dx, end.dy);
      
      currentPos = end;
    }

    // Draw dashed path
    const dashWidth = 8.0;
    const dashSpace = 6.0;
    double distance = 0.0;
    
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        canvas.drawPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
      distance = 0.0;
    }
    
    // Draw dots at each stop
    for (final storeId in routeTargetStoreIds) {
      final s = stores.where((st) => st.id == storeId).firstOrNull;
      if (s != null) {
        final p = Offset(s.mapX * size.width, s.mapY * size.height);
        canvas.drawCircle(p, 6, Paint()..color = AppColors.primary);
      }
    }
  }

  Store? storeAtPosition(Offset pos, Size size) {
    const hitRadius = 20.0;
    for (final store in stores) {
      final storePos = Offset(store.mapX * size.width, store.mapY * size.height);
      if ((pos - storePos).distance <= hitRadius) {
        return store;
      }
    }
    return null;
  }

  @override
  bool shouldRepaint(MarketPainter oldDelegate) {
    return oldDelegate.selectedStoreId != selectedStoreId ||
        oldDelegate.routeTargetStoreIds.length != routeTargetStoreIds.length ||
        oldDelegate.stores.length != stores.length;
  }
}

class _ZoneDef {
  final String id;
  final String label;
  final Rect rect;
  final Color color;

  const _ZoneDef(this.id, this.label, this.rect, this.color);
}
