%{
#define YYSTYPE struct js_event
  
#include <iostream>
  
#include <math.h>
#include <stdio.h>
#include <linux/joystick.h>

#include "../src/joystick.hpp"
  
int yylex(Joystick *js);
void yyerror (Joystick *js, const char *msg);

void print_event(struct js_event e); 
void send_simple_osc(Joystick *js, const char *order);
 
%}


%param {Joystick *js}

/* type, number, value:        0xttnnvv; */
%token TOKEN_BUTTON_A_PRESS    0x010001;
%token TOKEN_BUTTON_A_RELEASE  0x010000;
%token TOKEN_BUTTON_B_PRESS    0x010101;
%token TOKEN_BUTTON_B_RELEASE  0x010100;
%token TOKEN_BUTTON_X_PRESS    0x010201;
%token TOKEN_BUTTON_X_RELEASE  0x010200;
%token TOKEN_BUTTON_Y_PRESS    0x010301;
%token TOKEN_BUTTON_Y_RELEASE  0x010300;

%token TOKEN_BUTTON_LB_PRESS    0x010401;
%token TOKEN_BUTTON_LB_RELEASE  0x010400;
%token TOKEN_BUTTON_RB_PRESS    0x010501;
%token TOKEN_BUTTON_RB_RELEASE  0x010500;

%token TOKEN_BUTTON_BACK_PRESS    0x010601;
%token TOKEN_BUTTON_BACK_RELEASE  0x010600;
%token TOKEN_BUTTON_START_PRESS   0x010701;
%token TOKEN_BUTTON_START_RELEASE 0x010700;
%token TOKEN_BUTTON_BRAND_PRESS   0x010801;
%token TOKEN_BUTTON_BRAND_RELEASE 0x010800;

%token TOKEN_BUTTON_LEFT_KNOB_PRESS   0x010901;
%token TOKEN_BUTTON_LEFT_KNOB_RELEASE 0x010900;
%token TOKEN_BUTTON_RIGHT_KNOB_PRESS   0x010a01;
%token TOKEN_BUTTON_RIGHT_KNOB_RELEASE 0x010a00;


%token TOKEN_AXIS_LEFT_KNOB_HORIZONTAL  0x020001;
%token TOKEN_AXIS_LEFT_KNOB_VERTICAL    0x020101;
%token TOKEN_AXIS_LT                    0x020201;
%token TOKEN_AXIS_RIGHT_KNOB_HORIZONTAL 0x020301;
%token TOKEN_AXIS_RIGHT_KNOB_VERTICAL   0x020401;
%token TOKEN_AXIS_RT                    0x020501;


%token TOKEN_AXIS_HAT_HORIZONTAL_RELEASE     0x020600;
%token TOKEN_AXIS_HAT_HORIZONTAL_LEFT        0x020601;
%token TOKEN_AXIS_HAT_HORIZONTAL_RIGHT       0x020602;

%token TOKEN_AXIS_HAT_VERTICAL_RELEASE       0x020700;
%token TOKEN_AXIS_HAT_VERTICAL_UP            0x020701;
%token TOKEN_AXIS_HAT_VERTICAL_DOWN          0x020702;



%% /* Grammar rules and actions follow */

input: /* empty */
| input event_sequence
;

event_sequence: startswith_button_a
| startswith_button_b
| startswith_button_x
| startswith_button_y
| startswith_button_lb
| startswith_button_rb
| startswith_button_back
| startswith_button_start
| startswith_button_brand
| startswith_axis_hat
| startswith_axis_left_knob
| startswith_axis_right_knob
| startswith_axis_lt
| startswith_axis_rt
;

/* A: transport */
startswith_button_a: TOKEN_BUTTON_A_PRESS button_a_plus_more TOKEN_BUTTON_A_RELEASE {
  if ($2.number == 1) {
    send_simple_osc(js, "/toggle_roll");
  }
  if ($2.number == 2) {
    send_simple_osc(js, "/goto_start");
  }
  if ($2.number == 3) {
    send_simple_osc(js, "/goto_end");
  }
  if ($2.number == 4) {
    if(lo_send(js->ardour, "/jump_bars", "f", -1.0) == -1) {
      std::cout << "OSC error: " << lo_address_errno(js->ardour) << ", "
		<< lo_address_errstr(js->ardour) << std::endl;
    } else {
      puts("/jump_bars -1");
    }
  }
  if ($2.number == 5) {
    if(lo_send(js->ardour, "/jump_bars", "f", 1.0) == -1) {
      std::cout << "OSC error: " << lo_address_errno(js->ardour) << ", "
		<< lo_address_errstr(js->ardour) << std::endl;
    } else {
      puts("/jump_bars +1");
    }
  }
    if ($2.number == 6) {
    if(lo_send(js->ardour, "/jump_bars", "f", -4.0) == -1) {
      std::cout << "OSC error: " << lo_address_errno(js->ardour) << ", "
		<< lo_address_errstr(js->ardour) << std::endl;
    } else {
      puts("/jump_bars -4");
    }
  }
  if ($2.number == 7) {
    if(lo_send(js->ardour, "/jump_bars", "f", 4.0) == -1) {
      std::cout << "OSC error: " << lo_address_errno(js->ardour) << ", "
		<< lo_address_errstr(js->ardour) << std::endl;
    } else {
      puts("/jump_bars +4");
    }
  }
  if ($2.number == 8) {
    send_simple_osc(js, "/toggle_click");
  }
  /*
   * A+B is intended to be unergonomic. You don't want to hit this
   * accidentially!
   */
  if ($2.number == 9) {
    send_simple_osc(js, "/stop_forget");
  }
 }
;

button_a_plus_more: /* empty */ {
  $$.number = 1;
}
| TOKEN_BUTTON_LB_PRESS  TOKEN_BUTTON_LB_RELEASE {
  $$.number = 2;
 }
| TOKEN_BUTTON_RB_PRESS  TOKEN_BUTTON_RB_RELEASE {
  $$.number = 3;
 }
/* pressed single time */
| TOKEN_AXIS_HAT_HORIZONTAL_LEFT TOKEN_AXIS_HAT_HORIZONTAL_RELEASE {
  $$.number = 4;
 }
| TOKEN_AXIS_HAT_HORIZONTAL_RIGHT TOKEN_AXIS_HAT_HORIZONTAL_RELEASE {
  $$.number = 5;
 }
/* pressed two times */
| TOKEN_AXIS_HAT_HORIZONTAL_LEFT TOKEN_AXIS_HAT_HORIZONTAL_RELEASE TOKEN_AXIS_HAT_HORIZONTAL_LEFT TOKEN_AXIS_HAT_HORIZONTAL_RELEASE {
  $$.number = 6;
 }
| TOKEN_AXIS_HAT_HORIZONTAL_RIGHT TOKEN_AXIS_HAT_HORIZONTAL_RELEASE TOKEN_AXIS_HAT_HORIZONTAL_RIGHT TOKEN_AXIS_HAT_HORIZONTAL_RELEASE {
  $$.number = 7;
 }
| TOKEN_BUTTON_X_PRESS  TOKEN_BUTTON_X_RELEASE {
  $$.number = 8;
 }
| TOKEN_BUTTON_B_PRESS  TOKEN_BUTTON_B_RELEASE {
  $$.number = 9;
 }
;


/* B: recoring */
startswith_button_b: TOKEN_BUTTON_B_PRESS button_b_plus_more TOKEN_BUTTON_B_RELEASE {
  if ($2.number == 1) {
    send_simple_osc(js, "/rec_enable_toggle");
  }
  if ($2.number == 2) {
    send_simple_osc(js, "/toggle_punch_in");
  }
  if ($2.number == 3) {
    send_simple_osc(js, "/toggle_punch_out");
  }
  if ($2.number == 4) {
    send_simple_osc(js, "/access_action/Common/toggle-meterbridge");
  }
 }
;

button_b_plus_more: /* empty */ {
  $$.number = 1;
}
| TOKEN_BUTTON_LB_PRESS  TOKEN_BUTTON_LB_RELEASE {
  $$.number = 2;
 }
| TOKEN_BUTTON_RB_PRESS  TOKEN_BUTTON_RB_RELEASE {
  $$.number = 3;
 }
| TOKEN_BUTTON_BRAND_PRESS  TOKEN_BUTTON_BRAND_RELEASE {
  $$.number = 4;
 }
;



startswith_button_x: TOKEN_BUTTON_X_PRESS button_x_plus_more TOKEN_BUTTON_X_RELEASE {
  if ($2.number == 1) {
    send_simple_osc(js, "/add_marker");
  }
  if ($2.number == 2) {
    send_simple_osc(js, "/prev_marker");
  }
  if ($2.number == 3) {
    send_simple_osc(js, "/next_marker");
  }
  if ($2.number == 4) {
    send_simple_osc(js, "/remove_marker");
  }
  /* Note: A-LB does the same. But this feels right. */
  if ($2.number == 5) {
    send_simple_osc(js, "/goto_start");
  }
  if ($2.number == 6) {
    send_simple_osc(js, "/goto_end");
  }

 }
;

button_x_plus_more: /* empty */ {
  $$.number = 1;
}
/* pressed single time */
| TOKEN_AXIS_HAT_HORIZONTAL_LEFT TOKEN_AXIS_HAT_HORIZONTAL_RELEASE {
  $$.number = 2;
 }
| TOKEN_AXIS_HAT_HORIZONTAL_RIGHT TOKEN_AXIS_HAT_HORIZONTAL_RELEASE {
  $$.number = 3;
 }
| TOKEN_BUTTON_A_PRESS  TOKEN_BUTTON_A_RELEASE {
  $$.number = 4;
 }
| TOKEN_BUTTON_LB_PRESS  TOKEN_BUTTON_LB_RELEASE {
  $$.number = 5;
 }
| TOKEN_BUTTON_RB_PRESS  TOKEN_BUTTON_RB_RELEASE {
  $$.number = 6;
 }
;


/* Y: track selection */
startswith_button_y: TOKEN_BUTTON_Y_PRESS button_y_plus_more TOKEN_BUTTON_Y_RELEASE {
  if ($2.number == 1) {
  }
  if ($2.number == 2) {
  }
  if ($2.number == 3) {    
  }
  if ($2.number == 4) {
  }
 }
;

button_y_plus_more: /* empty */ {
  $$.number = 1;
}
/* pressed single time */
| TOKEN_AXIS_HAT_HORIZONTAL_LEFT TOKEN_AXIS_HAT_HORIZONTAL_RELEASE {
  $$.number = 2;
 }
| TOKEN_AXIS_HAT_HORIZONTAL_RIGHT TOKEN_AXIS_HAT_HORIZONTAL_RELEASE {
  $$.number = 3;
 }
| TOKEN_BUTTON_B_PRESS  TOKEN_BUTTON_B_RELEASE {
  $$.number = 4;
 }
;


startswith_button_lb: TOKEN_BUTTON_LB_PRESS TOKEN_BUTTON_LB_RELEASE {
  send_simple_osc(js, "/rewind");
 }
;

startswith_button_rb: TOKEN_BUTTON_RB_PRESS TOKEN_BUTTON_RB_RELEASE {
   send_simple_osc(js, "/ffwd");
 }
;


startswith_button_back: TOKEN_BUTTON_BACK_PRESS TOKEN_BUTTON_BACK_RELEASE {
  send_simple_osc(js, "/undo");
 }
;


startswith_button_start: TOKEN_BUTTON_START_PRESS TOKEN_BUTTON_START_RELEASE {
  send_simple_osc(js, "/redo");
 }
;

startswith_button_brand: TOKEN_BUTTON_BRAND_PRESS TOKEN_BUTTON_BRAND_RELEASE {
  send_simple_osc(js, "/access_action/Common/toggle-editor-and-mixer");
 }
;


startswith_axis_left_knob: TOKEN_AXIS_LEFT_KNOB_HORIZONTAL
| TOKEN_AXIS_LEFT_KNOB_VERTICAL
;

startswith_axis_right_knob: TOKEN_AXIS_RIGHT_KNOB_HORIZONTAL
| TOKEN_AXIS_RIGHT_KNOB_VERTICAL
;

startswith_axis_lt: TOKEN_AXIS_LT {
 }
;

startswith_axis_rt: TOKEN_AXIS_RT {

 }
;

startswith_axis_hat: TOKEN_AXIS_HAT_HORIZONTAL_LEFT TOKEN_AXIS_HAT_HORIZONTAL_RELEASE
| TOKEN_AXIS_HAT_HORIZONTAL_RIGHT TOKEN_AXIS_HAT_HORIZONTAL_RELEASE

| TOKEN_AXIS_HAT_VERTICAL_UP TOKEN_AXIS_HAT_VERTICAL_RELEASE {
     if(lo_send(js->ardour, "/access_action/Editor/temporal-zoom-out", "i", 1) == -1) {
	std::cout << "OSC error: " << lo_address_errno(js->ardour) << ", "
		  << lo_address_errstr(js->ardour) << std::endl;
      } else {
	puts("/access_action/Editor/temporal-zoom-out 1");
      }  
 }
| TOKEN_AXIS_HAT_VERTICAL_DOWN TOKEN_AXIS_HAT_VERTICAL_RELEASE {
      if(lo_send(js->ardour, "/access_action/Editor/temporal-zoom-in", "i", 1) == -1) {
	std::cout << "OSC error: " << lo_address_errno(js->ardour) << ", "
		  << lo_address_errstr(js->ardour) << std::endl;
      } else {
	puts("/access_action/Editor/temporal-zoom-in 1");
      }
 }
;


%%


#include <ctype.h>

int yylex(Joystick *js) {
  struct js_event e;
  int token = 0;
  int hat_value = 0;
  
  while (1) {
    e = js->next();
    yylval = e;
    //print_event(e);
  
    switch(e.type & ~JS_EVENT_INIT) {      
    case JS_EVENT_BUTTON:
      token = e.value | (e.number << 8) | (e.type << 16);
      //printf("DEBUG 0x%08x", token);
      return token;
      break;
    case JS_EVENT_AXIS:
      if ((e.number == 6) || (e.number == 7)) {
	// handle the hat
	if (e.value != 0) {
	  if (e.value < 0) {
	    hat_value = 0x01;
	  } else {
	    hat_value = 0x02;
	  }
	} else {
	  hat_value = 0x00;
	}
	token = hat_value | (e.number << 8) | (e.type << 16);
      } else {
	// else handle the knobs and triggers
	token = 0x01 | (e.number << 8) | (e.type << 16);       
      }
      
      //printf("DEBUG 0x%08x\n", token);	    
      return token;
      break;
    default:
      return 0; // should not be reachable
      break;
    }
  }
}

void yyerror (Joystick *js, const char *msg) {
  //printf ("%s\n", msg);
}

void print_event(struct js_event e) {
  printf ("DEBUG [%d]:\t0x%08x, 0x%08x, 0x%08x\n", e.time, e.value, e.type, e.number);
}

void send_simple_osc(Joystick *js, const char *order) {
  if(lo_send(js->ardour, order, NULL) == -1) {
    std::cout << "OSC error: " << lo_address_errno(js->ardour) << ", "
	      << lo_address_errstr(js->ardour) << std::endl;
  } else {
    puts(order);
  }
}

/* TODO: Zoom to selection. */
/* TODO: Track arming. */
/* TODO: Named markers. */
/* TODO: stop and forget should be B+BACK. */
