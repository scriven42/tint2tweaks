#!/usr/bin/python3
# -*- coding: utf-8 -*-
# Hacked by me
# Originally from https://www.linuxquestions.org/questions/linux-newbie-8/caps-lock-indicator-4175601784/
# Keyboard LED indicator for embedding into things like tint2, xmobar and dzen2.
# The order is Caps Lock, Num Lock, Scroll Lock

import os

cs_off_rise=3500
n_off_rise=1600
status_text=os.popen("xset q | grep Caps | tr -s ' ' | cut -d ' ' -f 5,9,13").read()
#status_symbols=status_text.replace('on','▣').replace('off','▢')
#print(status_symbols, end='')
(caps,nums,scroll)=status_text.split()
caps=caps.replace('on','<b><big>A</big></b>').replace('off','<span rise="{}">a</span>'.format(cs_off_rise))
nums=nums.replace('on','<b><big>1</big></b>').replace('off','<span rise="{}">1</span>'.format(n_off_rise))
scroll=scroll.replace('on','<b><big>S</big></b>').replace('off','<span rise="{}">s</span>'.format(cs_off_rise))
print(' <span size="xx-large">|</span>{} {} {}<span size="xx-large">|</span>'.format(caps,nums,scroll))
