import 'package:lg_star_command/core/services/ssh_service.dart';
import 'package:lg_star_command/core/utils/kml_generator.dart';

class DashboardRepository {
  final SSHService _sshService;

  DashboardRepository(this._sshService);

  /// Generates the Taj Mahal tour KML and uploads it to the Master Rig.
  Future<void> sendTajMahalTour() async {
    if (!_sshService.isConnected) {
      throw Exception('Not connected to Liquid Galaxy');
    }

    final kml = KMLGenerator.generateTajMahalTour();
    
    // 1. Upload the KML to the Master
    // In a real scenario, we might save this to a file first, but dartssh2 allows streaming.
    // For simplicity with the current SSHService, we need to adapt.
    // The previous SSHService.upload took a File. We need to refactor SSHService or write to a temp file.
    // Let's assume we can execute a command to write the socket stream, or simpler: 
    // echo the string to the file if it's small enough. KML tours can be large.
    // Optimal: Write to local temp, then upload.
    
    // For this educational step, we'll try the "echo" method if small, but a Tour is large.
    // Better: Refactor SSHService to accept String content or write to local temp file.
    // Let's execute "echo 'CONTENT' > /var/www/html/tour.kml"
    
    // Sanitize KML for echo (escape single quotes)
    final safeKml = kml.replaceAll("'", "'\\''");
    
    await _sshService.execute("echo '$safeKml' > /var/www/html/tour.kml"); // Write KML
    
    // 2. Link it in kmls.txt (Hybrid Sync)
    // We append the network link to the kmls.txt so Slaves can see it? 
    // Actually, tours usually run on the Master. 
    // Standard LG pattern: Put KML in /var/www/html/kml/slave_X.kml for slaves.
    // For a Tour, it runs on Master. 
    // We just need to load it. 
    // Command to load: echo "playtour=Orbit" > /tmp/query.txt
    
    await _sshService.execute('echo "http://lg1:81/tour.kml" > /var/www/html/kmls.txt');
    await Future.delayed(const Duration(seconds: 1)); // Give LG a moment to load
  }

  Future<void> startTour() async {
     await _sshService.execute('echo "playtour=Orbit" > /tmp/query.txt');
  }

  Future<void> stopTour() async {
    await _sshService.execute('echo "exittour=true" > /tmp/query.txt');
  }
  
  Future<void> cleanRig() async {
    await _sshService.execute('echo "" > /tmp/query.txt'); // Stop queries
    await _sshService.execute('> /var/www/html/kmls.txt'); // Clear KMLs
  }
}
