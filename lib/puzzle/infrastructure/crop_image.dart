import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as image;

class CropImage {
  Future<List<Uint8List>> splitImage({
    required String assetName,
    required int pieceCount,
  }) async {
    final assetImageByteData =
        await rootBundle.load('assets/puzzles/$assetName');
    final baseSizeImage =
        image.decodeImage(assetImageByteData.buffer.asUint8List());

    if (baseSizeImage != null) {
      final xLength = (baseSizeImage.width / pieceCount).round();
      final yLength = (baseSizeImage.height / pieceCount).round();

      final pieceList = <image.Image>[];
      for (var y = 0; y < pieceCount; y++) {
        for (var x = 0; x < pieceCount; x++) {
          pieceList.add(
            image.copyCrop(
              baseSizeImage,
              x * xLength,
              y * yLength,
              xLength,
              yLength,
            ),
          );
        }
      }

      final outputImageList = <Uint8List>[];
      for (final img in pieceList) {
        outputImageList.add(
          Uint8List.fromList(
            image.encodePng(img),
          ),
        );
      }

      return outputImageList;
    }
    return <Uint8List>[];
  }
}
