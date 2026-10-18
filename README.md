# Basic Calculator
Written in `x86_64` Assembly (linux only, no libc)

### Demo
![demo](assets/iamgay.gif)

### Features (not many, but still something ig)
- ops: `+` `-` `*` `/`
- checks for invalid op, invalid digits, empty input, negative output, divide by zero, `u64` overflow

### Build
after cloning it
```bash
make # uses nasm
make clean
```

### Usage
its just `./calc-in-asm` :3

### Limitations
too lazy to fix these rn.

- range: `u64` only
- no foats
- no negative input/output