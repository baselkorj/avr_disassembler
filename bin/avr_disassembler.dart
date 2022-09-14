import 'package:avr_disassembler/instruction.dart' as instruction;
import 'dart:io';

List<String> supportedMimeTypes = ['.hex'];
void main(List<String> arguments) {
  if (!arguments[0].endsWith('.hex')) {
    print("File is NOT of HEX Type");
    exit(0);
  }

  String tmp = File(arguments[0]).readAsStringSync();

  int i = 0;

  while (i < tmp.length) {
    int word = 0;
    int j = 0;
    int byteCount = int.parse(tmp.substring(i + 1, i + 3), radix: 16);

    i += 9;

    while (j < byteCount) {
      word =
          int.parse(tmp[i + 2] + tmp[i + 3] + tmp[i] + tmp[i + 1], radix: 16);

      instruction.decode(word);
      i += 4;
      j += 2;
    }

    i += 3;
  }

  exit(0);
}
