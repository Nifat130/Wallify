import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallify_nifat/bloc/wallify_nifat_bloc.dart';
import 'package:wallify_nifat/ui/wallify_mainpage.dart';
import 'package:wallify_nifat/utils/customscrollbehavior.dart';

void main(){
  runApp(NifatApp());
}

class NifatApp extends StatelessWidget{

  @override

  Widget build(BuildContext context){
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WallifyNifatBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark
        ),
        scrollBehavior: CustomScrollBehavior(),
        home: MainPage(),
      ),
    );
  }
}

///