# ALFA Compiler

The ALFA Compiler is a project that translates programs written in the ALFA programming language into NASM assembly language. It utilizes the C programming language along with the Flex and Bison libraries to create morphological, syntactic, and semantic analyzers.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Usage](#usage)
- [Installation](#installation)
- [Contributing](#contributing)
- [License](#license)

## Introduction

The Alpha language, initially proposed by Edgar F. Codd, the pioneer of the relational database concept, served as the original database language. It was formally introduced in Codd's 1971 paper titled "A Data Base Sublanguage Founded on the Relational Calculus." Alpha had a significant impact on the development of QUEL. However, it was later replaced by SQL, which was based on Codd's relational algebra as defined in his work "Relational Completeness of Data Base Sublanguages." IBM adopted SQL for its first commercial relational database product.

ALFA Compiler provides a way to convert ALFA source code into NASM assembly language, making it suitable for further compilation and execution on various systems. This README provides an overview of the project, its features, and instructions on how to use and contribute to it.

## Features

The ALFA Compiler project offers the following features:

- **ALFA to NASM Compilation**: It allows you to translate programs written in the ALFA programming language into NASM assembly language.

- **Comprehensive Analysis**: The project employs Flex and Bison libraries to create morphological, syntactic, and semantic analyzers for accurate compilation.

## Usage

To use the ALFA Compiler, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/alfa-compiler.git
   ```

2. Navigate to the project directory:
   ```bash
   cd alfa-compiler
   ```

3. Build the compiler:
   ```bash
   make
   ```

4. Compile an ALFA program:
   ```bash
   ./alfa-compiler input.alfa output.asm
   ```

5. You will now have the NASM assembly code in the `output.asm` file, which can be further processed and executed.

## Installation

To install the ALFA Compiler, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/alfa-compiler.git
   ```

2. Navigate to the project directory:
   ```bash
   cd alfa-compiler
   ```

3. Build the compiler:
   ```bash
   make install
   ```

4. The ALFA Compiler will be installed on your system and available for use.


## License

This project is licensed under the [MIT License](LICENSE).

---

Feel free to modify and expand this README to suit the specific details of your ALFA Compiler project.
