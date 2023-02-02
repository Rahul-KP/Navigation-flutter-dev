import 'dart:math';
import 'package:here_sdk/core.dart';

class RDP {
  static List<GeoCoordinates> simplifyRDP(
      List<GeoCoordinates> points, double epsilon) {
    int n = points.length;
    if (n < 3) {
      return points;
    }

    int index = 0;
    double dmax = 0.0;

    for (int i = 1; i < n - 1; i++) {
      double d = _perpendicularDistance(points[i], points[0], points[n - 1]);
      if (d > dmax) {
        index = i;
        dmax = d;
      }
    }

    List<GeoCoordinates> result;
    if (dmax > epsilon) {
      List<GeoCoordinates> recResults1 =
          simplifyRDP(points.sublist(0, index + 1), epsilon);
      List<GeoCoordinates> recResults2 =
          simplifyRDP(points.sublist(index, n), epsilon);

      result = List.from(recResults1.sublist(0, recResults1.length - 1))
        ..addAll(recResults2);
    } else {
      result = [points[0], points[n - 1]];
    }

    return result;
  }

  static double _perpendicularDistance(
      GeoCoordinates point, GeoCoordinates start, GeoCoordinates end) {
    double dx = end.longitude - start.longitude;
    double dy = end.latitude - start.latitude;

    if (dx == 0 && dy == 0) {
      return 0;
    }

    double t = ((point.longitude - start.longitude) * dx +
            (point.latitude - start.latitude) * dy) /
        (dx * dx + dy * dy);

    if (t < 0) {
      return _euclideanDistance(point, start);
    } else if (t > 1) {
      return _euclideanDistance(point, end);
    }

    return _euclideanDistance(point,
        GeoCoordinates(start.latitude + t * dy, start.longitude + t * dx));
  }

  static double _euclideanDistance(GeoCoordinates p1, GeoCoordinates p2) {
    double dx = p2.longitude - p1.longitude;
    double dy = p2.latitude - p1.latitude;

    return sqrt(dx * dx + dy * dy);
  }
}
