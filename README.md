# SwiftCTime

SwiftCTime is a little command-line tool to show compile time of swift file.

### Install

You need Swift Package Manager (as well as swift compiler) installed in your macOS, generally you are prepared if you have the latest Xcode installed.

#### Compile from source

```bash
> git clone https://github.com/atuooo/SwiftCTime.git
> cd SwiftCTime
> ./install.sh
```

### Usage

Just navigate to your swift file folder, then:

```shell
> swiftctime
or
> swiftctime test.swift
```

Output:

```shell
============== test.swift ==============
35.23ms  <3:6>  - func dicFuncA() -> Dictionary<String, Any>
0.38ms   <12:6> - func dicFuncB() -> Dictionary<String, Any>
```

More Options:

```shell
> swiftctime --help

Usage: swiftctime [options]
  -p, --path:
      Path of file or directory you want to compile. Default is current folder.
  -s, --sort:
      Sort fuction by compile time in descending order.
  -l, --location:
      Show location of function in file
  -v, --version:
      Print version.
  -h, --help:
      Print this help message.
```
