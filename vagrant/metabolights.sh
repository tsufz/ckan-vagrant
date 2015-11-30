#!/bin/bash

cd /home/vagrant

echo "Retrieving metabolights data"
lftp -c mirror --no-empty-dirs --include="/[iasm]_.*\.[tc][xs][tv]$" ftp://ftp.ebi.ac.uk/pub/databases/metabolights/studies/public/

echo "Adding metabolights maf files to CKAN"

cd public
for DIRECTORY in $(ls); do
	cd $DIRECTORY
	if ls | grep -q "m\_.*maf.*tsv";
		then
			DESC=$(grep "Study Description" i* | cut -d "\"" -f 2)
			TITLE=$(grep "Study Title" i* | cut -d "\"" -f 2)
			curl -s -H'Authorization: tester' 'http://localhost/api/action/package_create' \
				--form name=${DIRECTORY,,} \
				--form title="$TITLE" \
				--form notes="$DESC" > /dev/null
			
			# Now upload the maf files to the created package
			for MAFFILE in *.tsv; do
				curl -s -H'Authorization: tester' 'http://localhost/api/action/resource_create' \
					--form package_id=${DIRECTORY,,} \
					--form name="$MAFFILE" \
					--form url="ftp://ftp.ebi.ac.uk/pub/databases/metabolights/studies/public/$DIRECTORY/$MAFFILE" > /dev/null
			done
			
	fi
	cd ..
done