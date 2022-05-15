import 'dart:html';

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
  /*---------------------- Zero-Operand Instructions ----------------------*/
  switch (WORD) {
    case 0x0:
      return 0; // NOP
    case 0x9408:
      return 1; // SEC
    case 0x9409:
      return 2; // JMP to Z
    case 0x9418:
      return 2; // SEZ
    case 0x9419:
      return 3; // JMP to EIND:Z
    case 0x9428:
      return 2; // SEN
    case 0x9438:
      return 5; // SEV
    case 0x9448:
      return 3; // SES
    case 0x9458:
      return 2; // SEH
    case 0x9468:
      return 4; // SET
    case 0x9478:
      return 3; // SEI
    case 0x9488:
      return 1; // CLC
    case 0x9498:
      return 2; // CLZ
    case 0x94A8:
      return 4; // CLN
    case 0x94B8:
      return 5; // CLV
    case 0x94C8:
      return 5; // CLS
    case 0x94D8:
      return 2; // CLH
    case 0x94E8:
      return 6; // CLT
    case 0x94F8:
      return 3; // CLI
    case 0x9508:
      return 1; // RET
    case 0x9509:
      return 0; // CALL to Z
    case 0x9518:
      return 2; // RETI
    case 0x9519:
      return 1; // CALL to EIND:Z
    case 0x9588:
      return 3; // SLEEP
    case 0x9598:
      return 4; // BREAK
    case 0x95A8:
      return 5; // WDR
    case 0x95C8:
      return 6; // LPM
    case 0x95D8:
      return 7; // ELPM
    case 0x95E8:
      return 8; // SPM
    case 0x95F8:
      return 9; // SPM Z+
  }

  /*-------------------- 2-Operand Instructions -------------------*/
  switch (WORD & 0xFF00) {
    case 0x100:
      return 10; // MOVW Rd,Rr
    case 0x200:
      return 11; // MULS Rd,Rr
  }

  switch (WORD & 0xFF88) {
    case 0x300:
      return 12; // MULSU Rd,Rr
    case 0x308:
      return 13; // FMUL Rd,Rr
    case 0x380:
      return 14; // FMULS Rd,Rr
    case 0x388:
      return 15; // FMULU Rd,Rr
  }

  switch (WORD & 0xFC00) {
    case 0x400:
      return 16; // CPC Rd,Rr
    case 0x1400:
      return 17; // CP Rd,Rr
    case 0x800:
      return 18; // SBC Rd,Rr
    case 0x1800:
      return 19; // SUB Rd,Rr
    case 0xC00:
      return (WORD & 0xF == WORD & 0x1F0) ? 20 : 21; // ADD Rd,Rr | LSL Rd
    case 0x1C00:
      return (WORD & 0xF == WORD & 0x1F0) ? 22 : 23; // ADC Rd,Rr | ROL Rd
    case 0x1000:
      return 24; // CPSE Rd,Rr
    case 0x2000:
      return 25; // AND Rd,Rr
    case 0x2400:
      return 26; // EOR Rd,Rr | CLR if Rd is Rr
    case 0x2800:
      return 27; // OR Rd,Rr
    case 0x2C00:
      return 28; // MOV Rd,Rr
  }

  if (WORD & 0xF000 == 0x3000) return 29; // CPI Rd,K

  /*----------------- Register Immediate Operations ---------------*/
  switch (WORD & 0xF000) {
    case 0x4000:
      return 30; // SBCI Rd,K
    case 0x5000:
      return 31; // SUBI Rd,K
    case 0x6000:
      return 32; // ORI Rd,K | SBR Rd,K
    case 0x7000:
      return 33; // ANDI Rd,K | CBR Rd,K
    case 0x8000 | 0xA000:
      return 34; // LDD Rd through Z+k
  }

  /*-------------------- Load / Store operations ------------------*/
  switch (WORD & 0xD208) {
    case 0x8000:
      return 35; // LDD Rd through Z+k
    case 0x8008:
      return 36; // LDD Rd through Y+k
    case 0x8200:
      return 37; // STD Rd through Z+k
    case 0x8208:
      return 38; // STD Rd through Y+k
  }

  switch (WORD & 0xFE0F) {
    case 0x9000:
      return 39; // LDS rd, i
    case 0x9200:
      return 40; // STS i, rd
    case 0x9001:
      return 41; // LD Rd through Z+
    case 0x9009:
      return 42; // LD Rd through Y+
    case 0x9002:
      return 43; // LD Rd through -Z
    case 0x900A:
      return 44; // LD Rd through -Y
    case 0x900C:
      return 45; // LD Rd through X
    case 0x900D:
      return 46; // LD Rd through X+
    case 0x900E:
      return 47; // LD Rd through -X
    case 0x9201:
      return 48; // ST Rd through Z+
    case 0x9209:
      return 49; // ST Rd through Y+
    case 0x9202:
      return 50; // ST Rd through -Z
    case 0x920A:
      return 51; // ST Rd through -Y
    case 0x920C:
      return 52; // ST Rd through X
    case 0x920D:
      return 53; // ST Rd through X+
    case 0x920E:
      return 54; // ST Rd through -X
    case 0x9004:
      return 55; // LPM Rd, Z
    case 0x9005:
      return 56; // LPM Rd, Z+
    case 0x9006:
      return 57; // ELPM Rd, Z
    case 0x9007:
      return 58; // ELPM Rf, Z+
    case 0x9204:
      return 59; // XCH Z, Rd
    case 0x9205:
      return 60; // LAS Z, Rd
    case 0x9206:
      return 61; // LAC Z, Rd
    case 0x9207:
      return 62; // LAT Z, Rd
    case 0x900F:
      return 63; // POP Rd
    case 0x920F:
      return 64; // PUSH Rd

    /*-------------------- 1-Operand Instructions ------------------*/
    case 0x9400:
      return 65; // COM Rd
    case 0x9401:
      return 66; // NEG Rd
    case 0x9402:
      return 67; // SWAP Rd
    case 0x9403:
      return 68; // INC Rd
    case 0x9405:
      return 69; // ASR Rd
    case 0x9406:
      return 70; // LSR Rd
    case 0x9407:
      return 71; // ROR Rd
  }

  if (WORD & 0xFF0F == 0xEF0F) return 67; // SR Rd

  return 199;
}
