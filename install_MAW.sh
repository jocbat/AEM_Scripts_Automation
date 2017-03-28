#!/bin/bash
./uninstall_maw_packages_on_local.sh

cd "D:\workspace\AXA\MAW\espace-client-back"
git co develop
mvn clean install -Dmaven.test.skip=true -P nexus,auto-install-package,maw_author_deploy


cd "D:\workspace\AXA\MAW\espace-client-back-config"
git co develop
mvn clean install -Dmaven.test.skip=true -P nexus,dev

ls target | grep zip | while read -r line ; do
	curl -u admin:admin -F file=@"D:\workspace\AXA\MAW\espace-client-back-config\target\\$line" -F name="espace-client-back-ui" -F force=true -F install=true http://localhost:4702/crx/packmgr/service.jsp
	break
done

cd "D:\workspace\AXA\MAW\espace-client-front"
git co develop
mvn clean install -Dmaven.test.skip=true -P nexus,auto-install-package,maw_author_deploy

cd "D:\workspace\AXA\MAW\axa-socle-identity"
git co develop
mvn clean install -Dmaven.test.skip=true -P nexus,auto-install-package,maw_author_deploy

read

