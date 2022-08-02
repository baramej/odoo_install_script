#! /bin/bash

GITHUB_PAT=""

fetch_sources() {
	echo "Fetching the sources"
	git clone "https://github.com/odoo/odoo.git" --depth 1 -b 15.0
	git clone "https://isyedaliraza:$GITHUB_PAT@github.com/odoo/enterprise.git" --depth 1 -b 15.0
	mv ./enterprise/* ./odoo/addons
	rm -rf ./enterprise
	echo "Fetched the sources successfully"
}

install_python() {
	echo "Installing Python 3.7"
	sudo apt install software-properties-common -y
	sudo add-apt-repository ppa:deadsnakes/ppa -y
	sudo apt install python3.7 python3.7-distutils python3.7-dev python3-pip -y
	echo -e "$(python3.7 --version) installed successfully\n"
	echo "Installing python dependencies"
	sudo apt install libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev \
		libtiff5-dev libjpeg8-dev libopenjp2-7-dev zlib1g-dev libfreetype6-dev \
		liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev libpq-dev -y
	echo "Python dependencies installed successfully"
}

install_postgresql() {
	echo "Installing PostgreSQL"
	sudo apt install postgresql postgresql-client -y
	sudo su - postgres -c "createuser $USER"
	sudo su - postgres -c "createdb $USER"
	echo "Installed PostgreSQL successfully"
}

install_odoo_dependencies() {
	echo "Installing odoo dependencies"
	cd ./odoo
	python3.7 -m pip install setuptools wheel
	python3.7 -m pip install -r requirements.txt
	cd ..
	echo "Odoo dependencies installed successfully"
}

install_node_and_rtlcss() {
	echo "Installing nodejs and dependencies"
	sudo apt install nodejs npm -y
	sudo npm install -g rtlcss
	echo "Installed nodejs and dependencies successfully"
}

fetch_sources
install_python
install_postgresql
install_odoo_dependencies
install_node_and_rtlcss
