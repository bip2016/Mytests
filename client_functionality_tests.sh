#!/bin/bash


#first script
. shell-terminfo

function Warning {
                  color_text ' Warning!' 'fg yellow bg black bold'
                  echo -en '\n'
                  exit
                 }

function Error {
                  color_text '✘ Error!' 'fg red bg black bold'
                  echo -en '\n'
                  exit
                }


function Success {
                color_text '✔ Success!' 'fg green bg black bold'
                echo -en '\n'
                exit
                 }


function error_exit
                    {
                     color_text '✘ iked do not isInstalled!' 'fg red bg black bold'
                     echo -en '\n'
                     exit 1
                    }



function echo_fail {
                    color_text '✘ ike incorrectly installed !' 'fg red bg black bold'
                    echo -en '\n'

}

function echo_pass {

                     color_text '✘ ike correctly installed !' 'fg green bg black bold'
                     echo -en '\n'

}

function echo_interrupt {
                    color_text '✘ Interrupt installer !' 'fg red bg black bold'
                    echo -en '\n'

}


function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;
            [Nn]*) echo_interrupt; return  1  ;
        esac
    done
}

#---App is installed?---------------------------------------------
isInstalled() {
    if rpm -q $1 &> /dev/null; then
        echo_pass
        return 0;
    else
        echo_fail
        return 1;
    fi
}

function Description {
  color_text '1.Installation ike test!' 'fg blue bg black bold'
  echo -en '\n'
  color_text '2.Run ike-daemon test!' 'fg blue bg black bold'
  echo -en '\n'
  color_text '3.Run GUI-interface for iked test!' 'fg blue bg black bold'
  echo -en '\n'
  color_text '4.ppp0-interface test!' 'fg blue bg black bold'
  echo -en '\n'
  color_text '5.IPSEC-encryption test!' 'fg blue bg black bold'
  echo -en '\n'
}

Description

#----Need install ike?--------------------------------------
if yes_or_no  "Are you shure install ike?" && apt-get install ike ;
then isInstalled ike ;
else
echo "";
fi;

#----------------------------------------------------------
ret=$(ps aux | grep [i]ked | wc -l)

if [ "$ret" -eq 0 ]
   then {
         color_text 'Run ike-daemon ' 'fg yellow bg black bold'
         echo -en '\n'
          sleep 1  #delay
          iked
          2>/dev/null
          sleep 1
        }
fi;
#----------------------------------------------------------
ret1=$(ps aux | grep [i]ked | pgrep iked)

if  [ -n "$ret1" ]
    then {
        	if [ "$ret1" -gt 0 ]
	           then {
                      color_text '✔ ike-daemon  is running!' 'fg green bg black bold'
                      echo -en '\n'
		              }
		         else
		              {
                      color_text '✘ ike-daemon  is not running!' 'fg red bg black bold'
                      echo -en '\n'
	              	}
	      	fi;
	       }
    else
         {
           color_text '✘ ike-daemon  is not running!' 'fg red bg black bold'
           echo -en '\n'
         }
fi;

ret4=$(ps aux | grep [q]ikea | wc -l)

if [ "$ret4" -eq 0 ]
   then {
          color_text '✔ Running GUI for ike!' 'fg yellow bg black bold'
          echo -en '\n'

          sleep 1  #delay
          exec "qikea" & color_text '>>>' 'fg yellow bg black bold'

          2>/dev/null
          sleep 1
        }
fi;


#----------------------------------------------------------
ret2=$(ps aux | grep [q]ikea | pgrep qikea)

if  [ -n "$ret2" ]
    then {
          if [ "$ret2" -gt 0 ]
             then {
                   echo -en '\n'
                    color_text '✔  GUI for ike is running!' 'fg green bg black bold'
                    echo -en '\n'
                  }
             else
                  {
                    echo -en '\n'
                    color_text '✘  GUI for ike is not running!' 'fg red bg black bold'
                    echo -en '\n'

                  }
          fi;
         }
    else
         {
           echo -en "${RED}✘Ошибка запуска GUI!${NORMAL}\n"
         }
fi;
#-------------------------------------------------------------

if  /usr/sbin/ifplugstatus -a |grep -E 'ppp0'  ;
  then
  {
  color_text '✔  ppp0-interface is up!' 'fg green bg black bold'
  echo -en '\n'


    if ( tcpdump -c 5 -i ppp0 -l | grep 'isakmp' )
      then
      {
          color_text '✔  IPSEC-encryption enabled!' 'fg green bg black bold'
          echo -en '\n'
      }
      else
      {

          color_text '✘  IPSEC-encryption do not enabled!' 'fg red bg black bold'
          echo -en '\n'
      }
    fi;
  }
 else
  {
    color_text '✔  ppp0-interface is not up!' 'fg red bg black bold'
    echo -en '\n'

  }
 fi;
