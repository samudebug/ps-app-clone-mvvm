abstract final class Routes {
  static const String profile = '/profile';
  static const String games = '/games';
  static String game_details(String gameId) => '/games/$gameId';
  static String trophy_group_details(String gameId, String trophyGroupId) =>
      '/games/$gameId/trophies/$trophyGroupId';
}