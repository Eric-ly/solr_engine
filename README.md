
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

6.如果 单独copy war 到tomcat webapp下，



二，使用说明

1.mvn clean install 打包，打成的war包 放到tomcat的webapps下 ， 在bin下 增加setenv.sh 文件，执行bin下的startup.sh脚本。 

（1）tomcat 的端口修改 conf/server.xml 为 端口号 如8081

    ./startup.sh
    http://localhost:8081/lsearch/index.html

2.idea配置tomcat，deployment 中deploy Artifact war 包，启动tomcat后 访问 url可以直接访问。


http://localhost:8081/lsearch/index.html


三，功能
1.定制化 评分 ， 屏蔽了solr 默认的DefaultSimilarity 算分的方法，采用自定义的，方便控制
solr的默认评分机制，会考虑 很多因素 如 关键字在 字段中 出现的次数邓，生成的评分 小数很多， 
屏蔽后 根据自定义权重评分，如 title中搜索滑雪 命中了加10分，结果都是10分不会出现小数便于控制
自定义SimilarityFactory 并在schema 中配置 similarity 

三，测试数据
本项目下 测试数据 demo_engine 文件，将
使用post 请求：http://localhost:8080/lsearch/demo_engine/update/json?commit=true
        headers     Content-Type:application/json
        body 中上传该 文件，就可以o       s
可以使用chronme的工具 postman，body选binary 上传测试数据文件。
示例 url:http://localhost:8080/lsearch/demo_engine/select?fl=score,search_title,id&q=search_title:(滑雪)^10