import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:wallify_nifat/model/wallify_model.dart';
import 'package:wallify_nifat/repository/wallify_repository.dart';
import 'package:wallify_nifat/utils/wallify_utils.dart';

part 'wallify_nifat_event.dart';
part 'wallify_nifat_state.dart';

class WallifyNifatBloc extends Bloc<WallifyNifatEvent, WallifyNifatState> {
  WallifyRepository wallifyRepository = WallifyRepository();
  WallifyNifatBloc() : super(WallifyNifatState()) {
    on<HitInit>(_i);
    on<HitSearch>(_s);
    on<HitDownload>(_d);
  }

  FutureOr<void> _d(HitDownload event, Emitter<WallifyNifatState> emit) async{
    try{
      await wallifyRepository.downloadImage(imageUrl: event.imageUrl, imageId: event.imageId, context: event.contexts);
    }catch(_){}
  }
  FutureOr<void> _i(HitInit event, Emitter<WallifyNifatState> emit) async{
    try{
      await wallifyRepository.getImageList(pageNumber: event.pageNumber).then(
              (value){
            emit(state.copyWith(
                imageList: value,
                status: WallifyEnum.initial,
            ));
          }
      ).onError((error, stacktrace){

      });
    }catch(_){}
  }

  FutureOr<void> _s(HitSearch event, Emitter<WallifyNifatState> emit) async{
    try{
      if(event.search != ''){
        emit(state.copyWith(status: WallifyEnum.loading));
        await wallifyRepository.getImagesBySearch(query: event.search).then(
                (value){
              Future.delayed(const Duration(seconds: 2));
              emit(state.copyWith(
                imageList: value,
                status: WallifyEnum.search,
              ));
            }
        ).onError((error, stacktrace){

        });
      }
    }catch(_){}
  }
}
