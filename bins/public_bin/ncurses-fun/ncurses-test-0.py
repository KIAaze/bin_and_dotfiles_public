#!/usr/bin/env python3
import time
import curses
import curses.panel
from curses import wrapper
from curses.textpad import Textbox, rectangle

non_color_attributes = [('A_ALTCHARSET', curses.A_ALTCHARSET),
  ('A_BLINK', curses.A_BLINK),
  ('A_BOLD', curses.A_BOLD),
  ('A_DIM', curses.A_DIM),
  ('A_NORMAL', curses.A_NORMAL),
  ('A_REVERSE', curses.A_REVERSE),
  ('A_STANDOUT', curses.A_STANDOUT),
  ('A_UNDERLINE', curses.A_UNDERLINE)]

color_attributes = [('COLOR_BLACK', curses.COLOR_BLACK),
  ('COLOR_BLUE', curses.COLOR_BLUE),
  ('COLOR_CYAN', curses.COLOR_CYAN),
  ('COLOR_GREEN', curses.COLOR_GREEN),
  ('COLOR_MAGENTA', curses.COLOR_MAGENTA),
  ('COLOR_RED', curses.COLOR_RED),
  ('COLOR_WHITE', curses.COLOR_WHITE),
  ('COLOR_YELLOW', curses.COLOR_YELLOW)]

def main(stdscr):
    # Clear screen
    stdscr.clear()

    # This raises ZeroDivisionError when i == 10.
    for i in range(0, 10):
        v = i-10
        stdscr.addstr(i, 0, '10 divided by {} is {}'.format(v, 10/v))

    stdscr.refresh()
    stdscr.getkey()

def prout(stdscr):
  pad = curses.newpad(100, 100)
  # These loops fill the pad with letters; addch() is
  # explained in the next section
  for y in range(0, 99):
      for x in range(0, 99):
          pad.addch(y,x, ord('a') + (x*x+y*y) % 26)

  # Displays a section of the pad in the middle of the screen.
  # (0,0) : coordinate of upper-left corner of pad area to display.
  # (5,5) : coordinate of upper-left corner of window area to be filled
  #         with pad content.
  # (20, 75) : coordinate of lower-right corner of window area to be
  #          : filled with pad content.
  Ny = curses.LINES - 1
  Nx = curses.COLS
  stdscr.refresh()
  pad.refresh( 0,0, 5,5, min(Ny, 5), min(Nx, 8))
  stdscr.getkey()

def prat(stdscr):
  #pad = curses.newpad(100, 100)
  # These loops fill the pad with letters; addch() is
  # explained in the next section
  Ny = curses.LINES - 1
  Nx = curses.COLS
  
  #Ny=10
  #Nx=20
  for y in range(0, Ny):
      for x in range(0, Nx):
          stdscr.addch(y,x, ord('a') + (x*x+y*y) % 26)
          #stdscr.addch(y,x, ord('a'))

  # Displays a section of the pad in the middle of the screen.
  # (0,0) : coordinate of upper-left corner of pad area to display.
  # (5,5) : coordinate of upper-left corner of window area to be filled
  #         with pad content.
  # (20, 75) : coordinate of lower-right corner of window area to be
  #          : filled with pad content.
  stdscr.refresh()
  stdscr.getkey()
  #stdscr.refresh( 0,0, 5,5, 20,75)

def mybox(stdscr):
  stdscr.addstr(0,0,'KUNG FURY')
  stdscr.addstr(1,1,'KUNG FURY')
  stdscr.addstr( 1, 2, 'LOLO')
  stdscr.addstr(3, 4, 'AARFRFRF')
  stdscr.addstr(5, 6, 'huhu')
  stdscr.addstr(7, 7, "Current mode: Typing mode", curses.A_REVERSE)
  stdscr.addch(curses.ACS_ULCORNER)
  stdscr.addch(curses.ACS_URCORNER)
  stdscr.addch(curses.ACS_LLCORNER)
  stdscr.addch(curses.ACS_LRCORNER)
  stdscr.border()
  #stdscr.bkgd('.', curses.A_REVERSE)
  #stdscr.bkgdset('.', curses.A_UNDERLINE)
  #stdscr.addstr(10, 1, "Pretty text", curses.color_pair(1))
  if curses.has_colors():
    stdscr.addstr(5, 1, 'HAS COLOR')
  else:
    stdscr.addstr(5, 1, 'NO COLOR')

  if curses.can_change_color():
    stdscr.addstr(6, 1, 'can_change_color = true')
  else:
    stdscr.addstr(6, 1, 'can_change_color = false')

  stdscr.addstr(10, 1, "Pretty text lots of      space", curses.color_pair(1))
  curses.init_pair(1, curses.COLOR_RED, curses.COLOR_WHITE)
  stdscr.addstr(11, 1, "RED ALERT!", curses.color_pair(1))
  stdscr.addstr(12, 1, "RED ALERT!", curses.color_pair(0))
  stdscr.refresh()
  stdscr.getkey()

def fafa(stdscr):
  while True:
    c = stdscr.getch()
    if c == ord('p'):
        stdscr.addch(c)
    elif c == ord('q'):
        break  # Exit the while loop
    elif c == curses.KEY_HOME:
        x = y = 0
        stdscr.addstr('E.T. GO HOME!')
    elif curses.ascii.isctrl(c):
      stdscr.addch(curses.ascii.ctrl(c))
      
      
def echoman(stdscr):
  curses.echo()            # Enable echoing of characters

  # Get a 15-character string, with the cursor on the top line
  s = stdscr.getstr(0,0, 15)
  stdscr.addstr(0, 20, s)
  stdscr.refresh()
  stdscr.getkey()

def foo(stdscr):
    stdscr.addstr(0, 0, "Enter IM message: (hit Ctrl-G to send)")

    editwin = curses.newwin(5, 30, 2, 1)
    rectangle(stdscr, 1,0, 1+5+1, 1+30+1)
    stdscr.refresh()

    box = Textbox(editwin)

    #pad = curses.newpad(100, 100)
    height = 7; width = 33

    begin_y = 1; begin_x = 33
    win0 = curses.newwin(height, width, begin_y, begin_x)
    win0.border()
    win0.refresh()

    begin_y = 8; begin_x = 0
    win1 = curses.newwin(height, width, begin_y, begin_x)
    win1.border()
    win1.refresh()

    begin_y = 8; begin_x = 33
    win2 = curses.newwin(height, width, begin_y, begin_x)
    win2.border()
    win2.refresh()

    # Let the user edit until Ctrl-G is struck.
    box.edit()

    # Get resulting contents
    message = box.gather()


    win0.addstr(1,1,message)
    win1.addstr(1,1,message)
    win2.addstr(1,1,message)

    win0.refresh()
    win1.refresh()
    win2.refresh()
    
    stdscr.refresh()
    stdscr.getkey()

def cursor_move(stdscr):
  curses.curs_set(False)
  Ymax, Xmax = stdscr.getmaxyx()
  Ymax = Ymax - 1
  # xpos, ypos are the cursor's position
  xpos, ypos = Xmax // 2, Ymax // 2
  xpos_old = xpos
  ypos_old = ypos
  sprite = 'o'
  stdscr.addstr(ypos, xpos, sprite)
  
  curdir = 0
  olddir = curdir
  stdscr.nodelay(1)
  while True:
    c = stdscr.getch()
    if c == ord('q'):
        break  # Exit the while loop
    
    if c == curses.KEY_UP:
      sprite = '^'
      curdir = 1
    elif c == curses.KEY_DOWN:
      sprite = 'v'
      curdir = 2
    elif c == curses.KEY_LEFT:
      sprite = '<'
      curdir = 3
    elif c == curses.KEY_RIGHT:
      sprite = '>'
      curdir = 4

    if curdir == 1 and ypos > 0:
        ypos -= 1
    elif curdir == 2 and ypos + 1 < Ymax:
        ypos += 1
    elif curdir == 3 and xpos > 0:
        xpos -= 1
    elif curdir == 4 and xpos + 1 < Xmax:
        xpos += 1

    if curdir in [3,4]:
      if olddir == 1 and curdir == 4:
        stdscr.addch(ypos_old, xpos_old, curses.ACS_ULCORNER)
      elif olddir == 1 and curdir == 3:
        stdscr.addch(ypos_old, xpos_old, curses.ACS_URCORNER)
      elif olddir == 2 and curdir == 4:
        stdscr.addch(ypos_old, xpos_old, curses.ACS_LLCORNER)
      elif olddir == 2 and curdir == 3:
        stdscr.addch(ypos_old, xpos_old, curses.ACS_LRCORNER)
      else:
        stdscr.addch(ypos_old, xpos_old, curses.ACS_HLINE)
    elif curdir in [1,2]:
      if olddir == 3 and curdir == 1:
        stdscr.addch(ypos_old, xpos_old, curses.ACS_LLCORNER)
      elif olddir == 3 and curdir == 2:
        stdscr.addch(ypos_old, xpos_old, curses.ACS_ULCORNER)
      elif olddir == 4 and curdir == 1:
        stdscr.addch(ypos_old, xpos_old, curses.ACS_LRCORNER)
      elif olddir == 4 and curdir == 2:
        stdscr.addch(ypos_old, xpos_old, curses.ACS_URCORNER)
      else:
        stdscr.addch(ypos_old, xpos_old, curses.ACS_VLINE)

    stdscr.addch(ypos, xpos, sprite)
    xpos_old = xpos
    ypos_old = ypos
    olddir = curdir
    time.sleep(0.01)
    #if 0 < c < 256:
      #if c == ord('p'):
          #curses.beep()
      #else:
        #pass

def draw_color_grid(stdscr, mark, color_grid_y0, color_grid_x0, init=False):
  pair_number = 0
  for y, fg in enumerate(reversed(range(8))):
    for x, bg in enumerate(range(8)):
      pair_number = y*8 + x
      if init and pair_number != 0:
        curses.init_pair(pair_number, fg, bg)
      stdscr.addch(y + color_grid_y0, x + color_grid_x0, mark, curses.color_pair(pair_number))

def mouse_test(stdscr):
    curses.curs_set(False)
    mousemask = curses.ALL_MOUSE_EVENTS | curses.REPORT_MOUSE_POSITION
    #mousemask = curses.REPORT_MOUSE_POSITION
    curses.mousemask(mousemask)
    mark = '+'

    info_window = curses.newwin(25, 43, 0, 0)

    y_offset = 0
    stdscr.addstr(y_offset, 0, 'non_color_attributes:', curses.A_UNDERLINE)
    y_offset += 1
    non_color_attributes_offset = y_offset
    for idx,val in enumerate(non_color_attributes):
      stdscr.addstr(idx + y_offset, 2, str(idx))
      stdscr.addstr(idx + y_offset, 4, val[0])
      stdscr.addstr(idx + y_offset, 20, '{:023b}'.format(val[1]))

    y_offset += len(non_color_attributes) + 1
    stdscr.addstr(y_offset, 0, 'color pairs:', curses.A_UNDERLINE)
    y_offset += 2
    color_grid_x0 = 0
    color_grid_y0 = y_offset
    draw_color_grid(stdscr, mark, color_grid_y0, color_grid_x0, init=True)

    #y_offset += len(non_color_attributes) + 1
    #stdscr.addstr(y_offset, 0, 'foreground color:', curses.A_UNDERLINE)
    #y_offset += 1
    #foreground_color_offset = y_offset
    #for idx,val in enumerate(color_attributes):
      #stdscr.addstr(idx + y_offset, 2, str(idx))
      #stdscr.addstr(idx + y_offset, 4, val[0])
      #stdscr.addstr(idx + y_offset, 20, '{:023b}'.format(val[1]))

    #y_offset += len(color_attributes) + 1
    #stdscr.addstr(y_offset, 0, 'background color:', curses.A_UNDERLINE)
    #y_offset += 1
    #background_color_offset = y_offset
    #for idx,val in enumerate(color_attributes):
      #stdscr.addstr(idx + y_offset, 2, str(idx))
      #stdscr.addstr(idx + y_offset, 4, val[0])
      #stdscr.addstr(idx + y_offset, 20, '{:023b}'.format(val[1]))
    
    y_offset += len(color_attributes) + 1
    stdscr.addstr(y_offset, 0, 'debug info:', curses.A_UNDERLINE)
    y_offset += 1
    
    #attribute_mask = curses.A_UNDERLINE | curses.color_pair(1)

    c=0
    id, x, y, z, bstate = 0,0,0,0,0
    attribute_mask = 0
    pair_number = 0

    stdscr.addstr(y_offset, 0,'c={} id={}, x={}, y={}, z={}, bstate={}'.format(c, id, x, y, z, bstate))
    stdscr.addstr(y_offset+1, 0, 'attribute_mask =')
    stdscr.addstr(y_offset+1, 20, '{:023b}'.format(attribute_mask))
    stdscr.addstr(y_offset+2, 0, 'pair_number={} COLOR_PAIRS={}'.format(pair_number, curses.COLOR_PAIRS))

    #for pair_number in range(curses.COLOR_PAIRS):
      #(fg, bg) = curses.pair_content(pair_number)
      #stdscr.addstr(40+pair_number, 0, 'pair_number={}, fg={}, bg={}'.format(pair_number, fg, bg))

    while(True):
      c = stdscr.getch()
      #stdscr.addstr(20, 20, '{:03d}'.format(c))
      #stdscr.addstr(21, 20, '                ')
      #stdscr.addstr(21, 20, '{}'.format(curses.ascii.isascii(c)))

      if curses.ascii.isgraph(c):
        mark = c
        draw_color_grid(stdscr, mark, color_grid_y0, color_grid_x0)
      elif c == curses.ascii.BEL or c == curses.ascii.ESC: # quit on ctrl+G or escape
        break
      
      try:
        (id, x, y, z, bstate) = curses.getmouse()
        stdscr.addstr(y_offset, 0,'c={} id={}, x={}, y={}, z={}, bstate={}'.format(c, id, x, y, z, bstate))
        if x==0 and y in range(non_color_attributes_offset, non_color_attributes_offset+len(non_color_attributes)):
          a = non_color_attributes[y - non_color_attributes_offset][1]
          if attribute_mask & a: # set
            stdscr.addch(y, x, ' ')
            attribute_mask = attribute_mask & (~a)
          else: # not set
            stdscr.addch(y, x, 'x')
            attribute_mask = attribute_mask | a
        elif x in range(color_grid_x0, color_grid_x0+8) and y in range(color_grid_y0, color_grid_y0+8):
          xx = x - color_grid_x0
          yy = y - color_grid_y0
          pair_number = yy*8 + xx
        else:
          stdscr.addch(y, x, mark, attribute_mask | curses.color_pair(pair_number))
      except:
        pass
      stdscr.addstr(y_offset+1, 20, '{:023b}'.format(attribute_mask))
      stdscr.addstr(y_offset+2, 0, 'pair_number={} COLOR_PAIRS={}'.format(pair_number, curses.COLOR_PAIRS))
      
      #stdscr.getkey()

    #stdscr.refresh()
    #stdscr.getkey()

#A_ALTCHARSET    Alternate character set mode.
#A_BLINK         Blink mode.
#A_BOLD  Bold mode.
#A_DIM   Dim mode.
#A_NORMAL        Normal attribute.
#A_REVERSE       Reverse background and foreground colors.
#A_STANDOUT      Standout mode.
#A_UNDERLINE     Underline mode.

#COLOR_BLACK     Black
#COLOR_BLUE      Blue
#COLOR_CYAN      Cyan (light greenish blue)
#COLOR_GREEN     Green
#COLOR_MAGENTA   Magenta (purplish red)
#COLOR_RED       Red
#COLOR_WHITE     White
#COLOR_YELLOW    Yellow

       #Name                     Description
       #─────────────────────────────────────────────────────────────────────
       #BUTTON1_PRESSED          mouse button 1 down
       #BUTTON1_RELEASED         mouse button 1 up
       #BUTTON1_CLICKED          mouse button 1 clicked
       #BUTTON1_DOUBLE_CLICKED   mouse button 1 double clicked
       #BUTTON1_TRIPLE_CLICKED   mouse button 1 triple clicked
       #─────────────────────────────────────────────────────────────────────
       #BUTTON2_PRESSED          mouse button 2 down
       #BUTTON2_RELEASED         mouse button 2 up
       #BUTTON2_CLICKED          mouse button 2 clicked
       #BUTTON2_DOUBLE_CLICKED   mouse button 2 double clicked
       #BUTTON2_TRIPLE_CLICKED   mouse button 2 triple clicked
       #─────────────────────────────────────────────────────────────────────
       #BUTTON3_PRESSED          mouse button 3 down
       #BUTTON3_RELEASED         mouse button 3 up
       #BUTTON3_CLICKED          mouse button 3 clicked
       #BUTTON3_DOUBLE_CLICKED   mouse button 3 double clicked
       #BUTTON3_TRIPLE_CLICKED   mouse button 3 triple clicked
       #─────────────────────────────────────────────────────────────────────
       #BUTTON4_PRESSED          mouse button 4 down
       #BUTTON4_RELEASED         mouse button 4 up
       #BUTTON4_CLICKED          mouse button 4 clicked
       #BUTTON4_DOUBLE_CLICKED   mouse button 4 double clicked
       #BUTTON4_TRIPLE_CLICKED   mouse button 4 triple clicked
       #─────────────────────────────────────────────────────────────────────

       #BUTTON5_PRESSED          mouse button 5 down
       #BUTTON5_RELEASED         mouse button 5 up
       #BUTTON5_CLICKED          mouse button 5 clicked
       #BUTTON5_DOUBLE_CLICKED   mouse button 5 double clicked
       #BUTTON5_TRIPLE_CLICKED   mouse button 5 triple clicked
       #─────────────────────────────────────────────────────────────────────
       #BUTTON_SHIFT             shift was down during button state change
       #BUTTON_CTRL              control was down during button state change
       #BUTTON_ALT               alt was down during button state change
       #ALL_MOUSE_EVENTS         report all button state changes
       #REPORT_MOUSE_POSITION    report mouse movement
       #─────────────────────────────────────────────────────────────────────

def mouse_values():
  val = [curses.BUTTON1_PRESSED,
    curses.BUTTON1_RELEASED,
    curses.BUTTON1_CLICKED,
    curses.BUTTON1_DOUBLE_CLICKED,
    curses.BUTTON1_TRIPLE_CLICKED,
    curses.BUTTON2_PRESSED,
    curses.BUTTON2_RELEASED,
    curses.BUTTON2_CLICKED,
    curses.BUTTON2_DOUBLE_CLICKED,
    curses.BUTTON2_TRIPLE_CLICKED,
    curses.BUTTON3_PRESSED,
    curses.BUTTON3_RELEASED,
    curses.BUTTON3_CLICKED,
    curses.BUTTON3_DOUBLE_CLICKED,
    curses.BUTTON3_TRIPLE_CLICKED,
    curses.BUTTON4_PRESSED,
    curses.BUTTON4_RELEASED,
    curses.BUTTON4_CLICKED,
    curses.BUTTON4_DOUBLE_CLICKED,
    curses.BUTTON4_TRIPLE_CLICKED,
    #curses.BUTTON5_PRESSED,
    #curses.BUTTON5_RELEASED,
    #curses.BUTTON5_CLICKED,
    #curses.BUTTON5_DOUBLE_CLICKED,
    #curses.BUTTON5_TRIPLE_CLICKED,
    curses.BUTTON_SHIFT,
    curses.BUTTON_CTRL,
    curses.BUTTON_ALT,
    curses.ALL_MOUSE_EVENTS,
    curses.REPORT_MOUSE_POSITION]

  for i in val:
    print('{:b}'.format(i))

def pad_panel_test(stdscr):
  stdscr.bkgd('.')
  stdscr.border()
  panel_stdscr = curses.panel.new_panel(stdscr)

  win_height = 10
  win_width = 20
  win0 = curses.newwin(win_height, win_width, 5, 5)
  win0.bkgd('N')
  win0.border()
  panel0 = curses.panel.new_panel(win0)
  
  pad_x = 0
  pad_y = 0
  pad_xmax = 26
  pad_ymax = 26
  pad_x0 = 20
  pad_y0 = 10
  
  
  pad = curses.newpad(pad_ymax, pad_xmax+1)
  # These loops fill the pad with letters; addch() is
  # explained in the next section
  for y in range(0, pad_ymax):
      for x in range(0, pad_xmax):
          pad.addch(y, x, ord('a') + max(x,y) % 26)

  #pad.bkgd('P')
  #pad.border()
  #panel_pad = curses.panel.new_panel(pad)

  #pad.border()

  # Displays a section of the pad in the middle of the screen.
  # (0,0) : coordinate of upper-left corner of pad area to display.
  # (5,5) : coordinate of upper-left corner of window area to be filled
  #         with pad content.
  # (20, 75) : coordinate of lower-right corner of window area to be
  #          : filled with pad content.
  stdscr.refresh()
  
  panel1 = curses.panel.new_panel(stdscr)
  panel1.hide()
  panel0.show()
  panel0.top()
  curses.panel.update_panels()
  stdscr.refresh()
  win0.refresh()
  curses.doupdate()
  
  panel_y = 0
  panel_x = 0
  
  while(True):
    panel0.move(panel_y, panel_x)
    pad.refresh( pad_y, pad_x, pad_y0, pad_x0, pad_y0+win_height, pad_x0+win_width)
    #stdscr.refresh()
    curses.panel.update_panels()
    curses.doupdate()
    c = stdscr.getch()
    if c == ord('q') or c == curses.ascii.ESC:
      break
    if c == ord('s'):
      #panel0.top()
      panel0.show()
    if c == ord('h'):
      panel0.hide()
      #panel0.bottom()
    elif c == curses.KEY_UP and pad_y > 0:
      pad_y -= 1
    elif c == curses.KEY_DOWN and pad_y+1 < pad_ymax - win_height:
      pad_y += 1
      panel_y += 1
    elif c == curses.KEY_LEFT and pad_x > 0:
      pad_x -= 1
    elif c == curses.KEY_RIGHT and pad_x+1 < pad_xmax - win_width:
      pad_x += 1
    #stdscr.refresh()

if __name__ == '__main__':
  #print(curses.BUTTON1_PRESSED)
  #print(type(curses.BUTTON1_PRESSED))
  #print(curses.BUTTON2_PRESSED)
  #print(type(curses.BUTTON2_PRESSED))
  # curses.wrapper(pad_panel_test)
  curses.wrapper(mouse_test)
  #mouse_values()
  #N = max([i[1] for i in non_color_attributes])
  #print(len('{:b}'.format(N)))

##stdscr = curses.initscr()
##print(curses.LINES)
##print(curses.COLS)
#wrapper(cursor_move)
