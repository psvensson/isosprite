# isosprite
A Smalltalk project for managing and displaying isometric sprites

Written in Pharo but uses Morphic and should hopefully work in other smalltalk, let me know if not.
Graphics and sprites ise mostly (c) but CC by Clint Bellanger and from OpenGameart; https://opengameart.org/content/cave-tileset

Currently supports:
* Parsing and picking out individual sprites from a spritesheet png
* Can read Flare's sprite definition format and use it to create animated sprites
* Can create aggregeate sprites (mutliples of above) which are animated together (so that sword, head and body animate together)
* Support multiple version of an aggreagated sprite layer, so 'bodu' can have 'clothes', 'leather_armour' and 'steel_armour' and swithc between them at runtime.
* Support placy_once, back_forth and loop animations (also from Flare sprite definitions)

Run the IsoSpriteBoardTest which acts as just an example and opens an IsoSpriteBoard in world.
![image](https://github.com/psvensson/isosprite/blob/main/Screenshot%20from%202021-03-05%2015-22-58.png)
