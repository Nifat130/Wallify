import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:wallify_nifat/model/wallify_model.dart';
import 'package:http/http.dart' as nifat;
import 'package:permission_handler/permission_handler.dart';

class WallifyRepository{

  final String apiKey = 'cWMaILKTpuvCEzYiQaxTBlo3e2uQfpUleflWHRMgdNKEOYGiZtWDx8JQ';
  final String baseURL = 'https://api.pexels.com/v1/';

  Future<List<Images>> getImageList({required int? pageNumber}) async{
    String url = '';
    List<Images> imageList = [];
    if(pageNumber == null){
      url = "${baseURL}curated?per_page=80";
    }
    else{
      url = "${baseURL}curated?per_page=80&page=$pageNumber";
    }

    try{
      final response = await nifat.get(Uri.parse(url), headers: {'Authorization': apiKey});

      if(response.statusCode >= 200 && response.statusCode <=299){
        final data = jsonDecode(response.body);

        for(final json in data['photos'] as Iterable){
          final image = Images.fromJson(json);
          imageList.add(image);
        }
      }
    }catch(_){}

    return imageList;
  }

  Future<Images> getImageById({required int id}) async{
    final url = "${baseURL}photos/$id";
    Images image = Images.emptyConstructor();

    try{
      final response = await nifat.get(Uri.parse(url), headers: {'Authorization': apiKey});
      if(response.statusCode >= 200 && response.statusCode <=299){
        final data = jsonDecode(response.body);
        image = Images.fromJson(data);
      }
    }catch(_){}

    return image;
  }

  Future<List<Images>> getImagesBySearch({required String query}) async{
    final url = "${baseURL}search?query=$query&per_page=80";
    List<Images> imageList = [];
    try{
      final response = await nifat.get(Uri.parse(url), headers: {'Authorization': apiKey});
      if(response.statusCode >= 200 && response.statusCode <=299){
        final data = jsonDecode(response.body);
        for(final json in data['photos'] as Iterable){
          final image = Images.fromJson(json);
          imageList.add(image);
        }
      }
    }catch(_){}

    return imageList;
  }

  Future<void> downloadImage({required String imageUrl, required int imageId, required BuildContext context}) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        final response = await nifat.get(Uri.parse(imageUrl));

        if (response.statusCode >= 200 && response.statusCode <= 299) {
          final bytes = response.bodyBytes;
          final directory = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);

          final file = File("$directory/$imageId.png");
          await file.writeAsBytes(bytes);

          MediaScanner.loadMedia(path: file.path);

          if (context.mounted) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.greenAccent,
                content: Text("File has been saved at: ${file.path}"),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      } catch (_) {}
    } else {
      print("Permission denied");
    }
  }

}

