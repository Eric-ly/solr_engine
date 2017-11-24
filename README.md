一，前期配置

1.下载tomcat 8，在bin中添加 工程中的setenv.sh ，自定义 tomcat的启动参数

    export SOLR_HOME="$CATALINA_HOME/webapps/lsearch/WEB-INF/solr_home"
    export SOLR_LOG="$CATALINA_HOME/logs/"
    export TOMCAT_USER="tomcat"
    export JAVA_OPTS="$JAVA_OPTS -Dsolr.solr.home=$SOLR_HOME -Dsolr.solr.log.dir=$SOLR_LOG -Dbootstrap_conf=true -DhostContext=lsearch"

配置solr.home 和solr.log，这样就不需要在web.xml中写死了。



2.修改classes中的log4j.properties 中的solr.log ，这样在tomcat 启动参数 就可以设置solr log了

    solr.log=${catalina.base}/logs

3.与单机版solr不同，不需要在web.xml中打开 env标签配置 solr home，在tomcat的启动参数中设置solr home就可以

4.集成了 ik分词器，将ik的jar包 放在了WEB-INF的lib中，lib同级配置了ik的配置文件

5.solr的jar包 在maven的pom中进行了配置。不需要像单机中的copy jar包。



二，使用说明

1.mvn clean install 打包，打成的war包 放到tomcat的webapps下 ，增加setenv.sh 文件，执行bin下的脚本。 

    ./startup.sh
    http://localhost:8081/lsearch/index.html

2.idea配置tomcat，deployment 中deploy Artifact war 包，启动tomcat后 访问 url可以直接访问。

http://localhost:8081/lsearch/index.html



三，测试数据


