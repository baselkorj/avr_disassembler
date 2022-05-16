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
      return 3; // SEZ
    case 0x9419:
      return 4; // JMP to EIND:Z
    case 0x9428:
      return 5; // SEN
    case 0x9438:
      return 6; // SEV
    case 0x9448:
      return 7; // SES
    case 0x9458:
      return 8; // SEH
    case 0x9468:
      return 9; // SET
    case 0x9478:
      return 10; // SEI
    case 0x9488:
      return 11; // CLC
    case 0x9498:
      return 12; // CLZ
    case 0x94A8:
      return 13; // CLN
    case 0x94B8:
      return 14; // CLV
    case 0x94C8:
      return 15; // CLS
    case 0x94D8:
      return 16; // CLH
    case 0x94E8:
      return 17; // CLT
    case 0x94F8:
      return 18; // CLI
    case 0x9508:
      return 19; // RET
    case 0x9509:
      return 20; // CALL to Z
    case 0x9518:
      return 21; // RETI
    case 0x9519:
      return 22; // CALL to EIND:Z
    case 0x9588:
      return 23; // SLEEP
    case 0x9598:
      return 24; // BREAK
    case 0x95A8:
      return 25; // WDR
    case 0x95C8:
      return 26; // LPM
    case 0x95D8:
      return 27; // ELPM
    case 0x95E8:
      return 28; // SPM
    case 0x95F8:
      return 29; // SPM Z+
  }

  /*-------------------- 2-Operand Instructions -------------------*/
  switch (WORD & 0xFF00) {
    case 0x100:
      return 30; // MOVW Rd,Rr
    case 0x200:
      return 31; // MULS Rd,Rr
  }

  switch (WORD & 0xFF88) {
    case 0x300:
      return 32; // MULSU Rd,Rr
    case 0x308:
      return 33; // FMUL Rd,Rr
    case 0x380:
      return 34; // FMULS Rd,Rr
    case 0x388:
      return 35; // FMULU Rd,Rr
  }

  switch (WORD & 0xFC00) {
    case 0x400:
      return 36; // CPC Rd,Rr
    case 0x1400:
      return 37; // CP Rd,Rr
    case 0x800:
      return 38; // SBC Rd,Rr
    case 0x1800:
      return 39; // SUB Rd,Rr
    case 0xC00:
      return (WORD & 0xF == WORD & 0x1F0) ? 40 : 41; // ADD Rd,Rr | LSL Rd
    case 0x1C00:
      return (WORD & 0xF == WORD & 0x1F0) ? 42 : 43; // ADC Rd,Rr | ROL Rd
    case 0x1000:
      return 44; // CPSE Rd,Rr
    case 0x2000:
      return 45; // AND Rd,Rr
    case 0x2400:
      return 46; // EOR Rd,Rr | CLR if Rd is Rr
    case 0x2800:
      return 47; // OR Rd,Rr
    case 0x2C00:
      return 48; // MOV Rd,Rr
    case 0xF000:
      return 49; // Conditional branch on status register bit
    case 0xF400:
      return 50; // Conditional branch on status register bit
  }

  if (WORD & 0xF000 == 0x3000) return 51; // CPI Rd,K

  /*----------------- Register Immediate Operations ---------------*/
  switch (WORD & 0xF000) {
    case 0x4000:
      return 52; // SBCI Rd,K
    case 0x5000:
      return 53; // SUBI Rd,K
    case 0x6000:
      return 54; // ORI Rd,K | SBR Rd,K
    case 0x7000:
      return 55; // ANDI Rd,K | CBR Rd,K
    case 0x8000 | 0xA000:
      return 56; // LDD Rd through Z+k
  }

  /*-------------------- Load / Store operations ------------------*/
  switch (WORD & 0xD208) {
    case 0x8000:
      return 57; // LDD Rd through Z+k
    case 0x8008:
      return 58; // LDD Rd through Y+k
    case 0x8200:
      return 59; // STD Rd through Z+k
    case 0x8208:
      return 60; // STD Rd through Y+k
  }

  switch (WORD & 0xFE0F) {
    case 0x9000:
      return 61; // LDS rd, i
    case 0x9200:
      return 62; // STS i, rd
    case 0x9001:
      return 63; // LD Rd through Z+
    case 0x9009:
      return 64; // LD Rd through Y+
    case 0x9002:
      return 65; // LD Rd through -Z
    case 0x900A:
      return 66; // LD Rd through -Y
    case 0x900C:
      return 67; // LD Rd through X
    case 0x900D:
      return 68; // LD Rd through X+
    case 0x900E:
      return 69; // LD Rd through -X
    case 0x9201:
      return 70; // ST Rd through Z+
    case 0x9209:
      return 71; // ST Rd through Y+
    case 0x9202:
      return 72; // ST Rd through -Z
    case 0x920A:
      return 73; // ST Rd through -Y
    case 0x920C:
      return 74; // ST Rd through X
    case 0x920D:
      return 75; // ST Rd through X+
    case 0x920E:
      return 76; // ST Rd through -X
    case 0x9004:
      return 77; // LPM Rd, Z
    case 0x9005:
      return 78; // LPM Rd, Z+
    case 0x9006:
      return 79; // ELPM Rd, Z
    case 0x9007:
      return 80; // ELPM Rf, Z+
    case 0x9204:
      return 81; // XCH Z, Rd
    case 0x9205:
      return 82; // LAS Z, Rd
    case 0x9206:
      return 83; // LAC Z, Rd
    case 0x9207:
      return 84; // LAT Z, Rd
    case 0x900F:
      return 85; // POP Rd
    case 0x920F:
      return 86; // PUSH Rd

    /*-------------------- 1-Operand Instructions ------------------*/
    case 0x9400:
      return 87; // COM Rd
    case 0x9401:
      return 88; // NEG Rd
    case 0x9402:
      return 89; // SWAP Rd
    case 0x9403:
      return 90; // INC Rd
    case 0x9405:
      return 91; // ASR Rd
    case 0x9406:
      return 92; // LSR Rd
    case 0x9407:
      return 93; // ROR Rd
    case 0x940A:
      return 94; // DEC Rd
  }

  if (WORD & 0xFF0F == 0xEF0F)
    return 95; // SR Rd
  else if (WORD & 0xFF0F == 0x940B) return 96; // DES round k

  if (WORD & 0xFE0D == 0x940C)
    return 97; // JMP abs22
  else if (WORD & 0xFE0D == 0x940E) return 98; // CALL abs22

  switch (WORD & 0x00FF) {
    case 0x9600:
      return 99; // ADIW Rp, uimm6
    case 0x9700:
      return 100; // SBIW Rp, uimm6
    case 0x9800:
      return 101; // CBI a, b
    case 0x9900:
      return 102; // SBIC a, b
    case 0x9A00:
      return 103; // SBI a, b
    case 0x9B00:
      return 104; // SBIS a, b
  }

  if (WORD & 0x3FF == 0x9C00) return 105; // MUL, unsigned: R1:R0 = Rr × Rd

  switch (WORD & 0x7FF) {
    case 0xB000:
      return 106; // IN to I/O space
    case 0xB800:
      return 107; // OUT to I/O space
  }

  switch (WORD & 0x0FFF) {
    case 0xC000:
      return 108; // RJMP to PC + simm12
    case 0xD000:
      return 109; // RCALL to PC + simm12
    case 0xE000:
      return 110; // LDI Rd,K
  }

  switch (WORD & 0xFE08) {
    case 0xF800:
      return 111; // BLD register bit to STATUS.T
    case 0xFA00:
      return 112; // BST register bit to STATUS.T
    case 0xFC00:
      return 113; // SBRC skip if register bit equals B
    case 0xFE00:
      return 114; // SBRS skip if register bit equals B
  }

  return 199;
}
