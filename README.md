# js2osc-ardour
Use a gamepad to control transport in [Ardour](https://ardour.org/).

If you know [Bison](http://liblo.sourceforge.net/) or understand
[BNF](https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_form) grammar
this small piece of software could be easily adapted to your needs.
You could tie arbitrary complex button sequences to C++ functions but
keep it simple, please.


## Dependencies

* A gamepad or joystick device
* Linux (and its [Joystick API](https://www.kernel.org/doc/Documentation/input/joystick-api.txt))
* [liblo](http://liblo.sourceforge.net/) (for interfacing Ardour via [Open Sound Control](http://opensoundcontrol.org/introduction-osc))
* [Bison](http://liblo.sourceforge.net/) parser generator


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


You might want to change the configuration in the code. See the Bison
grammar file `src/parser.y`. Follow these steps:

1. Find the `yylex()` function and check out, which hexcode your
   button produces.

2. Make sure, you define a token with the same code. Add e.g.:
```
%token TOKEN_MY_BUTTON_PRESS   0x0abcde;
%token TOKEN_MY_BUTTON_RELEASE 0x0abcdf;
```

3. Add a grammar rule with your C++ code. E.g.:
```
startswith_button_a: [...]
| [...]
| TOKEN_MY_BUTTON_PRESS TOKEN_MY_BUTTON_RELEASE {
  std::cout << "My button was pressed and released." << std::endl;
} 
;
```
