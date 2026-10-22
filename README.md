# ICS Text Graphics System

Integrated Computer Systems group assignment.

## Project Idea

This project is a parameter-driven text-based graphics system.

The system will be implemented in:

- NASM x86-64 Assembly Language
- Python

The user will select a shape from a common menu and enter one or more parameters such as height, width, or size.

The program will generate the selected shape dynamically using loops, conditions, registers, memory, and system calls rather than displaying fixed ASCII art.

## Shapes

1. Pyramid - parameter: height
2. Rectangle - parameters: width and height
3. Triangle - parameter: height
4. Diamond - parameter: size
5. X Shape - parameter: size
6. Exit

## Technical Environment

Assembly version:

- Architecture: x86-64
- Assembler: NASM
- Operating System: Ubuntu Linux
- Syntax: NASM syntax

High-level version:

- Python

## Group Workflow

Each member is responsible for:

- One Assembly shape
- The equivalent Python shape
- Testing their own implementation
- Providing screenshots and evidence
- Contributing to documentation and presentation

All shapes will later be integrated into one common program.

## Important Rule

Do not develop directly on the `main` branch.

Each member will work on their own branch first. Code will be tested before it is merged into `main`.



## How to Run

Assembly version

nasm -f elf64 assembly/main.asm -o assembly/main.o

ld assembly/main.o -o assembly/main

./assembly/main


Python version

python3 python/main.py
