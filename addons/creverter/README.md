# Composite Reverter

## Overview

The Composite Reverter (CReverter) is a [memento-based](https://en.wikipedia.org/wiki/Memento_pattern) undo/redo utility for [Godot](https://godotengine.org/). It provides a clean interface to track the history of multiple objects and then to traverse that history via functions like undo and redo.

A unique feature is its support of composition, allowing subsystems to handle their own saving and loading independently of each other while still operating in unison. This enhances decoupling and encapsulation in your code.


## How to Use

### Requirements

This is an addon for [Godot](https://godotengine.org/). Godot must be version 4.0 or later.


### Install

* Option 1: Get it from the [Godot Asset Library](https://godotengine.org/asset-library/asset) through the Godot editor.
* Option 2: Download it from the [Releases page](https://codeberg.org/svetogam/creverter/releases) and put the `/creverter/` folder into the `/addons/` folder in your project.


### Quickstart

```
var reverter
var health = 100

func _ready():
	reverter = CReverter.new()
	reverter.connect_save_load(get_instance_id(), _save_func, _load_func)
	reverter.commit()
	%UndoButton.pressed.connect(reverter.undo)
	%RedoButton.pressed.connect(reverter.redo)

func _save_func():
	return {
		"position": position,
		"health": health,
	}

func _load_func(memento):
	position = memento.position
	health = memento.health
```

From here, modify the position or health and commit the change. Then you can undo it with the connected buttons.


### API Reference

Detailed usage information can be found in the API reference, which you can read from inside the Godot editor. To do this, install the CReverter addon, click on Script > Search Help, and search for "creverter".


## Contributing

Contributions, bug reports, requests, and general feedback are welcome. To contribute, first make an issue discussing what you what you want to do.

Any feedback about real use-cases is appreciated. How did using the CReverter go for your project? Did everything work nicely or were there unexpected problems? You can make an issue about this to tell me. This kind of feedback helps me to develop this better and improve the documentation.


## Shameless Plug

If you found value in the CReverter then please visit/bookmark/contribute-to/fund/talk-up/otherwise-relate-to-in-a-favoring-way the FOSS game I'm developing, [Super Practica](https://superpractica.org/). Thanks.

The Composite Reverter works well together with the [Contextual Service Locator](https://codeberg.org/svetogam/cslocator)! It's exactly the kind of "service" that it's good for locating!
