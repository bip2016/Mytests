#!/bin/bash
. shell-terminfo
function Warning {
                  color_text ' Warning!' 'fg yellow bg black bold'
                  echo -en '\n'
                  exit
                 }

function Error {
                  color_text ' Error!' 'fg red bg black bold'
                  echo -en '\n'
                  exit
                }

function Success {
                color_text ' Success!' 'fg green bg black bold'
                echo -en '\n'
                exit
                 }
