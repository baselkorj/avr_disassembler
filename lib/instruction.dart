int decode(int WORD) {
  // X X b b b b b b   b b b b b b b b
  switch ((WORD & 0xC000) >> 14) {
    case 0x0:
      // 0 0 X X b b b b   b b b b b b b b
      switch ((WORD & 0x3000) >> 14) {
        case 0x0:
          // 0 0 0 0 X X b b   b b b b b b b b
          switch ((WORD & 0xC00) >> 12) {
            // Base Instructions
            case 0x0:
              switch ((WORD & 0x300) >> 12) {
                case 0x0:
                  return 1; // NOP
                case 0x1:
                  return 2; // MOVW Rd,Rr
                case 0x2:
                  return 3; // MULS Rd,Rr
                case 0x3:
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
        case 0x1:
          return 8; // CPC Rd,Rr
        case 0x5:
          return 9; // CP Rd,Rr
        case 0x2:
          return 10; // SBC Rd,Rr
        case 0x6:
          return 11; // SUB Rd,Rr
        case 0x3:
          return (WORD & 0xF == WORD & 0x1F0) ? 12 : 13; // ADD Rd,Rr | LSL Rd
        case 0x7:
          return (WORD & 0xF == WORD & 0x1F0) ? 14 : 15; // ADC Rd,Rr | ROL Rd
        case 0x4:
          return 16; // CPSE Rd,Rr
        case 0x8:
          return 17; // AND Rd,Rr
        case 0x9:
          return 18; // EOR Rd,Rr
        case 0xA:
          return 19; // OR Rd,Rr
        case 0xB:
          return 20; // MOV Rd,Rr
        default:
          return 21; // CPI Rd,K
      }

    case 0x1:
      // Register-Immediate Operations
      switch ((WORD & 0x3000) >> 14) {
        case 0x0:
          return 20; // SBCI | Rd,K
        case 0x1:
          return 21; //SUBI | Rd,K
        case 0x2:
          return 22; // SBR & ORI | Rd, K
        case 0x3:
          return 23; // CBD & ANDI | Rd,K
      }
      break;

    case 0x2:
      // 1 0 X X X X b b   b b b b b b b b
      switch ((WORD & 0x3C00) >> 10) {
        case 0x4:
          // 1 0 b b b b X b   b b b b X X X X
          // Load / Store Operations
          switch ((WORD & 0x20F) >> 9) {
            case 0x0:
              return 24; // LDS
            case 0x200:
              return 25; // STS
            case 0x1:
              return 26; // LD Rd through Z+
            case 0x201:
              return 27; // ST Rd through Z+
            case 0x9:
              return 28; // LD Rd through Y+
            case 0x209:
              return 29; // ST Rd through Y+
            case 0x2:
              return 30; // LD Rd through Z-
            case 0x202:
              return 31; // ST Rd through Z-
            case 0xA:
              return 32; // LD Rd through Y-
            case 0x20A:
              return 33; // ST Rd through Y-
            case 0x4:
              return 34; // LPM Rd, Z
            case 0x6:
              return 35; // ELPM Rd, Z
            case 0x5:
              return 36; // LPM Rd, Z+
            case 0x7:
              return 37; // ELPM Rd, Z+
            case 0x204:
              return 38; // XCH Z, Rd
            case 0x205:
              return 39; // LAS Z, Rd
            case 0x206:
              return 40; // LAC Z, Rd
            case 0x207:
              return 41; // LAT Z, Rd
            case 0xC:
              return 42; // LD Rd through X
            case 0x20C:
              return 43; // ST Rd through X
            case 0xD:
              return 44; // LD Rd through X+
            case 0x20D:
              return 45; // ST Rd through X+
            case 0xE:
              return 46; // LD Rd through X-
            case 0x20E:
              return 47; // ST Rd through X-
            case 0xF:
              return 48; // POP Rd
            case 0x20F:
              return 48; // PUSH Rd
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

int docode_V2(int WORD) {
  /*---------------------- Base Instructions ----------------------*/
  if (WORD == 0) return 0; // NOP

  switch (WORD & 0xFF00) {
    case 0x100:
      return 1; // MOVW Rd,Rr
    case 0x200:
      return 2; // MULS Rd,Rr
  }

  switch (WORD & 0xFF88) {
    case 0x300:
      return 3; // MULSU Rd,Rr
    case 0x308:
      return 4; // FMUL Rd,Rr
    case 0x380:
      return 5; // FMULS Rd,Rr
    case 0x388:
      return 6; // FMULU Rd,Rr
  }

  /*-------------------- 2-Operand Instructions -------------------*/
  switch (WORD & 0xFC00) {
    case 0x400:
      return 7; // CPC Rd,Rr
    case 0x1400:
      return 8; // CP Rd,Rr
    case 0x800:
      return 9; // SBC Rd,Rr
    case 0x1800:
      return 10; // SUB Rd,Rr
    case 0xC00:
      return (WORD & 0xF == WORD & 0x1F0) ? 11 : 12; // ADD Rd,Rr | LSL Rd
    case 0x1C00:
      return (WORD & 0xF == WORD & 0x1F0) ? 13 : 14; // ADC Rd,Rr | ROL Rd
    case 0x1000:
      return 15; // CPSE Rd,Rr
    case 0x2000:
      return 16; // AND Rd,Rr
    case 0x2400:
      return 17; // EOR Rd,Rr
    case 0x2800:
      return 18; // OR Rd,Rr
    case 0x2C00:
      return 19; // MOV Rd,Rr
  }

  if (WORD & 0xF000 == 0x3000) return 20; // CPI Rd,K

  /*----------------- Register Immediate Operations ---------------*/
  switch (WORD & 0xF000) {
    case 0x4000:
      return 21; // SBCI Rd,K
    case 0x5000:
      return 22; // SUBI Rd,K
    case 0x6000:
      return 23; // ORI Rd,K | SBR Rd,K
    case 0x7000:
      return 24; // ANDI Rd,K | CBR Rd,K
    case 0x8000 | 0xA000:
      return 25; // LDD Rd through Z+k
  }

  switch (WORD & 0xD208) {
    case 0x8000:
      return 26; // LDD Rd through Z+k
    case 0x8008:
      return 27; // LDD Rd through Y+k
    case 0x8200:
      return 28; // STD Rd through Z+k
    case 0x8208:
      return 29; // STD Rd through Y+k
  }

  /*-------------------- Load / Store operations ------------------*/

  return 199;
}
