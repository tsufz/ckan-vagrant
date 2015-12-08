#!/bin/bash
echo "Installing git and cloning repositories"
source /usr/lib/ckan/default/bin/activate
cd /usr/lib/ckan/default/src
sudo apt-get install -qq -y git
sudo git clone -q https://github.com/ckan/ckanext-viewhelpers
sudo git clone -q https://github.com/ckan/ckanext-basiccharts
sudo git clone -q https://github.com/ckan/ckanext-dashboard
sudo git clone -q https://github.com/ckan/ckanext-harvest
sudo git clone -q https://github.com/openresearchdata/ckanext-oaipmh
echo "Installing pip (needed for additional views)"
sudo apt-get install -qq -y python-pip


echo "Installing python setuptools"
sudo wget -q https://bootstrap.pypa.io/ez_setup.py
sudo python ez_setup.py > /dev/null
sudo rm *.zip

echo "Installing basic views"
pip -q install ./ckanext-viewhelpers
pip -q install ./ckanext-basiccharts
pip -q install ./ckanext-dashboard

echo "Installing redis"
cd /home/vagrant/
sudo apt-get install -qq -y tcl
sudo wget -q http://download.redis.io/releases/redis-stable.tar.gz
tar -zxvf redis-stable.tar.gz
cd ./redis-stable
sudo make install
cd utils
echo -ne '\n' | sudo ./install_server.sh

echo "Installing harvest views"
cd /usr/lib/ckan/default/src
cd ./ckanext-harvest
pip install -r pip-requirements.txt
cd ..
sudo /usr/lib/ckan/default/bin/pip install -q ./ckanext-harvest



echo "Installing prerequisites for oaipmh"
sudo apt-get install -qq -y zlib1g-dev libxml2-dev libxslt1-dev python-dev 

cd ./ckanext-oaipmh
sudo /usr/lib/ckan/default/bin/pip install -r requirements.txt
cd ..
sudo /usr/lib/ckan/default/bin/pip install ./ckanext-oaipmh