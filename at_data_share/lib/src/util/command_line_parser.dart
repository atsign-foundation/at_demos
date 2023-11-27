import 'package:args/args.dart';

/// A class for taking a list of raw command line arguments and parsing out
/// options and flags from them.
class CommandLineParser {
  /// Parses [arguments], a list of command-line arguments, matches them against the
  /// flags and options defined by this parser, and returns the result.
  ArgResults getParserResults(List<String> arguments, ArgParser parser) {
    var results;
    try {
      if (arguments.isNotEmpty) {
        results = parser.parse(arguments);
        if (results.options.length != parser.options.length) {
          throw ArgParserException('Invalid Arguments \n' + parser.usage);
        }
      } else {
        throw ArgParserException('ArgParser Exception \n' + parser.usage);
      }
      return results;
    } on ArgParserException {
      throw ArgParserException('ArgParserException\n' + parser.usage);
    }
  }

  ArgParser getParser() {
    var parser = ArgParser();
    parser.addOption('atSign', abbr: 'a', help: 'atSign');
    parser.addOption('dataShareType', abbr:'d', help: 'Send or receive data');
    return parser;
  }
}
