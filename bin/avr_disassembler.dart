import 'package:avr_disassembler/decoder.dart' as decoder;
import 'dart:io';

List<String> supportedMimeTypes = ['.hex'];
void main(List<String> arguments) {
  if (!arguments[0].endsWith('.hex')) {
    print("File Type not HEX");
    exit(0);
  }

  String tmp = File(arguments[0]).readAsStringSync();

  int i = 0;

  while (i < tmp.length) {
    int WORD = 0;

    WORD = int.parse(tmp[i + 2] + tmp[i + 3] + tmp[i] + tmp[i + 1], radix: 16);

    decoder.decodeInstruction(WORD);

    i += 4;
  }

  exit(0);
}
