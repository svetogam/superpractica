# [Super Practica](https://superpractica.org) Changelog

## About

* This changelog documents changes that are notable to players.
* Greater version increases indicate completion of major new content, features, and aesthetic theming.
* Smaller version increases indicate partial completion and other improvements.
* There may be more features and content in "debug levels", but they will be ignored and counted as removed here.
* For plans for upcoming releases, see the [Roadmap](https://superpractica.org/resources/roadmap). (The changelog of the future!)


## [Unreleased] - Pre-Player-Facing Demo 3

### Summary

The main progression of grid-counting levels from beginning to end is complete, together with the grid-counting pim's most important features.


### Content

#### Added

* Grid-counting: intro level set
* Grid-counting: level set 2
* Grid-counting: level set 4


### Features

#### Added

* Grid-counting: New blocks of sizes 2, 3, 4, 5, 20, 30, 40, and 50
* "Hard-constraint" rejection mechanics (in intro level set)
    * Back after being cut in v0.7.0.
* "Construct conditions" goal mechanic (in level set 2)
* "Prefigurations" for dragging objects

#### Removed

* Grid-counting: Unnecessary tools are merged or removed


### Aesthetic

#### Changed

* Grid-counting: Graphics are modified with better consistency
* Effects including warnings no longer get cut off by pim boundaries
* Icons are smaller in Create Objects panel to fit more objects


## [v0.7.1] - Pre-Player-Facing Demo 2 - 2024-09-30

### Summary

New levels using an improved verification system.


### Content

#### Added

* Grid-counting level set 3


### Features

#### Added

* Verification system
    * It's back in a new form after being cut.
* "Contextual goal slot" goal mechanic
* "Next Level" button finally works


### Aesthetic

#### Changed

* A few buttons have added or improved icons


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
* Pie-slicer pim and levels
* Bubble-sum pim


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


[Unreleased]: https://codeberg.org/superpractica/superpractica
[v0.7.1]: https://codeberg.org/superpractica/superpractica/releases/tag/v0.7.1
[v0.7.0]: https://codeberg.org/superpractica/superpractica/releases/tag/v0.7.0
[v0.6.0]: https://codeberg.org/superpractica/superpractica/releases/tag/v0.6.0
