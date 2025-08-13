import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallify_nifat/bloc/wallify_nifat_bloc.dart';
import 'package:wallify_nifat/repository/wallify_repository.dart';
import 'package:wallify_nifat/ui/preview_page.dart';
import 'package:wallify_nifat/utils/wallify_utils.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  WallifyRepository wallifyRepository = WallifyRepository();
  ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  int pageNumber = 0;
  List<String> categories = [
    'Nature',
    'Cartoon',
    'Sport',
    'Bike',
    'Technology',
    'Mountains',
    'Cars',
    'People'
  ];
  @override
  void initState() {
    // TODO: implement initState
    Random ran = Random();
    pageNumber = ran.nextInt(25) + 1;
    // // imageList = wallifyRepository.getImageList(pageNumber: pageNumber);
    // imageList = wallifyRepository.getImagesBySearch(query: 'cat');
    context.read<WallifyNifatBloc>().add(HitInit(pageNumber: pageNumber));
    super.initState();
  }
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          toolbarHeight: 75,
          title: RichText(
              text: const TextSpan(
                  text: "Wall",
                  style: TextStyle(
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Pacifico',
                      fontSize: 40,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "ify",
                      style: TextStyle(
                          color: Colors.tealAccent,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Pacifico',
                          fontSize: 40
                      ),
                    )
                  ]
              )
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(height: 15,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: textEditingController,
                  cursorColor: Colors.tealAccent,
                  onSubmitted: (v){
                    context.read<WallifyNifatBloc>().add(HitSearch(search: textEditingController.text));
                  },
                  style: TextStyle(
                    color: Colors.white
                  ),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 25),
                      labelText: 'Search',
                      labelStyle: TextStyle(color: Colors.tealAccent),
                      floatingLabelStyle: TextStyle(color: Colors.tealAccent),
                      focusColor: Colors.tealAccent,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.tealAccent,
                            width: 2
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.tealAccent,
                            width: 2
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red,
                            width: 2
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.tealAccent,
                            width: 2
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: IconButton(
                            onPressed: (){
                              context.read<WallifyNifatBloc>().add(HitSearch(search: textEditingController.text));
                            },
                            icon: const Icon(Icons.search_rounded, color: Colors.tealAccent,)
                        ),
                      ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp('[a-zA-Z0-9]')
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: ElevatedButton(
                              onPressed: (){
                                context.read<WallifyNifatBloc>().add(HitSearch(search: categories[index].toString()));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.tealAccent,
                                  side: BorderSide(
                                      color: Colors.tealAccent,
                                      width: 2
                                  )
                              ),
                              child: Text(categories[index], style: TextStyle(fontWeight: FontWeight.w800),)
                          ),
                        );
                      }
                  ),
                ),
              ),
              BlocBuilder<WallifyNifatBloc, WallifyNifatState>(
                  builder: (context, state){
                    if(state.status == WallifyEnum.loading){
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.tealAccent,
                          color: Colors.yellowAccent,
                        ),
                      );
                    }
                    else{
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: MasonryGridView.count(
                                  controller: scrollController,
                                  itemCount: state.imageList.length,
                                  shrinkWrap: true,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                  crossAxisCount: 2,
                                  itemBuilder: (context, index){
                                    double height = (index % 10 + 1) * 100;
                                    return GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (_) => PreviewPage(
                                                imageUrl: state.imageList[index].imagePortraitPath,
                                                imageId: state.imageList[index].imageId
                                            )
                                        ));
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          height: height > 300 ? 300 : height,
                                          imageUrl: state.imageList[index].imagePortraitPath,
                                        ),
                                      ),
                                    );
                                  }
                              )
                          ),
                        ],
                      );
                    }
                  }
              ),
            ],
          ),
        )
      ),
    );
  }
}
