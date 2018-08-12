import 'dart:html';
import 'dart:typed_data';
// import 'dart:async';
// import 'package:nes/jsnes/nes.dart';
import 'package:nes/nes.dart';

CanvasElement canvas;
CanvasRenderingContext2D ctx;

List<List<int>> data;

bool stop = false;

main() async {
  var SCREEN_WIDTH = 256;
  var SCREEN_HEIGHT = 240;
  canvas = querySelector('#root');
  ctx = canvas.getContext('2d');

  var nes = new NES((List<int> x) {
    var data = Uint32List.fromList(x);

    for (var i = 0; i < data.length; i++) {
      // data[i] = 0xff | data[i] << 2;
      data[i] = data[i] | 0xff000000;
    }
    Uint8List d = new Uint8List.view(data.buffer);
    Uint8List n = new Uint8List(d.length);
    for (int i = 0; i < d.length / 4; i++) {
      n[i] = d[i + 3];
      n[i + 1] = d[i + 2];
      n[i + 2] = d[i + 1];
      n[i + 3] = d[i];
    }

    var imageData = ctx.getImageData(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    imageData.data.setAll(0, d);
    ctx.putImageData(imageData, 0, 0);
  }, (m) {
    print(m);
  });

  var req = await HttpRequest.request('/test.nes', responseType: 'arraybuffer');
  var data = new Uint8List.view(req.response);
  nes.loadROM(data);
  // nes.frame();
  // nes.frame();

  void run() {
    window.requestAnimationFrame((n) {
      nes.frame();
      run();
    });
  }

  run();

// nes.buttonDown(1, jsnes.Controller.BUTTON_A);

// nes.buttonUp(1, jsnes.Controller.BUTTON_A);
}
