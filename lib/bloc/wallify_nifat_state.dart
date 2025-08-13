part of 'wallify_nifat_bloc.dart';

class WallifyNifatState extends Equatable{

  final List<Images> imageList;
  final WallifyEnum status;
  final String search;
  final int pageNumber;

  const WallifyNifatState({
    this.imageList = const <Images>[],
    this.status = WallifyEnum.loading,
    this.search = 'nature',
    this.pageNumber = 3
  });

  WallifyNifatState copyWith({List<Images>? imageList, WallifyEnum? status, String? search, int? pageNumber}){
    return WallifyNifatState(
      imageList: imageList ?? this.imageList,
      status: status ?? this.status,
      search: search ?? this.search,
      pageNumber: pageNumber ?? this.pageNumber
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [imageList, status, search, pageNumber];
}