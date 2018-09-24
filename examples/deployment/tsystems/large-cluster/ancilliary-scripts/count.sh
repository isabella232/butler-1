#!/bin/bash

ps auxww | egrep '/usr/local/bin/freebaye[s]' | egrep -v 'c /usr/local' | wc -l
