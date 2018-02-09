# js2osc-ardour
Use a gamepad to control transport in [Ardour](https://ardour.org/).

## Dependencies

* A gamepad or joystick device
* Linux (and its [Joystick API](https://www.kernel.org/doc/Documentation/input/joystick-api.txt))
* [liblo](http://liblo.sourceforge.net/) (for interfacing Ardour via [Open Sound Control](http://opensoundcontrol.org/introduction-osc))
* [Bison](http://liblo.sourceforge.net/)


## Build

```bash
$ mkdir build && cd build
$ cmake ..
$ make
```


## Usage

```bash
$ ./js2osc-ardour /dev/input/js0 "osc.udp://daw.example.org:3819/"
```

Exit with `Ctrl^C`.


## Configuration

By default the following functions have been tested to work with a
_Logitech Gamepad F310_ device:

### Transport

Button sequence | Meaning
----------------|--------
A>A<        | Toggle start/stop
A>X>X<A<    | Toggle metronome click
A>LB>LB<A<  | Jump to session start marker
A>RB>RB<A<  | Jump to session end marker
A>HAT_LEFT>HAT_LEFT<A< | Jump 1 bar backward
A>HAT_LEFT>HAT_LEFT<HAT_LEFT>HAT_LEFT<A< | Jump 4 bars backward
A>HAT_RIGHT>HAT_RIGHT<A< | Jump 1 bar forward
A>HAT_RIGHT>HAT_RIGHT<HAT_RIGHT>HAT_RIGHT<A< | Jump 4 bars forward

> For reference: `X>` means "press the X button" and `Y<` means "release
> the Y button".

### Marker

Button sequence | Meaning
----------------|--------
X>X<        | Add marker
X>A>A<X<    | Delete current marker
X>LB>LB<X<  | Jump to session start marker
X>RB>RB<X<  | Jump to session end marker
X>HAT_LEFT>HAT_LEFT<X< | Jump to previous marker
X>HAT_RIGHT>HAT_RIGHT<X< | Jump to next marker

### Recording

Button sequence | Meaning
----------------|--------
B>B<        | Record enable
B>LB>LB<B<  | Toggle punch-in
B>RB>RB<B<  | Toggle punch-out
B>BRAND>BRAND<B< | Toggle meterbridge

### Other

Button sequence | Meaning
----------------|--------
LB>LB<        | Rewind
RB>RB<        | Fast Forward
BACK>BACK<  | Undo
START>START<  | Redo
BRAND>BRAND< | Toggle editor/mixer
HAT_DOWN>HAT_DOWN< | Temporal zoom-in
HAT_UP>HAT_UP< | Temporal zoom-out


You might want to change the configuration in code. See the Bison
grammar file `src/parser.y`.