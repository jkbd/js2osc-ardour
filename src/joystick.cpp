#include <iostream>

#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#include "joystick.hpp"

Joystick::Joystick(std::string& device_path, std::string& osc_url) :
  version(0x000800),
  axes(2),
  buttons(2),
  name("Unknown")
{
  // Open device
  if ((file_descriptor = open(device_path.c_str(), O_RDONLY)) < 0) {
    perror("js2osc");
    exit(EXIT_FAILURE);
  }

  // Explore parameters
  ioctl(file_descriptor, JSIOCGVERSION, &version);
  ioctl(file_descriptor, JSIOCGAXES, &axes);
  ioctl(file_descriptor, JSIOCGBUTTONS, &buttons);
  ioctl(file_descriptor, JSIOCGNAME(JOYSTICK_NAME_LENGTH), name);

  // Create a OSC address
  ardour = lo_address_new_from_url(osc_url.c_str());
}


Joystick::~Joystick() {
  lo_address_free(ardour);
}


void Joystick::info() const {
  std::cout << name << " has " << int(axes) << " axes and "
	    << int(buttons) << " buttons. "
	    << "The driver version is "
	    << (version >> 16) << "."
	    << ((version >> 8) & 0xff) << "."
	    << (version & 0xff) << "."
	    << std::endl;
}


/**
 * Fetch the next event from the joystick.
 */
struct js_event Joystick::next() const {
  struct js_event js;

  if (read(file_descriptor, &js, sizeof(struct js_event)) != sizeof(struct js_event)) {
    perror("\njs2osc: error reading");
    exit(EXIT_FAILURE);	
  } else {
    return js;
  }
}
