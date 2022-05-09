# An AVR Disassembler Written in Dart
This repo houses the AVR Disassembler that is going to be used in [Toroidal Accelerator](https://github.com/baselkorj/toroidal_accelerator) for the simulation of devices using under the AVR architecture. The objectives of this project are to:
1. Decode AVR instructions by iterating through an assembled HEX file or WORD for WORD when called by Toroidal Accelerator.
2. Generate a FILE containing the disassembled program to be displayed by Toroidal Accelerator.
3. Provide a command-line interface for independent use and for debugging purposes + planned syntax highlighting.
