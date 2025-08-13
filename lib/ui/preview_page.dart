import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/wallify_nifat_bloc.dart';

class PreviewPage extends StatefulWidget {
  final String imageUrl;
  final int imageId;
  const PreviewPage({super.key,required this.imageUrl,required this.imageId});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          toolbarHeight: 80,
          foregroundColor: Colors.redAccent.withOpacity(0.8),
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(
                      Icons.cancel,
                    size: 40,
                  )
              ),
            )
          ],
        ),
        body: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          errorWidget: (context, url, error) => const Icon(Icons.error_outline),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 50,
          backgroundColor: Colors.tealAccent,
          onPressed: (){
            context.read<WallifyNifatBloc>().add(HitDownload(
              imageUrl: widget.imageUrl,
              imageId: widget.imageId,
              contexts: context
            ));
            /*ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("You have to pay", style: TextStyle(color: Colors.white),),
                showCloseIcon: true,
                backgroundColor: Colors.red.withOpacity(0.5),
                closeIconColor: Colors.white,
              )
            );*/
          },
          child: Icon(Icons.download, color: Colors.black, size: 35,),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
