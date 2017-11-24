for ((i=1;i<=$#;i++))
do
    eval str=\${$i}
    case $str in
        -Tconfig)
            type="config"
            ;;
        -Tclass)
            type="class"
            ;;
        -Tall)
            type="all"
            ;;
        *)
            exit 1
            ;;
    esac
done




hosts=($(cat .dev))
if [ -z "$hosts" ];then
    echo '请在.dev里配置部署机器'
fi

if [ "config" == "$type" ];then
	for host in "${hosts[@]}";do
        echo "rsyncing to $host ....."
        rsync -rl  --rsync-path="sudo rsync" src/main/solr_home/ ${host}:/home/q/www/dapp_engine/webapps/qsearch/WEB-INF/solr_home/;
		echo "resarting server...."
        ssh $host "sudo /home/q/tools/bin/restart_tomcat.sh dapp_engine"
        echo "已部署在 "$host
    done
elif [ "all" == "$type" ];then
    mvn clean package -Dmaven.test.skip=true -DcheckDeployRelease_skip=true -Denforcer.skip=false -DskipTests enforcer:enforce
	for host in "${hosts[@]}";do
		echo "rsyncing to $host ....."
		rsync -rl --delete --rsync-path="sudo rsync" target/classes/ ${host}:/home/q/www/dapp_engine/webapps/qsearch/WEB-INF/classes/;
		rsync -rl --delete  --rsync-path="sudo rsync" target/dapp_engine/WEB-INF/lib/ ${host}:/home/q/www/dapp_engine/webapps/qsearch/WEB-INF/lib/;
		rsync -rl --delete  --rsync-path="sudo rsync" target/dapp_engine/WEB-INF/web.xml ${host}:/home/q/www/dapp_engine/webapps/qsearch/WEB-INF/web.xml;
        rsync -rl  --rsync-path="sudo rsync" src/main/solr_home/ ${host}:/home/q/www/dapp_engine/webapps/qsearch/WEB-INF/solr_home/;
		echo "resarting server...."
		ssh $host "sudo /home/q/tools/bin/restart_tomcat.sh dapp_engine"
		echo "已部署在 "$host
	done
else
    mvn clean compile -Dmaven.test.skip=true -DcheckDeployRelease_skip=true -Denforcer.skip=false -DskipTests enforcer:enforce
	for host in "${hosts[@]}";do
		echo "rsyncing to $host ....."
		rsync -rl  --delete --rsync-path="sudo rsync" target/classes/ ${host}:/home/q/www/dapp_engine/webapps/qsearch/WEB-INF/classes/;
        rsync -rl  --rsync-path="sudo rsync" src/main/solr_home/ ${host}:/home/q/www/dapp_engine/webapps/qsearch/WEB-INF/solr_home/;
		echo "resarting server...."
		ssh $host "sudo /home/q/tomcat/app_engine/bin/shutdown.sh"
		ssh $host "sudo /home/q/tomcat/app_engine/bin/startup.sh"
		echo "已部署在 "$host
	done
fi



