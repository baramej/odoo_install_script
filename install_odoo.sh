#! /bin/bash

GITHUB_PAT=""

fetch_sources() {
	git clone "https://github.com/odoo/odoo.git" --depth 1 -b 15.0
	git clone "https://isyedaliraza:$GITHUB_PAT@github.com/odoo/enterprise.git" --depth 1 -b 15.0
	mv ./enterprise/* ./odoo/addons
	rm -rf ./enterprise
}

install_python() {
	sudo apt install software-properties-common -y
	sudo add-apt-repository ppa:deadsnakes/ppa -y
	sudo apt install python3.7 python3.7-distutils python3.7-dev python3-pip -y
	sudo apt install libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev \
		libtiff5-dev libjpeg8-dev libopenjp2-7-dev zlib1g-dev libfreetype6-dev \
		liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev libpq-dev -y
}

install_postgresql() {
	sudo apt install postgresql postgresql-client -y
	sudo su - postgres -c "createuser $USER"
	sudo su - postgres -c "createdb $USER"
}

install_odoo_dependencies() {
	cd ./odoo
	python3.7 -m pip install setuptools wheel
	python3.7 -m pip install -r requirements.txt
	cd ..
}

install_node_and_rtlcss() {
	sudo apt install nodejs npm -y
	sudo npm install -g rtlcss
}

fetch_sources
install_python
install_postgresql
install_odoo_dependencies
install_node_and_rtlcss
