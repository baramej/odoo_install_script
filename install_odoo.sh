#! /bin/bash

if [[ $EUID -ne 0 ]]; then
   echo -e "\033[0;31mThis script must be run as root\033[0m"
   exit 1
fi

echo -n "Enter your Github Personal Access Token: "
read GITHUB_PAT

print() {
	echo -en "\033[0;31m$1\033[0m"
}

println() {
	echo -e "\033[0;31m$1\033[0m"
}

install_dependencies() {
	apt update && apt upgrade -y
	apt install postgresql postgresql-client wkhtmltopdf -y
}

install_odoo() {
	wget -O - https://nightly.odoo.com/odoo.key | apt-key add -
	echo "deb http://nightly.odoo.com/15.0/nightly/deb/ ./" >> /etc/apt/sources.list.d/odoo.list
	apt install odoo -y	
}

fetch_enterprise_addons() {
	cd /usr/lib/python3/dist-packages
	git clone "https://isyedaliraza:$GITHUB_PAT@github.com/odoo/enterprise.git" --depth 1 -b 15.0
}

edit_odoo_conf() {
	cd /etc/odoo/
	sed -i 's/workers = 0/workers = 1/' odoo.conf
	sed -i 's/list_db = True/list_db = False/' odoo.conf
}

println "Installing dependencies"
install_dependencies

println "Installing Odoo 15"
install_odoo

println "Fetching Odoo 15 enterprise addons"
fetch_enterprise_addons
