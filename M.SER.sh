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
listen="22"
root="/dev/sda1"


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
time=`uptime -p |  sed 's/^up//' | cut -d ',' -f 1,2,3`
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
download=`ifconfig $interface | tail -n 2 | head -n 1 | cut -d '(' -f 2 | cut -d ')' -f 1`
upload=`ifconfig $interface | tail -n 2 | head -n 1 | cut -d '(' -f 3 | tr -d ')'`
up 84 "<p>$download receive / $upload send</p>" /tmp/M.SER/index3.html > /tmp/M.SER/index4.html
rm -f /tmp/M.SER/index3.html

# Active users
n=`netstat -ptn | grep $listen | wc -l`
up 93 "<p>$n Person</p>" /tmp/M.SER/index4.html > /tmp/M.SER/index5.html
rm -f /tmp/M.SER/index4.html

# SSH Attacks
n=`grep 'Failed password' /var/log/auth.log | wc -l`
up 102 "<p>$n SSH Attack on server</p>" /tmp/M.SER/index5.html > /tmp/M.SER/index6.html
rm -f /tmp/M.SER/index5.html

# Disk Usage
n=`df -T | grep "$root" | tr -s " " | rev | cut -d ' ' -f 2 | rev | tr -d '%'`
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
