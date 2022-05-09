import 'dart:ffi';
import 'dart:io';
import 'dart:convert';

import 'dart:typed_data';

int WORD = 0;

List<String> supportedMimeTypes = ['.hex'];
void main(List<String> arguments) {
  if (!arguments[0].endsWith('.hex')) {
    print("File Type not HEX");
    exit(0);
  }

  String tmp = File(arguments[0]).readAsStringSync();

  // ignore: dead_code
  for (int i = 1; i < tmp.length; i += 2) {
    i += 8;

    WORD = int.parse(tmp[i + 2] + tmp[i + 3] + tmp[i] + tmp[i + 1], radix: 16);

    if (WORD & 0x03FF == 0x0C) {
      print('true');
    }

    exit(0);
  }
}

void disassembleLayer1(int WORD) {
  // Layer 1
  switch ((WORD & 0xC000) >> 14) {
    case 0:
      // Layer 1.1
      switch ((WORD & 0x3000) >> 14) {
        case 0:
          // Layer 1.1.1
          switch ((WORD & 0xC00) >> 12) {
            case 0:
              // Layer 1.1.1.1
              switch ((WORD & 0x300) >> 12) {
                case 0:
                  break;
              }
              break;
          }
          break;
      }

      break;
    default:
  }
}

String generateInstruction(int instruction, int WORD) {}
