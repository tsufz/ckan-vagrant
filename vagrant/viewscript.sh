#!/bin/bash
echo "Installing git and cloning repositories"
source /usr/lib/ckan/default/bin/activate
cd /usr/lib/ckan/default/src
sudo apt-get install -qq -y git
sudo git clone -q https://github.com/ckan/ckanext-viewhelpers
sudo git clone -q https://github.com/ckan/ckanext-basiccharts
sudo git clone -q https://github.com/ckan/ckanext-dashboard

echo "Installing pip (needed for additional views)"
sudo apt-get install -qq -y python-pip


echo "Installing python setuptools"
sudo wget -q https://bootstrap.pypa.io/ez_setup.py
sudo python ez_setup.py > /dev/null
sudo rm *.zip

echo "Installing views"
pip -q install ./ckanext-viewhelpers
pip -q install ./ckanext-basiccharts
pip -q install ./ckanext-dashboard