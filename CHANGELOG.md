# Changelog

All notable changes to this project will be documented in this file.

This changelog is written for players rather than for developers. Greater version increases indicate completion of major new content, features, and aesthetic theming. Smaller version increases indicate other improvements and partial completion.

Content may stick around or be prepared in "debug levels", but will be considered as removed or as not yet added here.

For plans for upcoming releases, see the [Roadmap](https://superpractica.org/resources/roadmap).


## [v0.7.0] - Pre-Player-Facing Demo 1 - 2024-07-29

### Summary

The primary interface and level-selection screen are redesigned, but content is cut to only a few levels.


### Content

#### Added

* Grid-counting level set 1

#### Changed

* Grid-counting pim
    * It now revolves around placing things on the grid rather than circling numbers.

#### Removed

* The main line of levels from v0.6.0
    * You can still find sets 1 and 5 out of 8 in debug levels.
* Pie-slicer pim and levels
* Bubble-sum pim
    * You can still find it in a broken state in debug levels.


### Features

#### Added

* Simple main menu
* "Multiscopic" level-selection screen, replacing the old debug level-selection screen
* "Fill goal slot" goal mechanic

#### Changed

* The primary "pimnet" interface has been completely redesigned

#### Removed

* Verification system
    * This will come back in a redesigned form in later levels.


### Aesthetic

#### Changed

* Base resolution is now 800x600 (from 1280x800)
* The GUI theme is now Godot 4's default theme (from Godot 3's default theme)


## [v0.6.0] - Proof-of-Concept Demo - 2023-10-16

### Summary

This demo is only a proof of concept. Its purpose is to test some ideas, clarify some parts of the design, and build functional code architecture before continuing on to making a real demo.


[v0.7.0]: https://codeberg.org/superpractica/superpractica/releases/tag/v0.7.0
[v0.6.0]: https://codeberg.org/superpractica/superpractica/releases/tag/v0.6.0
