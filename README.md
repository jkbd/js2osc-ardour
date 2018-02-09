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
$ js2osc-ardour /dev/input/js0 "osc.udp://daw.example.org:3819/"
```

Exit with `Ctrl^C`.


## Configuration

You have to change the Bison grammar file `src/parser.y`.