# Usagi Template

Quickstart project template for Usagi Engine.

Useful if you want something a bit more than what `usagi init` gives you for
projects.

Features:

- Scene switching + foundations
- Starter sprites
- Starter sound effects
- itch.io deploy script (requries Ruby to be installed)
- `UI` helpers for layout
- Debug display toggle by pressing <kbd>0</kbd>
- Simple particle spawner - see `particle_manager.lua`
- `justfile` with common tasks defined like `just dev`, `just push`, etc.

## Use the Template

1. Download the template code from https://codeberg.org/brettchalupa/usagi_template/archive/main.zip
2. Add your game's title to `./scenes/main_menu.lua`
3. Specify your itch username in `./data/metadatajson`
4. Make your game!

## Credits & License

Sprites by Kenney (CC0): https://kenney.nl/assets/1-bit-pack - modified to use
the Pico-8 color palette

Template source code is public domain and CC0. Take it and do with it what you
want!
