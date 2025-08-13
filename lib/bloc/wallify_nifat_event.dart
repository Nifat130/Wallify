part of 'wallify_nifat_bloc.dart';

abstract class WallifyNifatEvent extends Equatable{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class HitInit extends WallifyNifatEvent{
  final int pageNumber;
  HitInit({this.pageNumber = 1});

  @override
  // TODO: implement props
  List<Object?> get props => [pageNumber];
}
class HitSearch extends WallifyNifatEvent{
  final String search;
  HitSearch({this.search = ''});

  @override
  // TODO: implement props
  List<Object?> get props => [search];
}

class HitDownload extends WallifyNifatEvent{
  final String imageUrl;
  final int imageId;
  final BuildContext contexts;

  HitDownload({
    this.imageUrl = '',
    this.imageId = 1,
    required this.contexts
  });

  @override
  // TODO: implement props
  List<Object?> get props => [imageUrl, imageId, contexts];
}
