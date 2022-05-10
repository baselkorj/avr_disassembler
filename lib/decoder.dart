int decodeInstruction(int WORD) {
  // Layer 1
  switch ((WORD & 0xC000) >> 14) {
    case 0:
      // Layer 1.1
      switch ((WORD & 0x3000) >> 14) {
        case 0:
          // Layer 1.1.1
          switch ((WORD & 0xC00) >> 12) {
            case 0:
              // Base Instructions
              switch ((WORD & 0x300) >> 12) {
                case 0:
                  return 1; // NOP
                case 1:
                  return 2; // MOVW
                case 2:
                  return 3; // MULS
                case 3:
                  if (WORD & 0x80 == 0x0) {
                    if (WORD & 0x8 == 0x0) {
                      return 4; // MULSU
                    } else {
                      return 5; // FMUL
                    }
                  } else {
                    return 6; // FMULS
                  }
              }
              break;
            case 1:
          }
          break;
      }

      break;
    default:
      return 199;
  }

  return 199;
}
