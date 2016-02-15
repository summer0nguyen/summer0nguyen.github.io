---
author: Summer Nguyen
layout: post
title: "Puppet Automation Series - Part 3 - Installation"
date: 2016-02-04 12:00
comments: true
category: puppet
tags:
- puppet
- automation
---


In this LAB, I have 2 servers hosted in my own laptop's VirtualBox :

+ puppet-master.summernguyen.net : 192.168.56.101
+ puppet-agent.summernguyen.net  : 192.168.56.102

OS: CentOS 6.6 x64

But in real life, I place puppet-master on my own laptop (using Ubuntu) and puppet-agent on VirtualBox. It's very easy for me to *code* on my machine and test by appling to the testing server.

**Step 1 : Set Hostname of the servers**

It's an easy task, everyone can do it :)

Make sure puppet-agent can *ping* **puppet-master.summernguyen.net** by hostname.
You can do it using */etc/hosts* file or your own DNS Server. 

**Step 2 : Enable the Puppet Labs Package Repository on both nodes**

The newest versions of Puppet can be installed from the <a href="https://yum.puppetlabs.com">yum.puppetlabs.com</a> package repository.

Enterprise Linux 7
{% highlight bash %}
$ sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
{% endhighlight %}
Enterprise Linux 6
{% highlight bash %}
$ sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
{% endhighlight %}
Enterprise Linux 5
{% highlight bash %}
$ sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-5.noarch.rpm
{% endhighlight %}


**Step 3 : install the puppet master on puppet-master.summernguyen.net (you will do this task only once )**

Run the command : 

{% highlight bash %}
[root@puppet-master ~]# yum install puppetserver -y 
{% endhighlight %}

It will install puppet master and all it's dependencies . 


*Configuring the Master with config file /etc/puppet/puppet.conf*

{% highlight conf %}
[main]
    # The Puppet log directory.
    # The default value is '$vardir/log'.
    logdir = /var/log/puppet

    # Where Puppet PID files are kept.
    # The default value is '$vardir/run'.
    rundir = /var/run/puppet

    # Where SSL certificates are kept.
    # The default value is '$confdir/ssl'.
    ssldir = $vardir/ssl

    ####### DNS Name , Change your own Name
    dns_alt_names = puppet-master,puppet-master.summernguyen.net

    ##Enable Auto Sign Agent SSL Certificate ###
    autosign = false


[agent]
    # The file in which puppetd stores a list of the classes
    # associated with the retrieved configuratiion.  Can be loaded in
    # the separate ``puppet`` executable using the ``--loadclasses``
    # option.
    # The default value is '$confdir/classes.txt'.
    classfile = $vardir/classes.txt

    # Where puppetd caches the local configuration.  An
    # extension indicating the cache format is added automatically.
    # The default value is '$confdir/localconfig'.
    localconfig = $vardir/localconfig



{% endhighlight %}

*Start & enable the puppet master service*


{% highlight bash %}
[root@puppet-master ~]# service puppetserver start
[root@puppet-master ~]# chkconfig puppetserver on
{% endhighlight %}

*Note: The puppet master must has more than 2199MB of RAM or you will get the message: Exception in thread "main" java.lang.Error: Not enough RAM. Puppet Server requires at least 2199MB of RAM.*

If you are in testing environment and your server doesn't have enough RAM, start it in no-daemonize mode

{% highlight bash %}
[root@puppet-master ~]# puppet master --verbose --no-daemonize
{% endhighlight %}


In Production Server, please follow the instruction to <a href="https://docs.puppetlabs.com/guides/passenger.html">Install Puppet master for production environment</a>.

In the first time running puppet master, the master will generate itself a certificate .

Puppet Master will be started on Port **TCP 8140**. Please ensure that this server is reachable by this port. 

**Step 4 : install the puppet agent on puppet-agent.summernguyen.net (you will do this task anytime you have a new server )**


Run the command : 

{% highlight bash %}
yum install puppet -y 
{% endhighlight %}


It will install puppet agent and all it's dependencies . 

*Configuring the Agent with config file /etc/puppet/puppet.conf*
{% highlight conf %}
[main]
    # The Puppet log directory.
    # The default value is '$vardir/log'.
    logdir = /var/log/puppet

    # Where Puppet PID files are kept.
    # The default value is '$vardir/run'.
    rundir = /var/run/puppet

    # Where SSL certificates are kept.
    # The default value is '$confdir/ssl'.
    ssldir = $vardir/ssl

    ## Point to the puppet-master host ###
    server = puppet-master.summernguyen.net

    ## SSL Certificate Hostname ###
    certname = puppet-agent.summernguyen.net


[agent]
    # The file in which puppetd stores a list of the classes
    # associated with the retrieved configuratiion.  Can be loaded in
    # the separate ``puppet`` executable using the ``--loadclasses``
    # option.
    # The default value is '$confdir/classes.txt'.
    classfile = $vardir/classes.txt

    # Where puppetd caches the local configuration.  An
    # extension indicating the cache format is added automatically.
    # The default value is '$confdir/localconfig'.
    localconfig = $vardir/localconfig
{% endhighlight %}


There are two modes when running Puppet agent : 

* Daemon : it will periodically fetch configuration from Puppet Master if we start the puppet agent service **service puppet start**
* Command : It will fetch configuration from Puppet Master whenever we run command **puppet agent -t** 

Like Puppet master, at the first time running, Puppet agent will generate a SSL certificate as it's identifier. 

If Puppet master enable *autosign* , the puppet master will accept the agent's certificate. 

If Puppet master disable *autosign*, we have to manual accept the agent's certificate by issue the command on **Puppet Master**: 

{% highlight base %}
puppet cert list  ## This will list all unaccept requested SSL certificate.
puppet cert sign puppet-agent.summernguyen.net ## This will accept the certifiate 
{% endhighlight %}



That's how to setup for Puppet Agent to connect to Puppet Master . 

---
**Previous Topic** :<a href="/puppet/2016/02/04/puppet-automation-series-part-2-architecture/">PUPPET AUTOMATION SERIES - PART 2 - ARCHITECTURE</a>

**Next Topic** : <a href="/puppet/2016/02/15/puppet-automation-series-part-4-beginners-configuration-guide/">PUPPET AUTOMATION SERIES - PART 4 - BEGINNERS CONFIGURATION GUIDE</a>