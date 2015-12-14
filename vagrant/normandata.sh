source /usr/lib/ckan/default/bin/activate
cd /usr/lib/ckan/default/src
sudo ckan create-test-data user -c /etc/ckan/default/production.ini

curl -s -H'Authorization: tester' 'http://localhost/api/action/package_create' \
--form name=norman_collaborative_trial_targets_and_suspects \
--form title="NORMAN Collaborative Trial Targets and Suspects" \
--form url=http://www.norman-network.com/?q=node/236 > /dev/null

curl -s -H'Authorization: tester' 'http://localhost/api/action/resource_create' \
--form url=http://www.norman-network.com/sites/default/files/files/suspectListExchange/Targ_Sus_NT-wID_LC_final.csv \
--form package_id=norman_collaborative_trial_targets_and_suspects \
--form name="LC Targets and suspects" > /dev/null

curl -s -H'Authorization: tester' 'http://localhost/api/action/resource_create' \
--form url=http://www.norman-network.com/sites/default/files/files/suspectListExchange/Targ_Sus_NT-wID_GC_final.csv \
--form package_id=norman_collaborative_trial_targets_and_suspects \
--form name="GC Targets and suspects" > /dev/null

echo "Installing lftp and realpath"
sudo apt-get install -qq -y lftp

#sudo bash /vagrant/vagrant/metabolights.sh