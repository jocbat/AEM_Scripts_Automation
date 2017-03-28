#!/bin/bash

curl -u admin:admin http://localhost:4702/crx/packmgr/service.jsp?cmd=ls > installed_packages.xml


file="shell_commands_to_delete_espace-client_packages.sh"
if [ -f $file ] ; then
    rm $file
fi

uninstalledPackageCommand=""
deletePackageCommand=""
grep -A 12 '<package>' installed_packages.xml | while read -r line ; do
	
	group=${line%</group>};
	group=${group#<group>};
	if [ "$group" != "$line" ]; then	
		uninstalledPackageCommand="http://localhost:4702/crx/packmgr/service/.json/etc/packages/$group"
		deletePackageCommand="http://localhost:4702/crx/packmgr/service/.json/etc/packages/$group"
	fi
	
	downloadName=${line%</downloadName>};
	downloadName=${downloadName#<downloadName>};
	
	if [ "$downloadName" != "$line" ]; then
		uninstalledPackageCommand="curl -u admin:admin -X POST $uninstalledPackageCommand/$downloadName?cmd=uninstall"
		echo "$uninstalledPackageCommand" >> packages_on_server.sh
		
		deletePackageCommand="curl -u admin:admin -X POST $deletePackageCommand/$downloadName?cmd=delete"
		echo "$deletePackageCommand" >> packages_on_server.sh
		
		uninstalledPackageCommand=""
		deletePackageCommand=""
	fi
done

grep espace-client packages_on_server.sh >> shell_commands_to_delete_espace-client_packages.sh
grep maw packages_on_server.sh >> shell_commands_to_delete_espace-client_packages.sh
grep axa-socle-identity-apps packages_on_server.sh >> shell_commands_to_delete_espace-client_packages.sh
rm packages_on_server.sh
rm installed_packages.xml

./shell_commands_to_delete_espace-client_packages.sh
rm shell_commands_to_delete_espace-client_packages.sh