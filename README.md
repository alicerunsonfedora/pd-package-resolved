# 📦 Package Resolved for Playdate

It's another day at the Swifty Package Factory, and you have a long list
of orders to deliver, with no time to spare! Can you collect all of the
packages to deliver in the time allotted? Watch out for palettes and wet
floors, or you'll get really injured!

> **Package Resolved** is a short game written using the Playdate SDK in
> C, originating from the Godot-based game of the same title for the 132nd
> Trijam.

![GIF of current gameplay of Package Resolved](gameplay.gif)

## 🏗️ Build instructions

> **Important**  
> Package Resolved utilizes the Swift toolchain for building and running the
> game. Some parts of the game or the toolchain may not work as expected due
> to the unstable nature of Swift Embedded as of this time.

**Required Tools**
- Make
- Swift toolchain (v6.0 or later)*
- Playdate SDK
- (For Linux, Windows via WSL) GNU Arm Embedded Toolchain (arm-gcc-none-eabi)

> \*At the time of writing, the Swift 6 toolchain is the latest nightly
> toolchain.

Start by cloning the repository and the PlaydateKit package:

```
git clone https://github.com/alicerunsonfedora/PlaydateKit
git clone https://gitlab.com/marquiskurt/pd-package-resolved PackageResolved
```

It should be organized as follows:

```
your-path/
    PlaydateKit/
    PackageResolved/
```

You may need to edit the `gccIncludePath` located in Package.swift to pick
up your Arm Embedded Toolchain libraries. In most cases, this shouldn't be
necessary.

You should be able to build for the device by running `make device`.

### Running Charolette Unit Tests

To run the unit tests for the Charolette library, be sure to make a symbolic
link called `CharoletteStandard`:

```
ln -s /your/path/to/PackageResolved/Sources/Charolette /your/path/to/PackageResolved/Sources/CharoletteStandard
```

Then run `swift test -c release` to run the unit tests for the package.

### Additional Instructions for WSL Users

You may wish to write your code on a Windows system. As the Playdate SDK
does not support using the Make build system, you can utilize the Windows
Subsystem for Linux feature to use a Linux virtual machine. The following
includes some helpful tips to get the project running:

- You may want to install the GNU Arm Embedded Toolchain via `apt` rather
  than downloading from the ARM developer website directly.
- Make sure to include the Swift 6 toolchain in your PATH, so that Swift
  can be detected.
- For the best development experience, you may want to use Visual Studio
  Code with the WSL extension to connect to your Linux virtual machine.

## License

Package Resolved itself is licensed under the Mozilla Public License, v2.