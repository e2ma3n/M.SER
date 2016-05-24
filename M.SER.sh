#! /bin/bash
# Programming and idea by : E2MA3N [Iman Homayouni]
# Gitbub : https://github.com/e2ma3n
# Email : e2ma3n@Gmail.com
# Website : http://OSLearn.ir
# License : GPL v3.0
# CSS and html templates by http://startbootstrap.com/
# M.SER v1.0 - Core [Monitor. system events and resources]
# --------------------------------------------------------------- #

www="/var/www/html/index.html"
interface="eth0"


function up {
	awk -v line=$1 -v new_content="$2" '{
		if (NR == line) {
			print new_content;
		} else {
			print $0;
		}
	}' $3
}


# Create M.SER directory in /tmp
[ ! -d /tmp/M.SER/ ] && mkdir -p /tmp/M.SER/

# Uptime
time=`uptime -p 2> /dev/null`
if [ "$?" = "0" ] ; then
	time=`echo "$time" | sed 's/^up//' | cut -d ',' -f 1,2,3`
else
	time=`uptime | rev | cut -d ',' -f 1,2,3,4 --complement | rev | grep -o -P '.{0,0}up.{0,}'`	
fi
up 57 "<p>$time</p>" $www > /tmp/M.SER/index1.html

# CPU Usage
cpu=`iostat | grep -A1 '%idle' | tr " " : | tr -s : | cut -d : -f 7 | tail -n1 | cut -d . -f 1`
cpu=`expr 100 - $cpu`
up 66 "<p>$cpu Percent</p>" /tmp/M.SER/index1.html > /tmp/M.SER/index2.html
rm -f /tmp/M.SER/index1.html

# RAM Usage
ram=`free -m | grep Mem | tr -s " " : | cut -d : -f 3`
up 75 "<p>$ram Megabyte</p>" /tmp/M.SER/index2.html > /tmp/M.SER/index3.html
rm -f /tmp/M.SER/index2.html

# Bandwidth Usage
download=`ifconfig $interface | grep RX | grep bytes | cut -d ')' -f 1 | cut -d '(' -f 2`
upload=`ifconfig $interface | grep bytes | grep -o -P '.{0,0}TX.{0,}' | cut -d '(' -f 2 | tr -d ')'`
up 84 "<p>$download receive / $upload send</p>" /tmp/M.SER/index3.html > /tmp/M.SER/index4.html
rm -f /tmp/M.SER/index3.html

# Active users
n=`users | wc -w`
up 93 "<p>$n Person</p>" /tmp/M.SER/index4.html > /tmp/M.SER/index5.html
rm -f /tmp/M.SER/index4.html

# SSH Attacks
if [ -f /var/log/auth.log ] ; then
	n=`grep 'Failed password' /var/log/auth.log | wc -l`
elif [ -f /var/log/secure ] ; then
	n=`grep 'Failed password' /var/log/secure | wc -l`
fi
up 102 "<p>$n SSH Attack on server</p>" /tmp/M.SER/index5.html > /tmp/M.SER/index6.html
rm -f /tmp/M.SER/index5.html

# Disk Usage
n=`df | rev | grep "^/" | tr -s ' ' | cut -d ' ' -f 2 | rev | tr -d '%' | head -n 1`
up 111 "<p>$n Percent</p>" /tmp/M.SER/index6.html > /tmp/M.SER/index7.html
rm -f /tmp/M.SER/index6.html

# Ping Latency
Latency=`ping -c 1 8.8.8.8 | grep 'time=' | cut -d '=' -f 4`
up 120 "<p>$Latency from 8.8.8.8</p>" /tmp/M.SER/index7.html > /tmp/M.SER/index8.html
rm -f /tmp/M.SER/index7.html

# Last Update
time=`date +'%e %b %Y - %H:%M:%S'`
up 131 "<p>Last Update : $time</p>" /tmp/M.SER/index8.html > /tmp/M.SER/index9.html
rm -f /tmp/M.SER/index8.html

# update index.html
mv /tmp/M.SER/index9.html $www
rm -f /tmp/M.SER/index9.html
