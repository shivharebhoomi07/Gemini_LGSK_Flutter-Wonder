import 'package:flutter_test/flutter_test.dart';
import 'package:lg_star_command/core/utils/kml_generator.dart';

void main() {
  test('generateTajMahalTour returns valid KML structure', () {
    final kml = KMLGenerator.generateTajMahalTour();
    
    expect(kml, contains('<?xml version="1.0" encoding="UTF-8"?>'));
    expect(kml, contains('<gx:Tour>'));
    expect(kml, contains('<gx:Playlist>'));
    expect(kml, contains('<latitude>27.1751</latitude>')); // Taj Mahal Lat
    expect(kml, contains('<longitude>78.0421</longitude>')); // Taj Mahal Lng
    expect(kml, contains('<gx:FlyTo>'));
  });
}
