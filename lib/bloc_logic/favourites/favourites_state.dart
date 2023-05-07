part of 'favourites_bloc.dart';

@immutable
abstract class FavouritesState {
  @override
  List<Object> get props => [];
}

class FavouritesInitial extends FavouritesState {
  FavouritesInitial();

  @override
  List<Object> get props => [];
}

class DisplayFavSongs extends FavouritesState {
  final List<Favourites> favourites;

  DisplayFavSongs(this.favourites);

  @override
  List<Object> get props => [favourites];
}
