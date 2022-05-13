int decode(int WORD) {
  // X X b b b b b b   b b b b b b b b
  switch ((WORD & 0xC000) >> 14) {
    case 0:
      // b b X X b b b b   b b b b b b b b
      switch ((WORD & 0x3000) >> 14) {
        case 0:
          // b b b b X X b b   b b b b b b b b
          switch ((WORD & 0xC00) >> 12) {
            // Base Instructions
            case 0:
              switch ((WORD & 0x300) >> 12) {
                case 0:
                  return 1; // NOP
                case 1:
                  return 2; // MOVW
                case 2:
                  return 3; // MULS
                case 3:
                  if (WORD & 0x80 == 0) {
                    return (WORD & 0x8 == 0) == 0 ? 4 : 5; // MULSU | FMUL
                  } else {
                    return (WORD & 0x8 == 0) == 0 ? 6 : 7; // FMULS | FMULU
                  }
              }
              break;
          }
          break;
      }

      // b b X X X X b b   b b b b b b b b
      switch ((WORD & 0x3C00) >> 12) {
        // 2-Operand Instructions
        case 1:
          return 8; // CPC
        case 5:
          return 9; // CP
        case 2:
          return 10; // SBC
        case 6:
          return 11; // SUB
        case 3:
          return 12; // ADD
        case 7:
          return 13; // ADC
        case 4:
          return 14; // CPSE
        case 8:
          return 15; // AND
        case 9:
          return 16; // EOR
        case 10:
          return 17; // OR
        case 11:
          return 18; // MOV
      }

      if (((WORD & 0x3000) >> 14) == 3) return 19; // CPI

      break;

    case 1:
      switch ((WORD & 0x3000) >> 14) {
        case 0:
          return 20; // SBCI
        case 1:
          return 21; //SUBI
        case 2:
          return 22; // SBR & ORI
        case 3:
          return 23; // CBD & ANDI
      }
      break;

    case 2:
      // b b X X X X b b   b b b b b b b b
      switch ((WORD & 0x3C00) >> 10) {
        // Load / Store Operations
        case 4:
          switch ((WORD & 0x20F) >> 9) {
            case 0:
              return 24; // LDS
            case 0x200:
              return 25; // STS
          }
          break;
      }
      break;

    case 3:
      break;

    default:
      return 199;
  }

  return 199;
}
