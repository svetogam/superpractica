# Changelog

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-08-17

This is a major breaking change. See the migration guide for how to upgrade.

### Changes

* CReverter is now a Node.
* More "Godoughy" interface for connecting objects to CReverter and for interacting with it in connected functions.
* Overall, CReverter now enables greater flexibility in its use.
* New option to disable aborting commits that build the same memento.
* New shortcuts for undo, redo, and revert that can be set in the inspector.
* Initial history can be set in the inspector.
* History max size can be set in the inspector.
* Memento data can be set in the inspector.
* Tags are now Strings instead of StringNames.
* Updated and improved documentation to match changes.
* Updated and improved examples to match changes.

### v1 to v2 Migration Guide

1. Replace calling `CReverter.new()` with adding a `CReverter` node to the scene.
2. Replace connecting functions by `CReverter.connect_save_load()` with connecting functions to `CReverter.saving` and `CReverter.loading` signals.
3. Use new format in connected saving and loading functions.

## [1.0.0] - 2024-06-19

Initial release.

[2.0.0]: https://codeberg.org/svetogam/creverter/releases/tag/v2.0.0
[1.0.0]: https://codeberg.org/svetogam/creverter/releases/tag/v1.0.0
