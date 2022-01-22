import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as image;

class CropImage {
  Future<List<Uint8List>> splitImage({
    required String assetName,
    required int horizontalPieceCount,
    required int verticalPieceCount,
  }) async {
    final assetImageByteData =
        await rootBundle.load('assets/puzzles/$assetName');
    final baseSizeImage =
        image.decodeImage(assetImageByteData.buffer.asUint8List());

    if (baseSizeImage != null) {
      final xLength = (baseSizeImage.width / horizontalPieceCount).round();
      final yLength = (baseSizeImage.height / verticalPieceCount).round();

      final pieceList = <image.Image>[];
      for (var y = 0; y < verticalPieceCount; y++) {
        for (var x = 0; x < horizontalPieceCount; x++) {
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
