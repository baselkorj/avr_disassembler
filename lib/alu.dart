import 'registers.dart';

void add(Rd, Rr) {
  fileRegister[Rd] = Rd + Rr;
}

void adc(Rd, Rr) {}
