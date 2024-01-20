# 📦 Package Resolved for Playdate

It's another day at the Swifty Package Factory, and you have a long list
of orders to deliver, with no time to spare! Can you collect all of the
packages to deliver in the time allotted? Watch out for palettes and wet
floors, or you'll get really injured!

> **Package Resolved** is a short game written using the Playdate SDK in
> C, originating from the Godot-based game of the same title for the 132nd
> Trijam.

## 🏗️ Build instructions

**Required Tools**
- Make
- Clang (on macOS) or GCC
- Playdate SDK 2.1.0 or later
- (if using Nova) [Playdate extension][nova-ext]

[nova-ext]: nova://extension/?id=com.panic.Playdate&name=Playdate

### Nova

Start by cloning this repository via `git clone`, then open the project in
Nova. Select the "Game (Simulator)" task and run the project, which will
create the PDX file and open the game in the Playdate Simulator.

### Command line 

Start by cloning this repository via `git clone`, then run the following
commands in the terminal for Make:

```
make
```

More information can be found on [Playdate's documentation to build via the command line][pdbuild].

[pdbuild]: https://sdk.play.date/inside-playdate-with-c/#_make

To build and run the unit tests, run the following:

```
make test
./test/test_app
```