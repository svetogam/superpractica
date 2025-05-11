# [Super Practica](https://superpractica.org) Changelog

## About

* This changelog documents changes that are notable to players.
* Greater version increases indicate completion of major new content, features, and aesthetic theming.
* Smaller version increases indicate partial completion and other improvements.
* There may be more features and content in "debug levels", but they will be ignored and counted as removed here.
* For plans for upcoming releases, see the [Roadmap](https://superpractica.org/resources/roadmap). (The changelog of the future!)


## v0.8.0 - Initial Player-Facing Demo - Unreleased

### Summary

The game is finally "presentable" with graphics, icons, animations, transitions, and screen layouts. Main menu info section is expanded to include credits and licenses.

Thanks to [Kenney](https://www.kenney.nl/assets/ui-pack) and [Phosphor Icons](https://phosphoricons.com/) for graphical assets.


### Content

#### Grid-Counting Pim

* Improved playability
    * New action icons
    * Improved object icons
    * Prefiguration for marking cells


### Core

* Limit screen-size to between 800x600 and 1280x800

* Improved GUI
    * Simple graphics replacing default Godot graphics
    * New and improved icons for buttons
    * Tooltips for icon-only buttons


#### Pimnet Level

* Redesign layout and graphics
    * Screen space is used better so that nothing overlaps
    * Improved condition-verification goal panel
    * Improved solution-slots goal panel
    * Level-completion animation to give a sense of finality
    * New background

* Improved verification and other animations
    * Better number graphics
    * More signals making verification easier to follow
    * Animations are overall smoother and more communicative

* Memo slots have more communicative signifiers

* Removed plan panel


#### Level Select

* Smooth transitions
    * Cutless transitions entering/exiting topics
    * Cutless transitions entering/exiting levels
    * New overlay transitions

* Improved playability
    * Signifiers for completed/suggested/unsuggested levels
    * Signifiers for hovering over a node to zoom into it
    * Signifiers for hovering over a zoomed-in node to enter it or zoom out

* Graphical redesign
    * 2 new backgrounds
    * Connectors and groups look nicer
    * Level nodes have icons instead of titles
    * Level groups have icons
    * Topic nodes show less information to accomodate longer titles


#### Main Menu

* Redesign layout and graphics
    * New background
    * Nice layouts

* More Info pages
    * Credits Page
    * Licenses Page for viewing game and engine licenses

* Show version next to title


## [v0.7.2] - Pre-Player-Facing Demo 3 - 2024-12-23

### Summary

The main features and level progression for the Grid-Counting pim are complete.


### Content

#### Added

* Grid-Counting Levels: Intro group
* Grid-Counting Levels: Group 2
* Grid-Counting Levels: Group 4
* Grid-Counting Pim: New blocks of sizes 2, 3, 4, 5, 20, 30, 40, and 50

#### Changed

* Grid-Counting Pim: Toolset is simplified.


### Core Features

#### Added

* "Hard-Constraint" mechanics and signals
    * Can be seen in Grid-Counting-Intro levels.
    * Back after being cut in v0.7.0.
* "Construct Conditions" goal
    * Can be seen in Grid-Counting-2 levels.
* "Prefiguration" signals for dragging objects


### Aesthetic

#### Changed

* Grid-Counting Pim: Graphics are slightly different and more consistent.
* Pim signals are no longer cut off by pim boundaries.
* Icons are smaller in the Create Objects panel to fit more objects.


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


[v0.7.2]: https://codeberg.org/superpractica/superpractica/releases/tag/v0.7.2
[v0.7.1]: https://codeberg.org/superpractica/superpractica/releases/tag/v0.7.1
[v0.7.0]: https://codeberg.org/superpractica/superpractica/releases/tag/v0.7.0
[v0.6.0]: https://codeberg.org/superpractica/superpractica/releases/tag/v0.6.0
