
项目背景：
    最近工作用到solr做搜索，觉得挺有趣，自己创建一套引擎，也方便研究。
    看网上基本都是手动配置的，拷贝jar包，没有maven集成的，有集成solr版本也很老。
    所以先自己与maven 集成了一下。
    之后 可能会有一些 定制化的功能添加到这个项目中。如自定义分词器，自定义评分等。
    
solr使用：
    本项目只是引擎，关于solr的使用，我放在另一个项目中，
    另一个项目主要用来 使用solr，和一些 自定义的solrUtils，拼音，
    业务场景下的solr 条件拼接，搜索，文章feed，suggest等多中功能的具体实现和说明
    附带，测试数据。


一，前期配置

1.下载tomcat 8，在bin中添加 工程中的setenv.sh ，自定义 tomcat的启动参数

    export SOLR_HOME="$CATALINA_HOME/webapps/lsearch/WEB-INF/solr_home"
    export SOLR_LOG="$CATALINA_HOME/logs/"
    export TOMCAT_USER="tomcat"
    export JAVA_OPTS="$JAVA_OPTS -Dsolr.solr.home=$SOLR_HOME -Dsolr.solr.log.dir=$SOLR_LOG -Dbootstrap_conf=true -DhostContext=lsearch"

配置solr.home 和solr.log，这样就不需要在web.xml中写死了。

solr_home 中的 索引路径 （core.properties中的data地址，不写默认当前路径， 写了 记得要建索引文件夹）


2.修改classes中的log4j.properties 中的solr.log ，这样在tomcat 启动参数 就可以设置solr log了

    solr.log=${catalina.base}/logs

3.与单机版solr不同，不需要在web.xml中打开 env标签配置 solr home，在tomcat的启动参数中设置solr home就可以

4.集成了 ik分词器，将ik的jar包 放在了WEB-INF的lib中，lib同级配置了ik的配置文件

5.solr的jar包 在maven的pom中进行了配置。不需要像单机中的copy jar包。




二，使用说明

1.mvn clean install 打包，打成的war包 放到tomcat的webapps下 ，增加setenv.sh 文件，执行bin下的脚本。 

（1）tomcat 的端口修改 conf/server.xml 为 端口号 如8081

    ./startup.sh
    http://localhost:8081/lsearch/index.html

2.idea配置tomcat，deployment 中deploy Artifact war 包，启动tomcat后 访问 url可以直接访问。

http://localhost:8081/lsearch/index.html



三，测试数据


