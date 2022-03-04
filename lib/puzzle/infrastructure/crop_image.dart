import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as image;

class SplitImageInfo {
  SplitImageInfo(this.assetName, this.pieceCount);

  final String assetName;
  final int pieceCount;
}

class CropImage {
  Future<List<image.Image>> _getImageParts(
    SplitImageInfo splitImageInfo,
  ) async {
    final pieceList = <image.Image>[];
    final assetImageByteData =
        await rootBundle.load('assets/puzzles/${splitImageInfo.assetName}');
    final baseSizeImage =
        image.decodeImage(assetImageByteData.buffer.asUint8List());

    if (baseSizeImage != null) {
      final xLength = (baseSizeImage.width / splitImageInfo.pieceCount).round();
      final yLength =
          (baseSizeImage.height / splitImageInfo.pieceCount).round();

      for (var y = 0; y < splitImageInfo.pieceCount; y++) {
        for (var x = 0; x < splitImageInfo.pieceCount; x++) {
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
    }
    return pieceList;
  }

  Future<List<Uint8List>> splitImage(
    SplitImageInfo splitImageInfo,
  ) async {
    final pieceList = await _getImageParts(splitImageInfo);

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
}
