int decode(int word) {
  /*---------------------- Zero-Operand Instructions ----------------------*/
  switch (word) {
    case 0x0:
      return 0; // NOP
    case 0x9408:
      return 1; // SEC
    case 0x9409:
      return 2; // IJMP
    case 0x9418:
      return 3; // SEZ
    case 0x9419:
      return 4; // EIJMP
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
      return 20; // ICALL
    case 0x9518:
      return 21; // RETI
    case 0x9519:
      return 22; // EICALL
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
  switch (word & 0xFF00) {
    case 0x100:
      return 30; // MOVW Rd,Rr
    case 0x200:
      return 31; // MULS Rd,Rr
  }

  switch (word & 0xFF88) {
    case 0x300:
      return 32; // MULSU Rd,Rr
    case 0x308:
      return 33; // FMUL Rd,Rr
    case 0x380:
      return 34; // FMULS Rd,Rr
    case 0x388:
      return 35; // FMULSU Rd,Rr
  }

  switch (word & 0xFC00) {
    case 0x400:
      return 36; // CPC Rd,Rr
    case 0x1400:
      return 37; // CP Rd,Rr
    case 0x800:
      return 38; // SBC Rd,Rr
    case 0x1800:
      return 39; // SUB Rd,Rr
    case 0xC00:
      return (word & 0xF == word & 0x1F0) ? 40 : 41; // ADD Rd,Rr | LSL Rd
    case 0x1C00:
      return (word & 0xF == word & 0x1F0) ? 42 : 43; // ADC Rd,Rr | ROL Rd
    case 0x1000:
      return 44; // CPSE Rd,Rr
    case 0x2000:
      return 45; // AND Rd,Rr | TST if Rd == Rr
    case 0x2400:
      return 46; // EOR Rd,Rr | CLR if Rd is Rr
    case 0x2800:
      return 47; // OR Rd,Rr
    case 0x2C00:
      return 48; // MOV Rd,Rr
    case 0xF000:
      return 49; // BRBS s,k
    case 0xF400:
      return 50; // BRBC s,k
  }

  if (word & 0xF000 == 0x3000) return 51; // CPI Rd,K

  /*----------------- Register Immediate Operations ---------------*/
  switch (word & 0xF000) {
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
  switch (word & 0xD208) {
    case 0x8000:
      return 57; // LDD Rd through Z+k
    case 0x8008:
      return 58; // LDD Rd through Y+k
    case 0x8200:
      return 59; // STD Rd through Z+k
    case 0x8208:
      return 60; // STD Rd through Y+k
  }

  switch (word & 0xFE0F) {
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

  if (word & 0xFF0F == 0xEF0F)
    return 95; // SER Rd
  else if (word & 0xFF0F == 0x940B) return 96; // DES round k

  if (word & 0xFE0D == 0x940C)
    return 97; // JMP abs22
  else if (word & 0xFE0D == 0x940E) return 98; // CALL abs22

  switch (word & 0x00FF) {
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

  if (word & 0x3FF == 0x9C00) return 105; // MUL, unsigned: R1:R0 = Rr × Rd

  switch (word & 0x7FF) {
    case 0xB000:
      return 106; // IN Rd, A
    case 0xB800:
      return 107; // OUT Rd, A
  }

  switch (word & 0x0FFF) {
    case 0xC000:
      return 108; // RJMP to PC + simm12
    case 0xD000:
      return 109; // RCALL to PC + simm12
    case 0xE000:
      return 110; // LDI Rd,K
  }

  switch (word & 0xFE08) {
    case 0xF800:
      return 111; // BLD register bit to STATUS.T
    case 0xFA00:
      return 112; // BST register bit to STATUS.T
    case 0xFC00:
      return 113; // SBRC skip if register bit equals B
    case 0xFE00:
      return 114; // SBRS skip if register bit equals B
  }

  switch (word & 0xFF8F) {
    case 0x9408:
      return 115; // BSET s
    case 0x9488:
      return 115; // BCLR s
  }

  switch (word & 0xFC07) {
    case 0xF000:
      return 114; // BRCS k | BRLO k , after CP, CPI, SUB, or SUBI
    case 0xF001:
      return 115; // BREQ k
    case 0xF002:
      return 116; // BRMI k
    case 0xF003:
      return 117; // BRVS k
    case 0xF004:
      return 118;
    case 0xF005:
      return 119; // BRHS
    case 0xF006:
      return 121; // BRTS k
    case 0xF007:
      return 122; // BRIE k
    case 0xF400:
      return 123; // BRCC k | BRSH k , after CP, CPI, SUB, or SUBI
    case 0xF401:
      return 124; // BRNE k
    case 0xF402:
      return 125; // BRPL k
    case 0xF403:
      return 126; // BRVC k
    case 0xF404:
      return 127; // BRGE k
    case 0xF405:
      return 128; // BRHC k
    case 0xF406:
      return 129; // BRTC k
    case 0xF407:
      return 130; // BRID k
  }

  return 199;
}
