int decode(int WORD) {
  // X X b b b b b b   b b b b b b b b
  switch ((WORD & 0xC000) >> 14) {
    case 0:
      // 0 0 X X b b b b   b b b b b b b b
      switch ((WORD & 0x3000) >> 14) {
        case 0:
          // 0 0 0 0 X X b b   b b b b b b b b
          switch ((WORD & 0xC00) >> 12) {
            // Base Instructions
            case 0:
              switch ((WORD & 0x300) >> 12) {
                case 0:
                  return 1; // NOP
                case 1:
                  return 2; // MOVW Rd,Rr
                case 2:
                  return 3; // MULS Rd,Rr
                case 3:
                  if (WORD & 0x80 == 0) {
                    return WORD & 0x8 == 0 ? 4 : 5; // MULSU Rd,Rr | FMUL Rd,Rr
                  } else {
                    return WORD & 0x8 == 0 ? 6 : 7; // FMULS Rd,Rr | FMULU Rd,Rr
                  }
              }
              break;
          }
          break;
      }

      // 0 0 X X X X b b   b b b b b b b b
      switch ((WORD & 0x3C00) >> 12) {
        // 2-Operand Instructions
        case 1:
          return 8; // CPC Rd,Rr
        case 5:
          return 9; // CP Rd,Rr
        case 2:
          return 10; // SBC Rd,Rr
        case 6:
          return 11; // SUB Rd,Rr
        case 3:
          return (WORD & 0xF == WORD & 0x1F0) ? 12 : 13; // ADD Rd,Rr | LSL Rd
        case 7:
          return (WORD & 0xF == WORD & 0x1F0) ? 14 : 15; // ADC Rd,Rr | ROL Rd
        case 4:
          return 16; // CPSE Rd,Rr
        case 8:
          return 17; // AND Rd,Rr
        case 9:
          return 18; // EOR Rd,Rr
        case 10:
          return 19; // OR Rd,Rr
        case 11:
          return 20; // MOV Rd,Rr
        default:
          return 21; // CPI Rd,K
      }

    case 1:
      // Register-Immediate Operations
      switch ((WORD & 0x3000) >> 14) {
        case 0:
          return 20; // SBCI | Rd,K
        case 1:
          return 21; //SUBI | Rd,K
        case 2:
          return 22; // SBR & ORI | Rd, K
        case 3:
          return 23; // CBD & ANDI | Rd,K
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

        default:
          if ((WORD & 0x5000) >> 12 == 0) {
            return (WORD & 0x200) == 0
                ? (WORD & 0x8) == 0
                    ? 24 // LDD
                    : 25
                : (WORD & 0x8) == 0
                    ? 26
                    : 27;
          }
      }
      break;

    case 3:
      break;

    default:
      return 199;
  }

  return 199;
}
