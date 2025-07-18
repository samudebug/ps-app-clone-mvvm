class GameDuration {
  final int hours;
  final int minutes;

  GameDuration({required this.hours, required this.minutes});
}
class Game {
  final String id;
  final String name;
  final String imageUrl;
  final GameDuration duration;

  Game({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.duration,
  }); 

  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Game &&
        other.id == id;
  }

}