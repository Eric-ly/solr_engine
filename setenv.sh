#!/bin/sh

export SOLR_HOME="$CATALINA_HOME/webapps/lsearch/WEB-INF/solr_home"
export SOLR_LOG="$CATALINA_HOME/logs/"
export TOMCAT_USER="tomcat"
export JAVA_OPTS="$JAVA_OPTS -Dsolr.solr.home=$SOLR_HOME -Dsolr.solr.log.dir=$SOLR_LOG -Dbootstrap_conf=true -DhostContext=lsearch"
