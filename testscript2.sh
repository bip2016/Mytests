#!/bin/bash
#first script
# Дополнительные свойства для текта:
BOLD='\033[1m'       #  ${BOLD}      # жирный шрифт (интенсивный цвет)
DBOLD='\033[2m'      #  ${DBOLD}    # полу яркий цвет (тёмно-серый, независимо от цвета)
NBOLD='\033[22m'      #  ${NBOLD}    # установить нормальную интенсивность
UNDERLINE='\033[4m'     #  ${UNDERLINE}  # подчеркивание
NUNDERLINE='\033[4m'     #  ${NUNDERLINE}  # отменить подчеркивание
BLINK='\033[5m'       #  ${BLINK}    # мигающий
NBLINK='\033[5m'       #  ${NBLINK}    # отменить мигание
INVERSE='\033[7m'     #  ${INVERSE}    # реверсия (знаки приобретают цвет фона, а фон -- цвет знаков)
NINVERSE='\033[7m'     #  ${NINVERSE}    # отменить реверсию
BREAK='\033[m'       #  ${BREAK}    # все атрибуты по умолчанию
NORMAL='\033[0m'      #  ${NORMAL}    # все атрибуты по умолчанию

# Цвет текста:
BLACK='\033[0;30m'     #  ${BLACK}    # чёрный цвет знаков
RED='\033[0;31m'       #  ${RED}      # красный цвет знаков
GREEN='\033[0;32m'     #  ${GREEN}    # зелёный цвет знаков
YELLOW='\033[0;33m'     #  ${YELLOW}    # желтый цвет знаков
BLUE='\033[0;34m'       #  ${BLUE}      # синий цвет знаков
MAGENTA='\033[0;35m'     #  ${MAGENTA}    # фиолетовый цвет знаков
CYAN='\033[0;36m'       #  ${CYAN}      # цвет морской волны знаков
GRAY='\033[0;37m'       #  ${GRAY}      # серый цвет знаков

#Цвет фона
BGBLACK='\033[40m'     #  ${BGBLACK}
BGRED='\033[41m'       #  ${BGRED}
BGGREEN='\033[42m'     #  ${BGGREEN}
BGBROWN='\033[43m'     #  ${BGBROWN}
BGBLUE='\033[44m'     #  ${BGBLUE}
BGMAGENTA='\033[45m'     #  ${BGMAGENTA}
BGCYAN='\033[46m'     #  ${BGCYAN}
BGGRAY='\033[47m'     #  ${BGGRAY}
BGDEF='\033[49m'      #  ${BGDEF}

tput sgr0 ;    # Возврат цвета в "нормальное" состояние


function ifup {
    if [[ ! -d /sys/class/net/${1} ]]; then
        echo -en "${RED}✘ Нет такого интерфейса: $1\n${NORMAL}"  
        1>&2
        return 1
    else
        [[ $(</sys/class/net/${1}/operstate) == up ]]
    fi
}




function error_exit {
  echo -en "${RED}✘ iked не установлен! ${NORMAL}\n" 1>&2
  exit 1
}

# Функция, если неуспех установки
# example
# echo echo_fail "No"
function echo_fail {
  # echo first argument in red
  printf "\e[31m✘ike: установка прошла неккоректно! ${1}"
  # reset colours back to normal
  printf "\033\e[0m"
}
# Функция, если успех установки
# example
# echo echo_fail "Yes"
function echo_pass {
  # echo first argument in green
  printf "\e[32m✔ike: установка прошла успешно!\n${1}"
  # reset colours back to normal
  printf "\033\e[0m"
}
function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) echo -en "${RED}✘Прерывание: отмена установки! ${NORMAL}" ; return  1  ;
        esac
    done
}
#функция проверки: установлено ли приложение
isInstalled() {
    if rpm -q $1 &> /dev/null; then
        echo_pass 
        return 1;
    else
        echo_fail 
        return 0;
    fi
}
#Описание тест-кейса
echo -en "${BLUE}Тест-кейс ike.\nОсуществляется проверка следующих действий:\n1.Успешность установки ike. 
2.Успешность запуска ike-демона.\n3.Успешность GUI-интерфейса для ike.\n4.Проверка ppp0-интерфейса и IPSEC-шифрованного канала.\n${NORMAL}\n";

#echo "0: $0";
#echo "1: $1";
#echo "2: $2";


#$0 >/dev/null;
#$1 >/dev/null;
#$2 >/dev/null;

# если устанавливаем, то проверяем иначе ничего не делаем
if yes_or_no  "Вы действительно хотите установить ike?" && apt-get install ike ;
then isInstalled ike ;
else
echo "";
fi;

#----------------------------------------------------------
ret=$(ps aux | grep [i]ked | wc -l)

if [ "$ret" -eq 0 ] 
   then {
	        echo -en "${YELLOW}✔ Запуск демона iked${NORMAL}\n" #output text
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
		                echo -en "${GREEN}✔Демон iked запущен!${NORMAL}\n"
		              }	
		         else
		              {
	                	echo -en "${RED}✘Ошибка запуска iked !${NORMAL}\n"	
	              	}	
	      	fi;
	       }
    else
         {
           echo -en "${RED}✘Ошибка запуска iked !${NORMAL}\n"  
         }	
fi;

ret4=$(ps aux | grep [q]ikea | wc -l)
if [ "$ret4" -eq 0 ] 
   then {
          echo -en "${YELLOW}✔ Запуск GUI${NORMAL}\n" #output text
          sleep 1  #delay
          exec "qikea" & echo ">>>>>>"
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
                    echo -en "${GREEN}✔GUI запущен!${NORMAL}\n"
                  } 
             else
                  {
                    echo -en "${RED}✘Ошибка запуска GUI!${NORMAL}\n"  
                  } 
          fi;
         }
    else
         {
           echo -en "${RED}✘Ошибка запуска GUI!${NORMAL}\n"  
         }  
fi;

if ifup ppp0;
  then
      echo -en "${GREEN}✔Порт ppp0 поднят!${NORMAL}\n";
      tcpdump -i ppp0 | grep 'isakmp'
  else
      echo -en "${RED}✘Порт ppp0 не поднят!${NORMAL}\n";
fi;

 #2>/dev/null 
 #sleep 1
