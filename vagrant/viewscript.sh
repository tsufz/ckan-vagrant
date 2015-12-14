#!/bin/bash
echo "Installing git and cloning repositories"
source /usr/lib/ckan/default/bin/activate
cd /usr/lib/ckan/default/src
sudo apt-get install -qq -y git
sudo git clone -q https://github.com/ckan/ckanext-harvest
sudo git clone -q https://github.com/openresearchdata/ckanext-oaipmh
sudo git clone -q https://github.com/XVTSolutions/ckanext-extend_search


echo "Installing python setuptools"
sudo wget -q https://bootstrap.pypa.io/ez_setup.py
sudo python ez_setup.py > /dev/null
sudo rm *.zip

echo "Installing basic views"
sudo /usr/lib/ckan/default/bin/pip -q install -e 'git+https://github.com/ckan/ckanext-viewhelpers.git#egg=ckanext-viewhelpers'
sudo /usr/lib/ckan/default/bin/pip -q install -e 'git+https://github.com/ckan/ckanext-basiccharts.git#egg=ckanext-basiccharts'
sudo /usr/lib/ckan/default/bin/pip -q install -e 'git+https://github.com/ckan/ckanext-dashboard.git#egg=ckanext-dashboard'

echo "Installing add-ons"
sudo /usr/lib/ckan/default/bin/pip -q install -e 'git+https://github.com/ckan/ckanext-pages.git#egg=ckanext-pages'
sudo /usr/lib/ckan/default/bin/pip -q install -e 'git+https://github.com/ckan/ckanext-apihelper.git#egg=ckanext-apihelper'
sudo /usr/lib/ckan/default/bin/pip -q install -e 'git+https://github.com/datagovuk/ckanext-hierarchy.git#egg=ckanext-hierarchy'
sudo /usr/lib/ckan/default/bin/pip -q install -e 'git+https://github.com/ckan/ckanext-pdfview.git#egg=ckanext-pdfview'
sudo /usr/lib/ckan/default/bin/pip -q install -e 'git+https://github.com/okfn/ckanext-issues#egg=ckanext-issues'
sudo /usr/lib/ckan/default/bin/pip -q install -e 'git+https://github.com/openresearchdata/ckanext-ord-hierarchy#egg=ckanext-ord-hierarchy'

echo "Installing search extension"

echo "Installing current version of redis"
cd /home/vagrant/
sudo apt-get install -qq -y tcl
sudo wget -q http://download.redis.io/releases/redis-stable.tar.gz
tar -zxvf redis-stable.tar.gz
cd ./redis-stable
sudo make install > /dev/null
cd utils
echo -ne '\n' | sudo ./install_server.sh

echo "Installing harvest views"
cd /usr/lib/ckan/default/src
cd ./ckanext-harvest
sudo /usr/lib/ckan/default/bin/pip install -r pip-requirements.txt
cd ..
sudo /usr/lib/ckan/default/bin/pip install -q ./ckanext-harvest



echo "Installing prerequisites for oaipmh"
sudo apt-get install -qq -y zlib1g-dev libxml2-dev libxslt1-dev python-dev 
