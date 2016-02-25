#!/bin/bash
source /usr/lib/ckan/default/bin/activate
cd /usr/lib/ckan/default/src

echo "Installing git"
sudo apt-get install -qq -y git
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
sudo /usr/lib/ckan/default/bin/pip -q install -e 'git+https://github.com/kata-csc/ckanext-ytp-comments.git@etsin#egg=ckanext-ytp-comments'
sudo apt-get install -qq -y libxml2 libxslt-dev python-dev zlib1g-dev
sudo /usr/lib/ckan/default/bin/easy_install lxml

echo "Installing search extension"
sudo /usr/lib/ckan/default/bin/pip -q install pytz
sudo /usr/lib/ckan/default/bin/pip -q install -e 'git+https://github.com/XVTSolutions/ckanext-extend_search#egg=ckanext-extend_search'

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
sudo /usr/lib/ckan/default/bin/pip -q install pika
sudo /usr/lib/ckan/default/bin/pip -q install -e 'git+https://github.com/ckan/ckanext-harvest#egg=ckanext-harvest'