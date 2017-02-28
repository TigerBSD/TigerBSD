#!/usr/bin/env bash

usage ()
{
  echo "Usage: $0 [-a]"
}

all=
if [ $# -gt 1 ] ; then
  usage
  exit 1
elif [ $# -eq 1 ] ; then
  if [ "$1" == "-a" ] ; then
    all=true
  else
    usage
    exit 1
  fi
fi

unison240-text -auto -batch lapdesk_school
unison240-text -auto -batch lapdesk_misc

if [ ! -z "$all" ] ; then
  unison240-text -auto -batch lapdesk_stor
  unison240-text -auto -batch lapdesk_lol
fi
