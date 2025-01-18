import 'dart:math';

class PasswordGenerator {
  /// Checks if a password meets minimum strength requirements
  /// Returns true if password is considered strong
  static bool isStrongPassword(String password) {
    if (password.length < 8) return false;

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasNumbers = password.contains(RegExp(r'[0-9]'));
    bool hasSymbols = password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

    return hasUppercase && hasLowercase && hasNumbers && hasSymbols;
  }

  /// Gets password strength score (0-4)
  /// 0: Very Weak, 1: Weak, 2: Medium, 3: Strong, 4: Very Strong
  static int getPasswordStrength(String password) {
    int score = 0;

    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) score++;

    return score > 4 ? 4 : score;
  }

  /// Generates a memorable password combining words, numbers and symbols
  static String generatePassword({
    int minLength = 12,
    bool includeNumbers = true,
    bool includeSymbols = true,
    bool includeUpperCase = true,
  }) {
    final random = Random.secure();

    // Select two random words
    String word1 = _commonWords[random.nextInt(_commonWords.length)];
    String word2 = _commonWords[random.nextInt(_commonWords.length)];

    // Ensure words are different
    while (word1 == word2) {
      word2 = _commonWords[random.nextInt(_commonWords.length)];
    }

    // Capitalize first letter of one word randomly
    if (includeUpperCase) {
      if (random.nextBool()) {
        word1 = word1[0].toUpperCase() + word1.substring(1);
      } else {
        word2 = word2[0].toUpperCase() + word2.substring(1);
      }
    }

    // Add numbers (2-3 digits)
    String numbers = '';
    if (includeNumbers) {
      int numCount = random.nextInt(3) + 1; // 2-3 numbers
      for (int i = 0; i < numCount; i++) {
        numbers += _numbers[random.nextInt(_numbers.length)];
      }
    }

    // Add symbol
    String symbol = '';
    if (includeSymbols) {
      int symCount = random.nextInt(2) + 1;
      for (int i = 0; i < symCount; i++) {
        if (i > 0) {
          if (random.nextBool()) {
            // repeat symbol randomly
            symbol += symbol[0];
          } else {
            symbol += _symbols[random.nextInt(_symbols.length)];
          }
        } else {
          symbol += _symbols[random.nextInt(_symbols.length)];
        }
      }
    }

    // Combine parts in a readable format
    List<String> parts = [];
    parts.add(word1);
    parts.add(word2);
    if (numbers.isNotEmpty) parts.add(numbers);
    if (symbol.isNotEmpty) parts.add(symbol);

    // Shuffle middle parts to add randomness while keeping words at start
    if (parts.length > 2) {
      var middleParts = parts.sublist(2);
      middleParts.shuffle(random);
      parts = [parts[0], parts[1], ...middleParts];
    }

    return parts.join('');
  }

  static const String _numbers = '0123456789'; // Avoiding confusing 0/1
  static const String _symbols = '!@#\$%^&*()+'; // Limited to clear symbols

  // Common words that are easy to remember (you can expand this list)
  static const List<String> _commonWords = [
    // Colors
    'red',
    'blue',
    'green',
    'gold',
    'silver',
    'purple',
    'orange',
    'yellow',
    'pink',
    'brown',
    'white',
    'black',
    'gray',
    'bronze',
    'copper',
    'coral',
    'cream',
    'crimson',
    'cyan',
    'indigo',
    'lime',
    'maroon',
    'navy',
    'olive',
    'peach',
    'plum',
    'rose',
    'ruby',
    'tan',
    'teal',

    // Nature
    'sun',
    'moon',
    'star',
    'sky',
    'cloud',
    'rain',
    'snow',
    'wind',
    'storm',
    'river',
    'lake',
    'ocean',
    'sea',
    'beach',
    'wave',
    'coral',
    'shell',
    'sand',
    'rock',
    'stone',
    'cliff',
    'peak',
    'cave',
    'valley',
    'forest',
    'tree',
    'leaf',
    'vine',
    'rose',
    'daisy',
    'lily',
    'pine',
    'oak',
    'maple',
    'palm',
    'grass',
    'moss',
    'fern',
    'bloom',
    'petal',
    'seed',
    'root',
    'brook',
    'creek',
    'stream',
    'pond',
    'pool',
    'spring',
    'falls',
    'dawn',
    'dusk',
    'noon',
    'night',

    // Animals
    'lion',
    'tiger',
    'bear',
    'wolf',
    'fox',
    'deer',
    'elk',
    'moose',
    'eagle',
    'hawk',
    'owl',
    'dove',
    'swan',
    'duck',
    'goose',
    'fish',
    'shark',
    'whale',
    'seal',
    'dolphin',
    'turtle',
    'frog',
    'toad',
    'snake',
    'bird',
    'robin',
    'crow',
    'raven',
    'cat',
    'dog',
    'horse',
    'pony',
    'zebra',
    'panda',
    'koala',
    'rabbit',
    'mouse',
    'otter',
    'puma',
    'lynx',
    'bison',
    'llama',
    'camel',
    'falcon',
    'finch',
    'lark',
    'stork',
    'crane',
    'heron',

    // Food and Drinks
    'apple',
    'peach',
    'pear',
    'plum',
    'grape',
    'berry',
    'lemon',
    'lime',
    'melon',
    'mango',
    'cherry',
    'olive',
    'bread',
    'cheese',
    'honey',
    'sugar',
    'spice',
    'mint',
    'basil',
    'sage',
    'thyme',
    'water',
    'juice',
    'tea',
    'cocoa',
    'cream',

    // Weather and Elements
    'wind',
    'rain',
    'snow',
    'ice',
    'frost',
    'mist',
    'fog',
    'cloud',
    'storm',
    'thunder',
    'flash',
    'breeze',
    'gust',
    'flame',
    'fire',
    'spark',
    'earth',
    'air',
    'water',

    // Time
    'day',
    'night',
    'dawn',
    'dusk',
    'noon',
    'eve',
    'summer',
    'winter',
    'spring',
    'fall',
    'year',
    'month',
    'week',
    'hour',

    // Positive Attributes
    'brave',
    'bold',
    'swift',
    'quick',
    'fast',
    'smart',
    'wise',
    'kind',
    'good',
    'great',
    'grand',
    'fair',
    'pure',
    'true',
    'false',
    'free',
    'safe',
    'lucky',
    'happy',
    'glad',
    'jolly',
    'bright',
    'light',
    'sharp',
    'clear',
    'clean',
    'fresh',
    'calm',
    'peace',
    'hope',
    'grace',

    // Materials
    'steel',
    'iron',
    'gold',
    'silver',
    'brass',
    'bronze',
    'metal',
    'wood',
    'stone',
    'glass',
    'silk',
    'linen',
    'wool',
    'cloth',
    'paper',
    'leather',

    // Shapes and Patterns
    'round',
    'square',
    'curve',
    'line',
    'point',
    'dot',
    'ring',
    'wave',
    'spiral',
    'star',
    'cross',
    'cube',
    'sphere',

    // Buildings and Places
    'home',
    'house',
    'tower',
    'castle',
    'fort',
    'bridge',
    'road',
    'path',
    'gate',
    'door',
    'wall',
    'hall',
    'room',
    'court',
    'plaza',
    'park',
    'garden',
    'town',
    'city',
    'port',

    // Space and Science
    'moon',
    'star',
    'sun',
    'mars',
    'venus',
    'comet',
    'orbit',
    'space',
    'atom',
    'cell',
    'wave',
    'beam',
    'pulse',
    'ray',

    // Music and Sound
    'song',
    'tune',
    'note',
    'bell',
    'drum',
    'horn',
    'flute',
    'voice',
    'sound',
    'tone',
    'echo',
    'chord',

    // Movement
    'jump',
    'leap',
    'skip',
    'run',
    'walk',
    'dash',
    'glide',
    'flow',
    'drift',
    'swing',
    'spin',
    'turn',
    'roll',

    // Gems and Minerals
    'ruby',
    'pearl',
    'opal',
    'jade',
    'amber',
    'coral',
    'onyx',
    'topaz',
    'quartz',
    'crystal',

    // Fantasy
    'dream',
    'wish',
    'hope',
    'magic',
    'spell',
    'charm',
    'myth',
    'tale',
    'story',
    'light',
    'shadow',
    'ghost',
    'spirit',

    // Sports
    'game',
    'team',
    'sport',
    'race',
    'goal',
    'win',
    'score',
    'play',
    'match',
    'field',
    'court',
    'track',

    // Technology
    'byte',
    'data',
    'code',
    'pixel',
    'screen',
    'link',
    'web',
    'net',
    'grid',
    'cloud',

    // Common Objects
    'book',
    'page',
    'card',
    'key',
    'lock',
    'box',
    'ring',
    'cup',
    'bowl',
    'lamp',
    'clock',
    'wheel',
    'shield',
    'crown',
    'belt',
    'chain',
    'tool'
  ];
}
