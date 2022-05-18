import '../lib/instruction.dart' as instruction;
import '../lib/checksum.dart' as checksum;
import 'dart:io';

List<String> supportedMimeTypes = ['.hex'];
void main(List<String> arguments) {
  if (!arguments[0].endsWith('.hex')) {
    print("File is NOT of HEX Type");
    exit(0);
  }

  String tmp = File(arguments[0]).readAsStringSync();

  int i = 9;

  while (i < tmp.length) {
    int WORD = 0;
    int j = 0;
    double byteCount = int.parse(tmp[i - 8] + tmp[i - 7], radix: 16) / 2;

    while (j < byteCount) {
      WORD =
          int.parse(tmp[i + 2] + tmp[i + 3] + tmp[i] + tmp[i + 1], radix: 16);

      instruction.decode_V2(WORD);

      i += 4;
      j++;
    }

    i += 13;
  }

  exit(0);
}
