# Kernel-based Application and Networking Operating System

<p align="center">
  <img src="./logo.webp" height="100" alt="Vue-Paho-Mqtt-Logo" />
</p>

Using this repository for learning purposes. The goal is to create an operating system that is specilized for web application usage in any way. Currently it is used for keeping track of my learning progress.

## Usage

Clean the run.bin

```bash
make clean
```

Run the command: nasm -f bin $(ASM_FILE) -o run.bin

```bash
make
```

start the run.bin file with qemu-system-x86_64

```bash
make run
```

## Documentation

You can find the documentation/explenation for the code ([boot.asm](./boot.asm)) [here](./docs/boot_asm.md).

## License

kaanOS is licensed under the [MIT License](LICENSE).
