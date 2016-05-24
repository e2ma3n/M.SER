#! /bin/bash
# Programming and idea by : E2MA3N [Iman Homayouni]
# Gitbub : https://github.com/e2ma3n
# Email : e2ma3n@Gmail.com
# Website : http://OSLearn.ir
# License : GPL v3.0
# CSS and html templates by http://startbootstrap.com/
# M.SER v1.0 - Installer [Monitor. system events and resources]
# --------------------------------------------------------------- #

# check root privilege
[ "`whoami`" != "root" ] && echo '[-] Please use root user or sudo' && exit 1

# help function
function help_f {
	echo 'Usage: '
	echo '	sudo ./install.sh -i [install program]'
	echo '	sudo ./install.sh -u [help to uninstall program]'
	echo '	sudo ./install.sh -c [check dependencies]'
}

# uninstall program from system
function uninstall_f {
	echo 'For uninstall program:'
	echo '	sudo rm -rf /opt/M.SER_v1.0/'
	echo '	sudo rm -f /YOUR-WEB-SERVER-ADDRESS/css/bootstrap.min.css'
	echo '	sudo rm -f /YOUR-WEB-SERVER-ADDRESS/css/heroic-features.css'
	echo '	sudo rm -f /YOUR-WEB-SERVER-ADDRESS/index.html'
}

# check dependencies in system
function check_f {
	echo '[+] check dependencies in system:  '
	for program in whoami sleep cat head tail cut awk date grep mv cp rm iostat uptime free ifconfig netstat
	do
		if [ ! -z `which $program 2> /dev/null` ] ; then
			echo "[+] $program found"
		else
			echo "[-] Error: $program not found"
		fi
		sleep 0.5
	done
}

function up {
	awk -v line=$1 -v new_content="$2" '{
		if (NR == line) {
			print new_content;
		} else {
			print $0;
		}
	}' $3
}

# install program in system
function install_f {

	# print header
	sleep 1.5
	echo '[+] Monitor. system events and resources [M.SER v1.0]'
	sleep 1.5
	echo '[+] Tested on all popular linux distributions such as debian 7, debian 8, ubuntu server, CentOS 6 and CentOS 7'
	sleep 1.5
	echo '[+] Suggestions: Install M.CSS for monitoring and control system services (restart and stop 12 popular services such as apache and ...)'
	sleep 2.5
	echo '[+] Suggestions: Install M.SAL for monitoring system authentication logs (such as ssh attack, ssh login and ...)'
	sleep 2.5
	echo '[+] Suggestions: Install M.SQL for monitoring squid logs (all logs)'
	sleep 2.5
	echo -en '[+] Press enter for continue or press ctrl+c for exit' ; read
	sleep 4

	# Create main directory
	echo '[+]'
	[ ! -d /opt/M.SER_v1.0/ ] && mkdir -p /opt/M.SER_v1.0/ && echo '[+] Main Directory created' || echo '[-] Error: /opt/M.SER_v1.0/ exist'
	echo '[+]'
	sleep 1

	# Insert web server directory
	for (( ;; )) ; do
		echo '[+] Enter web server directory. For example, /var/www/html'
		echo '[!] Warning: If index.html and css directory exists in your address, Please taking backup from them.'
		sleep 3
		echo -en '[+] Enter address: ' ; read www
		echo -en "[+] Web server directory is $www. Are you sure ? [y/n]: " ; read question
		if [ "$question" = "y" ] ; then
			# Insert web server directory to 'M.SER.sh'
			up 11 "www=$www/index.html" M.SER.sh > M.SAL_new.sh
			mv M.SAL_new.sh M.SER.sh
			echo '[+] M.SER.sh Updated'
			echo '[+]'
			break
		else
			echo '[+]'
		fi
	done

	# Main Interface
	for (( ;; )) ; do
		echo '[+] Enter main server interface. for example, eth0'
		echo -en '[+] Enter interface: ' ; read interface
		echo -en "[+] Your server interface is $interface. Are you sure ? [y/n]: " ; read question
		if [ "$question" = "y" ] ; then
			up 12 "interface=$interface" M.SER.sh > M.SAL_new.sh
			mv M.SAL_new.sh M.SER.sh
			echo '[+] M.SER.sh Updated'
			echo '[+]'
			break
		else
			echo '[+]'
		fi
	done

	# SSH Port
	for (( ;; )) ; do
		echo "[+] Enter SSH Port. default is 22"
		echo -en "[+] Enter Port: " ; read port
		echo -en "[+] SSH Port is $port. Are you sure ? [y/n]: " ; read question
		if [ "$question" = "y" ] ; then
			up 13 "listen=$port" M.SER.sh > M.SAL_new.sh
			mv M.SAL_new.sh M.SER.sh
			echo '[+] M.SER.sh Updated'
			echo '[+]'
			break
		else
			echo '[+]'
		fi
	done

	# Create css directory in web server
	[ ! -d $www/css ] && mkdir -p $www/css && echo "[+] css Directory created in $www" || echo "[-] Error: $www/css exist"
	sleep 1

	# Copy index.html , bootstrap.min.css and heroic-features.css in web server
	echo '[+]'
	[ ! -f $www/css/bootstrap.min.css ] && cp bootstrap.min.css $www/css/ && chmod 644 $www/css/bootstrap.min.css && echo '[+] bootstrap.min.css copied' || echo "[-] Error: $www/css/bootstrap.min.css exist"
	sleep 0.5
	[ ! -f $www/css/heroic-features.css ] && cp heroic-features.css $www/css/ && chmod 644 $www/css/heroic-features.css && echo '[+] heroic-features.css copied' || echo "[-] Error: $www/css/heroic-features.css exist"
	sleep 0.5
	cp index.html $www && chmod 644 $www/index.html && echo '[+] index.html copied'
	echo '[+]'
	sleep 1

	# Insert home page address in index.html
	for (( ;; )) ; do
		echo '[+] Enter your home page. For example, http://OSLearn.ir'
		sleep 1
		echo -en "[+] Enter home page: " ; read home
		echo -en "[+] Your home page is $home. Are you sure ? [y/n]: " ; read question
		if [ "$question" = "y" ] ; then
			up 30 "<a class='navbar-brand' href="$home">Home</a>" $www/index.html > $www/index.html.new
			mv $www/index.html.new $www/index.html
			echo "[+] $www/index.html Updated"
			echo '[+]'
			break
		else
			echo '[+]'
		fi
	done

	# M.SAL Program
	echo -en '[+] Do you have installed M.SAL ? [y/n]: ' ; read question
	if [ "$question" = "y" ] ; then
		for (( ;; )) ; do
			echo '[+] Enter M.SAL address. For example, http://example.com/M.SAL/'
			echo -en '[+] Enter M.SAL address: ' ; read address
			echo -en "[+] M.SAL address is $address. Are you sure ? [y/n]: " ; read question
			if [ "$question" = "y" ] ; then
				up 34 "<li><a href="$address">M.SAL</a></li>" $www/index.html > $www/index.html.new
				mv $www/index.html.new $www/index.html
				echo "[+] $www/index.html Updated"
				echo '[+]'
				break
			else
				echo '[+]'
			fi
		done
	fi

	# M.SQL Program
	echo -en '[+] Do you have installed M.SQL ? [y/n]: ' ; read question
	if [ "$question" = "y" ] ; then
		for (( ;; )) ; do
			echo '[+] Enter M.SQL address. For example, htp://example.com/M.SQL/'
			echo -en '[+] Enter M.SQL address: ' ; read address
			echo -en "[+] M.SQL address is $address. Are you sure ? [y/n]: " ; read question
			if [ "$question" = "y" ] ; then
				up 35 "<li><a href="$address">M.SQL</a></li>" $www/index.html > $www/index.html.new
				mv $www/index.html.new $www/index.html
				echo "[+] $www/index.html Updated"
				echo '[+]'
				break
			else
				echo '[+]'
			fi
		done
	fi
	
	# M.CSS Program
	echo -en '[+] Do you have installed M.CSS ? [y/n]: ' ; read question
	if [ "$question" = "y" ] ; then
		for (( ;; )) ; do
			echo '[+] Enter M.CSS address. For example, htp://example.com/M.CSS/'
			echo -en '[+] Enter M.CSS address: ' ; read address
			echo -en "[+] M.CSS address is $address. Are you sure ? [y/n]: " ; read question
			if [ "$question" = "y" ] ; then
				up 36 "<li><a href="$address">M.CSS</a></li>" $www/index.html > $www/index.html.new
				mv $www/index.html.new $www/index.html
				echo "[+] $www/index.html Updated"
				echo '[+]'
				break
			else
				echo '[+]'
			fi
		done
	else
		echo '[+]'
	fi

	# Copy M.SER.sh
	[ ! -f /opt/M.SER_v1.0/M.SER.sh ] && cp M.SER.sh /opt/M.SER_v1.0/ && chmod 755 /opt/M.SER_v1.0/M.SER.sh && echo '[+] M.SER.sh copied' || echo '[-] Error: /opt/M.SER_v1.0/M.SER.sh exist'
	sleep 1
	
	# Add M.SER.sh to crontab file
	[ -f /etc/crontab ] && echo '*/1 *   * * *   root    /opt/M.SER_v1.0/M.SER.sh' >> /etc/crontab && echo -e "[+] M.SER.sh added to crontab file\n[+] M.SER automatically running every 1 minute" || echo -e "[-] Error: /etc/crontab not found\n[-] You can start program manually or starting up script as a daemon using another way."
	sleep 1
	
	# Copy README
	[ ! -f /opt/M.SER_v1.0/README ] && cp README /opt/M.SER_v1.0/README && chmod 644 /opt/M.SER_v1.0/README && echo '[+] README copied' || echo '[-] Error: /opt/M.SER_v1.0/README exist'
	echo "[+]"
	sleep 1

	# echo footer
	echo '[+] Please see README'
	sleep 0.5
	echo '[!] Warning: You should run program as root.'
	sleep 0.5
	echo '[+] You can view source code from /opt/M.SER_v1.0/M.SER.sh'
	echo '[+] Done'
}

case $1 in
	-i) install_f ;;
	-c) check_f ;;
	-u) uninstall_f ;;
	*) help_f ;;
esac
