class Recipe {
  final String name;
  final String time;
  final String difficulty;
  final int portions;
  final List<String> ingredients;
  final List<String> steps;

  Recipe({
    required this.name,
    required this.time,
    required this.difficulty,
    required this.portions,
    required this.ingredients,
    required this.steps,
  });
}
