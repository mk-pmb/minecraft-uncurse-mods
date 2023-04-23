#!/bin/sed -urf
# -*- coding: UTF-8, tab-width: 2 -*-

s~^date=\S+\t~~
s~\tjava=~\a~
s~^([^\a]+)\a([0-9]+)~                  - { java: \2,\t\1~
s~\tmodver=~ artifact: 'editsign_v~
s~\tmcr=~_mc~
s~\tloader=\t~\t~
s~\tloader=~_~
s~\ttag=~.jar', tag: '~
s~\tcommit=.*$~' }~
