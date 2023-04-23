#!/bin/sed -urf
# -*- coding: UTF-8, tab-width: 2 -*-

s~^\s+~~
s~\s+$~~
/^#/d
/\t=$/!d
s~'+~'"&"'~g
s~(^|\t)([^ \t=]+)=~\1[\2]=\x27~g
s~\t~'\t~g
s~\t=$~~
