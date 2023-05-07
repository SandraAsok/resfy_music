part of 'favourites_bloc.dart';

@immutable
abstract class FavouritesEvent {}

class AddorRemoveFavourites extends FavouritesEvent {
  final Favourites favsong;
  final int index;

  AddorRemoveFavourites(this.favsong, this.index);

  List<Object> get props => [favsong, index];
}

class RemoveFromFavourites extends FavouritesEvent {
  final Favourites favsong;
  final int index;

  RemoveFromFavourites(this.favsong, this.index);

  List<Object> get props => [favsong, index];
}

class RemoveFromFavouritesList extends FavouritesEvent {
  final int index;

  RemoveFromFavouritesList(this.index);

  List<Object> get props => [index];
}

class FetchFavSongs extends FavouritesEvent {
  FetchFavSongs();

  List<Object> get props => [];
}
