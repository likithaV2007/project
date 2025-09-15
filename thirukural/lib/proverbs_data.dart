import 'proverb.dart';

class ProverbsRepository {
  static final List<Proverb> _proverbs = [
    Proverb(
      id: 1,
      text: "A stitch in time saves nine",
      meaning: "Taking care of a problem early prevents it from getting worse",
      origin: "English",
      category: "Wisdom",
    ),
    Proverb(
      id: 2,
      text: "Actions speak louder than words",
      meaning: "What you do is more important than what you say",
      origin: "English",
      category: "Character",
    ),
    Proverb(
      id: 3,
      text: "The early bird catches the worm",
      meaning: "Success comes to those who prepare well and put in effort",
      origin: "English",
      category: "Success",
    ),
    Proverb(
      id: 4,
      text: "Don't count your chickens before they hatch",
      meaning: "Don't make plans based on something that hasn't happened yet",
      origin: "English",
      category: "Caution",
    ),
    Proverb(
      id: 5,
      text: "When in Rome, do as the Romans do",
      meaning: "Adapt to the customs of the place you are visiting",
      origin: "Latin",
      category: "Adaptation",
    ),
    Proverb(
      id: 6,
      text: "Fortune favors the bold",
      meaning: "Those who take risks are more likely to succeed",
      origin: "Latin",
      category: "Courage",
    ),
    Proverb(
      id: 7,
      text: "All that glitters is not gold",
      meaning: "Not everything that looks valuable or true turns out to be so",
      origin: "English",
      category: "Wisdom",
    ),
    Proverb(
      id: 8,
      text: "Better late than never",
      meaning: "It's better to do something late than not at all",
      origin: "English",
      category: "Perseverance",
    ),
  ];

  static List<Proverb> get proverbs => List.unmodifiable(_proverbs);

  static void addProverb(Proverb proverb) {
    _proverbs.add(proverb);
  }

  static int get nextId => _proverbs.isEmpty
      ? 1
      : _proverbs.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1;
}