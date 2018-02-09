#ifndef JOYSTICK_HPP
#define JOYSTICK_HPP

#include <string>


#include <linux/joystick.h>
#include <lo/lo.h>

class Joystick {
public:
  Joystick(std::string& device_path, std::string& osc_url);
  ~Joystick();

  void info() const;
  struct js_event next() const;

  lo_address ardour;

private:
  const static int JOYSTICK_NAME_LENGTH = 128;
  
  int file_descriptor;
  int version;
  unsigned char axes;
  unsigned char buttons;
  char name[JOYSTICK_NAME_LENGTH];
};

#endif // JOYSTICK_HPP
