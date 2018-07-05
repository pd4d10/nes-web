import 'dart:html';
import 'dart:typed_data';
import 'dart:async';
// import 'package:nes/jsnes/nes.dart';
import 'package:nes/nes.dart';

CanvasElement canvas;
CanvasRenderingContext2D ctx;

List<List<int>> data;

bool stop = false;

main() async {
  querySelector('#stop').addEventListener('click', (e) {
    e.preventDefault();
    stop = true;
  });

  var SCREEN_WIDTH = 256;
  var SCREEN_HEIGHT = 240;
  canvas = querySelector('#root');
  ctx = canvas.getContext('2d');

  var imageData = ctx.getImageData(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

  // ctx.fillStyle = "black";
  // set alpha to opaque
  // ctx.fillRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

  // buffer to write on next animation frame
  // var buf = new List(imageData.data.length);
  // Get the canvas buffer in 8bit and 32bit
  // var buf8 = new Uint8ClampedList(buf);
  // var buf32 = new Uint32List(imageData.data.length);

  // Set alpha
  // for (var i = 0; i < this.buf32.length; ++i) {
  //   this.buf32[i] = 0xff000000;
  // }

  // var nes = new NES({
  //   'onFrame': (List<int> x) {
  //     print('onFrame:');
  //     // print(x);
  //     for (var i = 0; i < x.length; i++) {
  //       x[i] |= 0xff000000;
  //     }
  //     var tmp = new Uint32List.fromList(x);
  //     // print(tmp);
  //     // print(new Uint8ClampedList.view(tmp.buffer));
  //     imageData.data.setAll(0, new Uint8ClampedList.view(tmp.buffer));
  //     // var st = new DateTime.now().millisecond;
  //     ctx.putImageData(imageData, 0, 0);

  //     // print(x);
  //     // print(new DateTime.now().millisecond - st);
  //   },
  //   'onStatusUpdate': (x) {
  //     print('onStatusUpdate:');
  //     print(x);
  //   },
  //   'onAudioSample': (x) {
  //     print('onAudioSample:');
  //     print(x);
  //   },
  // });
  var req = await HttpRequest.request('/test.nes', responseType: 'arraybuffer');
  var data = new Uint8List.view(req.response);
  var nes = new NES(data);

  void run(int c) {
    nes.run((Uint32List data) {
      for (var i = 0; i < data.length; i++) {
        // data[i] = 0xff | data[i] << 2;
        data[i] = data[i] | 0xff000000;
      }
      Uint8List d = new Uint8List.view(data.buffer);
      // Uint8List n = new Uint8List(d.length);
      // for (int i = 0; i < d.length / 4; i++) {
      //   n[i] = d[i + 3];
      //   n[i + 1] = d[i + 2];
      //   n[i + 2] = d[i + 1];
      //   n[i + 3] = d[i];
      // }
      imageData.data.setAll(0, d);
      ctx.putImageData(imageData, 0, 0);

      if (!stop && c > 0) {
        // print(c);
        new Future.delayed(const Duration(milliseconds: 16), () => run(c - 1));
      }
      // print(d);
    });
    // window.requestAnimationFrame((c) {
    //   run();
    // });

    // run();
  }

  run(1000);

  // nes.reset();

  // var total = 100;
  // void frame() {
  //   nes.frame((raw) {
  //     print(raw);

  //     for (var y = 0; y < 240; y++) {
  //       for (var x = 0; x < 256; x++) {
  //         var data = raw[x][y];
  //         var r = data[0];
  //         var g = data[1];
  //         var b = data[2];
  //         ctx.fillStyle = 'rgba($r,$g,$b,255)';
  //         ctx.fillRect(x, y, 1, 1);
  //       }
  //     }
  //   });
  //   total--;

  //   if (total == 0) return;

  //   window.requestAnimationFrame((number) {
  //     print(number);
  //     frame();
  //   });
  // }

  // frame();

  // print(nes.getData());

  // https://stackoverflow.com/questions/4899799/whats-the-best-way-to-set-a-single-pixel-in-an-html5-canvas
}
