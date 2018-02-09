#include <iostream>
#include <string>

#include "joystick.hpp"

extern int yyparse(Joystick *j);

int main (int argc, char **argv)
{
  std::string device_path;
  std::string osc_url;
  
  if (argc != 3) {
    std::cout << "Usage: js2osc <device> <osc_url>" << std::endl;
    exit(EXIT_FAILURE);
  } else {
    device_path.assign(argv[1]);
    osc_url.assign(argv[2]);
  }

  Joystick j = Joystick(device_path, osc_url);
  j.info();

  while (1) {
    yyparse(&j);
  }
}
