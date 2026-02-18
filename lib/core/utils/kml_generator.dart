class KMLGenerator {
  /// Generates a KML Tour that orbits the specified point.
  /// [lat], [lng]: Center point of the orbit.
  /// [range]: Distance from the center (meters).
  /// [tilt]: Camera tilt (degrees).
  /// [heading]: Initial heading (degrees).
  static String generateOrbitTour(double lat, double lng, double range, double tilt, double heading) {
    StringBuffer kml = StringBuffer();
    kml.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    kml.writeln('<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2">');
    kml.writeln('<gx:Tour>');
    kml.writeln('  <name>Orbit</name>');
    kml.writeln('  <gx:Playlist>');

    // Initial FlyTo
    kml.writeln('    <gx:FlyTo>');
    kml.writeln('      <gx:duration>4.0</gx:duration>');
    kml.writeln('      <gx:flyToMode>smooth</gx:flyToMode>');
    kml.writeln('      <LookAt>');
    kml.writeln('        <longitude>$lng</longitude>');
    kml.writeln('        <latitude>$lat</latitude>');
    kml.writeln('        <altitude>0</altitude>');
    kml.writeln('        <heading>$heading</heading>');
    kml.writeln('        <tilt>$tilt</tilt>');
    kml.writeln('        <range>$range</range>');
    kml.writeln('        <gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>');
    kml.writeln('      </LookAt>');
    kml.writeln('    </gx:FlyTo>');

    // Orbit Loop (36 points for smooth 360 degree orbit)
    for (int i = 1; i <= 36; i++) {
      double nextHeading = (heading + (i * 10)) % 360;
      kml.writeln('    <gx:FlyTo>');
      kml.writeln('      <gx:duration>1.0</gx:duration>'); // 36 seconds total
      kml.writeln('      <gx:flyToMode>smooth</gx:flyToMode>');
      kml.writeln('      <LookAt>');
      kml.writeln('        <longitude>$lng</longitude>');
      kml.writeln('        <latitude>$lat</latitude>');
      kml.writeln('        <altitude>0</altitude>');
      kml.writeln('        <heading>$nextHeading</heading>');
      kml.writeln('        <tilt>$tilt</tilt>');
      kml.writeln('        <range>$range</range>');
      kml.writeln('        <gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>');
      kml.writeln('      </LookAt>');
      kml.writeln('    </gx:FlyTo>');
    }

    kml.writeln('  </gx:Playlist>');
    kml.writeln('</gx:Tour>');
    kml.writeln('</kml>');

    return kml.toString();
  }

  static String generateTajMahalTour() {
    // Taj Mahal Coordinates: 27.1751° N, 78.0421° E
    return generateOrbitTour(27.1751, 78.0421, 1000, 60, 0);
  }
}