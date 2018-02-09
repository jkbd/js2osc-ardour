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
A>A<        | /toggle_roll
A>B>B<A<    | /toggle_click
A>LB>LB<A<  | /goto_start
A>RB>RB<A<  | /goto_end

> For reference: `X>` means "press the X button" and `Y<` means "release
> the Y button".

You might want to change the configuration in code. See the Bison
grammar file `src/parser.y`.