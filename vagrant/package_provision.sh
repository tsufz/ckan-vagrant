echo "This shell script is going to setup a running ckan instance based on the CKAN 2.4 packages"

echo "Switching the OS language"
locale-gen
export LC_ALL="en_US.UTF-8"
sudo locale-gen en_US.UTF-8

echo "Updating the package manager"
sudo apt-get update -qq

echo "Installing dependencies available via apt-get"
sudo apt-get install -qq -y nginx apache2 libapache2-mod-wsgi libpq5 curl

echo "Downloading the CKAN package"
sudo wget -q http://packaging.ckan.org/python-ckan_2.4-trusty_amd64.deb

echo "Installing the CKAN package"
sudo dpkg -i python-ckan_2.4-trusty_amd64.deb

echo "Preventing NGINX from being started on a reboot"
sudo update-rc.d -f nginx disable

echo "Changing the apache configuration back to port 80"
sudo cp /vagrant/vagrant/package_ports.conf /etc/apache2/ports.conf
sudo cp /vagrant/vagrant/package_ckan_default.conf /etc/apache2/sites-available/ckan_default.conf
sudo service apache2 restart

echo "Installing postgresql and jetty"
sudo apt-get install -qq -y postgresql solr-jetty openjdk-6-jdk

echo "Copying jetty configuration"
sudo cp /vagrant/vagrant/jetty /etc/default/jetty
sudo service jetty start

echo "Linking the solr schema file"
sudo mv /etc/solr/conf/schema.xml /etc/solr/conf/schema.xml.bak
sudo ln -s /usr/lib/ckan/default/src/ckan/ckanext/multilingual/solr/dutch_stop.txt /etc/solr/conf/dutch_stop.txt
sudo ln -s /usr/lib/ckan/default/src/ckan/ckanext/multilingual/solr/english_stop.txt /etc/solr/conf/english_stop.txt
sudo ln -s /usr/lib/ckan/default/src/ckan/ckanext/multilingual/solr/fr_elision.txt /etc/solr/conf/fr_elision.txt
sudo ln -s /usr/lib/ckan/default/src/ckan/ckanext/multilingual/solr/french_stop.txt /etc/solr/conf/french_stop.txt
sudo ln -s /usr/lib/ckan/default/src/ckan/ckanext/multilingual/solr/german_stop.txt /etc/solr/conf/german_stop.txt
sudo ln -s /usr/lib/ckan/default/src/ckan/ckanext/multilingual/solr/greek_stopwords.txt /etc/solr/conf/greek_stopwords.txt
sudo ln -s /usr/lib/ckan/default/src/ckan/ckanext/multilingual/solr/italian_stop.txt /etc/solr/conf/italian_stop.txt
sudo ln -s /usr/lib/ckan/default/src/ckan/ckanext/multilingual/solr/polish_stop.txt /etc/solr/conf/polish_stop.txt
sudo ln -s /usr/lib/ckan/default/src/ckan/ckanext/multilingual/solr/portuguese_stop.txt /etc/solr/conf/portuguese_stop.txt
sudo ln -s /usr/lib/ckan/default/src/ckan/ckanext/multilingual/solr/romanian_stop.txt /etc/solr/conf/romanian_stop.txt
sudo ln -s /usr/lib/ckan/default/src/ckan/ckanext/multilingual/solr/spanish_stop.txt /etc/solr/conf/spanish_stop.txt
sudo ln -s /usr/lib/ckan/default/src/ckan/ckanext/multilingual/solr/schema.xml /etc/solr/conf/schema.xml
# sudo ln -s /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema-2.0.xml /etc/solr/conf/schema.xml

sudo service jetty restart

echo "Creating a CKAN database in postgresql"
sudo -u postgres createuser -S -D -R ckan_default
sudo -u postgres psql -c "ALTER USER ckan_default with password 'pass'"
sudo -u postgres createuser -S -D -R datastore_default
sudo -u postgres psql -c "ALTER USER datastore_default with password 'pass'"
sudo -u postgres createdb -O ckan_default datastore_default -E utf-8
sudo -u postgres createdb -O ckan_default ckan_default -E utf-8
sudo cp /vagrant/vagrant/package_production.ini /etc/ckan/default/production.ini

sudo bash /vagrant/vagrant/viewscript.sh

sudo ckan datastore set-permissions | sudo -u postgres psql --set ON_ERROR_STOP=1

echo "Initializing CKAN database"
sudo ckan db init

paster --plugin=ckanext-harvest harvester initdb --config=/etc/ckan/default/production.ini


echo "Enabling filestore with local storage"
sudo mkdir -p /var/lib/ckan/default
sudo chown www-data /var/lib/ckan/default
sudo chmod u+rwx /var/lib/ckan/default
sudo chown --recursive www-data /etc/ckan/default/
sudo chmod --recursive u+rwx /etc/ckan/default/
sudo service apache2 restart

echo "Creating an admin user"
source /usr/lib/ckan/default/bin/activate
cd /usr/lib/ckan/default/src/ckan
paster --plugin=ckan user add admin email=admin@email.org password=pass -c /etc/ckan/default/production.ini
paster --plugin=ckan sysadmin add admin -c /etc/ckan/default/production.ini
paster --plugin=ckan user add harvest email=harvest@email.org password=none -c /etc/ckan/default/production.ini
paster --plugin=ckan sysadmin add harvest -c /etc/ckan/default/production.ini

# echo "Creating NORMAN dataset"
sudo bash /vagrant/vagrant/normandata.sh

echo "You should now have a running instance on http://ckan.lo"

#sudo reboot
