class ApiEndPoints {
  static const products = "products";
  static const popularMovies = "movie/popular";
  static const upcomingMovies = "movie/upcoming";
  static const getGenreList = "genre/movie/list";
}

/*
curl --request GET \
     --url 'https://api.themoviedb.org/3/person/changes?page=1' \
     --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxZGQ2YWM5ZDk4NzBlYjg3MTBlMjRkM2FlZThhMjNkOSIsIm5iZiI6MTc2NTMwMTE1My42OTcsInN1YiI6IjY5Mzg1YmExMzM5ZDgyZjQ4NWY4NzZlNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0sqo6RdAWX5JYowijyc2Ouf4p-1mHg4rzRy9nSSn2B0' \
     --header 'accept: application/json'
*/
