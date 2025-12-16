import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../DB/DatabaseHelper.dart';
import 'Recognition.dart';

class Recognizer {
  late Interpreter interpreter;
  late InterpreterOptions _interpreterOptions;
  static const int WIDTH = 112;
  static const int HEIGHT = 112;
  final dbHelper = DatabaseHelper();
  Map<String, Recognition> registered = {};
  String get modelName => 'assets/ml_models/mobile_face_net.tflite';

  // Add this as a static/utility function or inside your class
  double cosineDistanceNormalized(List<double> a, List<double> b) {
    double dot = 0.0;
    double normA = 0.0;
    double normB = 0.0;

    for (int i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }

    // Avoid division by zero (shouldn't happen with real embeddings)
    if (normA == 0 || normB == 0) return 2.0;

    double similarity = dot / (sqrt(normA) * sqrt(normB));
    return 1.0 -
        similarity.clamp(-1.0, 1.0); // Convert to distance: 0=match, 2=no match
  }

  Recognizer({int? numThreads}) {
    _interpreterOptions = InterpreterOptions();

    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }
    loadModel();
    initDB();
  }

  initDB() async {
    await dbHelper.init();
    loadRegisteredFaces();
  }

  void loadRegisteredFaces() async {
    final allRows = await dbHelper.queryAllRows();
    // debugPrint('query all rows:');
    for (final row in allRows) {
      //  debugPrint(row.toString());
      print(row[DatabaseHelper.columnName]);
      String name = row[DatabaseHelper.columnName];
      List<double> embd =
          row[DatabaseHelper.columnEmbedding]
              .split(',')
              .map((e) => double.parse(e))
              .toList()
              .cast<double>();
      Recognition recognition = Recognition(
        row[DatabaseHelper.columnName],
        Rect.zero,
        embd,
        0,
      );
      registered.putIfAbsent(name, () => recognition);
      print('registered => ${registered.length} :: $name');
    }
  }

  Future<int> registerFaceInDB(String name, List<double> embedding) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnEmbedding: embedding.join(","),
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
    return id;
  }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset(modelName);
    } catch (e) {
      print('Unable to create interpreter, Caught Exception: ${e.toString()}');
    }
  }

  List<dynamic> imageToArray(img.Image inputImage) {
    img.Image resizedImage = img.copyResize(
      inputImage,
      width: WIDTH,
      height: HEIGHT,
    );
    List<double> flattenedList =
        resizedImage.data!
            .expand((channel) => [channel.r, channel.g, channel.b])
            .map((value) => value.toDouble())
            .toList();
    Float32List float32Array = Float32List.fromList(flattenedList);
    int channels = 3;
    int height = HEIGHT;
    int width = WIDTH;
    Float32List reshapedArray = Float32List(1 * height * width * channels);
    for (int c = 0; c < channels; c++) {
      for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
          int index = c * height * width + h * width + w;
          reshapedArray[index] =
              (float32Array[c * height * width + h * width + w] - 127.5) /
              127.5;
        }
      }
    }
    return reshapedArray.reshape([1, 112, 112, 3]);
  }

  Recognition recognize(img.Image image, Rect location) {
    //TODO crop face from image resize it and convert it to float array
    var input = imageToArray(image);
    print(input.shape.toString());

    //TODO output array
    List output = List.filled(1 * 192, 0).reshape([1, 192]);

    //TODO performs inference
    final runs = DateTime.now().millisecondsSinceEpoch;
    interpreter.run(input, output);
    final run = DateTime.now().millisecondsSinceEpoch - runs;
    print('Time to run inference: $run ms$output');

    //TODO convert dynamic list to double list
    List<double> outputArray = output.first.cast<double>();

    //TODO looks for the nearest embeeding in the database and returns the pair
    Pair pair = findNearest(outputArray);
    print("distance= ${pair.distance}");

    return Recognition(pair.name, location, outputArray, pair.distance);
  }

  // UPDATED & OPTIMIZED findNearest function
  Pair findNearestL2(List<double> emb) {
    if (registered.isEmpty) {
      return Pair("Unknown", 2.0);
    }

    Pair bestMatch = Pair(
      "Unknown",
      2.0,
    ); // Max possible cosine distance is ~2.0
    double bestDistance = 2.0;

    for (MapEntry<String, Recognition> item in registered.entries) {
      final String name = item.key;
      List<double> knownEmb = item.value.embeddings;

      // Compute L2-normalized cosine distance
      double distance = cosineDistanceNormalized(emb, knownEmb);

      // Lower distance = more similar
      if (distance < bestDistance) {
        bestDistance = distance;
        bestMatch = Pair(name, distance);
      }
    }

    // Optional: Apply threshold for "Unknown" rejection
    const double threshold =
        0.6; // Tune this! 0.5–0.7 is typical for MobileFaceNet
    if (bestDistance > threshold) {
      return Pair("Unknown", bestDistance);
    }

    return bestMatch;
  }

  //TODO  looks for the nearest embeeding in the database and returns the pair which contain information of registered face with which face is most similar
  findNearest(List<double> emb) {
    print('registered.entries => ${registered.entries.length}');
    Pair pair = Pair("Unknown", -5);
    for (MapEntry<String, Recognition> item in registered.entries) {
      print('findNearest => ${item.key}');
    }
    for (MapEntry<String, Recognition> item in registered.entries) {
      final String name = item.key;
      List<double> knownEmb = item.value.embeddings;
      double distance = 0;
      for (int i = 0; i < emb.length; i++) {
        double diff = emb[i] - knownEmb[i];
        distance += diff * diff;
      }
      distance = sqrt(distance);
      print(
        "distance : $distance : pair name : ${pair.name} : pair distance : ${pair.distance}",
      );
      // if (registered.entries.length == 1) {
      //   pair.distance = distance;
      //   pair.name = name;
      // } else {
      //   if (pair.distance == -5 || distance < pair.distance) {
      //     print(
      //       "distance : $distance : pair name : ${pair.name} : pair distance : ${pair.distance}",
      //     );
      //
      //     pair.distance = distance;
      //     pair.name = name;
      //   }
      // }

        if (pair.distance == -5 || distance < pair.distance) {
          print(
            "distance : $distance : pair name : ${pair.name} : pair distance : ${pair.distance}",
          );

          pair.distance = distance;
          pair.name = name;
        }

    }
    return pair;
  }

  void close() {
    interpreter.close();
  }
}

class Pair {
  String name;
  double distance;
  Pair(this.name, this.distance);
}
