---
author: Summer Nguyen
layout: post
title: "Puppet Automation Series - Part 6 - Trouble Shooting"
date: 2016-02-29 12:00
comments: true
category: puppet
tags:
- puppet
- automation
---


Until now, I think that you can use Puppet for your own projects. But, like codding, you will have mistakes while deploy to servers.  I will list some of errors I sometimes get. 


---

**Agenda**

<a href="#puppet_agent_can_not_connect_puppet_master">1. Puppet Agent Can not connect to Puppet Master</a>

<a href="#node_undefied">2. Node undefined</a>

<a href="#syntax_error">3. Syntax Error</a>

<a href="#invalid_resource_type">4. Invalid resource type</a>

<a href="#could_not_find_dependency">5. Could not find dependency</a>

---



**<a name="puppet_agent_can_not_connect_puppet_master" href="#puppet_agent_can_not_connect_puppet_master">1. Puppet Agent Can not connect to Puppet Master</a>**

Error message : 
{% highlight erb %}
Warning: Unable to fetch my node definition, but the agent run will continue:
Warning: No route to host - connect(2)
Info: Retrieving pluginfacts
Error: /File[/var/lib/puppet/facts.d]: Failed to generate additional resources using 'eval_generate': No route to host - connect(2)
Error: /File[/var/lib/puppet/facts.d]: Could not evaluate: Could not retrieve file metadata for puppet://puppet-master.summernguyen.net/pluginfacts: No route to host - connect(2)
Info: Retrieving plugin
Error: /File[/var/lib/puppet/lib]: Failed to generate additional resources using 'eval_generate': No route to host - connect(2)
Error: /File[/var/lib/puppet/lib]: Could not evaluate: Could not retrieve file metadata for puppet://puppet-master.summernguyen.net/plugins: No route to host - connect(2)
Error: Could not retrieve catalog from remote server: No route to host - connect(2)
Warning: Not using cache on failed catalog
Error: Could not retrieve catalog; skipping run
Error: Could not send report: No route to host - connect(2)

{% endhighlight %}

Fix : 

- Ensure that Server / Services Puppet master is running. 
- Ensure that Puppet agent can connect to Puppet master using port 8140.

{% highlight bash %}
telnet puppet-master.summernguyen.net 8140
{% endhighlight %}


**<a name="node_undefied" href="#node_undefied">2. Node undefined</a>**

Error message : 
{% highlight erb %}

[root@puppet-agent ~]# puppet agent -t 
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Loading facts
Error: Could not retrieve catalog from remote server: Error 400 on SERVER: Could not find default node or by name with 'puppet-agent.summernguyen.net, puppet-agent.summernguyen, puppet-agent, puppet-agent.local.ttvonline.info, puppet-agent.local.ttvonline, puppet-agent.local' on node puppet-agent.summernguyen.net
Warning: Not using cache on failed catalog
Error: Could not retrieve catalog; skipping run

{% endhighlight %}


Reason : 

- You didn't defined the Node using the *node* keyword.
- Puppet master somehow doesn't regconize your *code*.

Fix: 

- Restart Puppet Master Service
- *code* your manifest using the keyword *node*

{% highlight erb %}

node 'puppet-agent.summernguyen.net' {


}
{% endhighlight %}



**<a name="syntax_error" href="#syntax_error">3. Syntax Error</a>**

Error message : 
{% highlight erb %}

[root@puppet-agent ~]# puppet agent -t 
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Loading facts
Error: Could not retrieve catalog from remote server: Error 400 on SERVER: Could not parse for environment production: Syntax error at 'present'; expected '}' at /etc/puppet/manifests/site.pp:6 on node puppet-agent.summernguyen.net
Warning: Not using cache on failed catalog
Error: Could not retrieve catalog; skipping run


{% endhighlight %}

Reason : Syntax error at line */etc/puppet/manifests/site.pp:6*

Fix : step by step  

- Check the brackets ( **'  ,  ", [** ) if there missing the closing brackets. 
- Check the current block of *code* only 


**<a name="invalid_resource_type" href="#invalid_resource_type">4. Invalid resource type</a>**

Error message : 
{% highlight erb %}
[root@puppet-agent ~]# puppet agent -t 
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Loading facts
Error: Could not retrieve catalog from remote server: Error 400 on SERVER: Puppet::Parser::AST::Resource failed with error ArgumentError: Invalid resource type user1 at /etc/puppet/manifests/site.pp:7 on node puppet-agent.summernguyen.net
Warning: Not using cache on failed catalog
Error: Could not retrieve catalog; skipping run

{% endhighlight %}

Reason : Undefined resource type **user1** at */etc/puppet/manifests/site.pp:7*

Fix : 

- Maybe you are mistyping at */etc/puppet/manifests/site.pp:7*, fix it. 
- Maybe you are calling a resource type from uninstalled module, Just check and install this module. 
- Maybe Puppet Master doesn't regconize your new code, restart puppet master service. 


**<a name="could_not_find_dependency" href="#could_not_find_dependency">5. Could not find dependency</a>**

Error message : 
{% highlight erb %}

Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Loading facts
Info: Caching catalog for puppet-agent.summernguyen.net
Error: Failed to apply catalog: Could not find dependency File[/var/www/html] for File[/var/www/html/web2] at /etc/puppet/manifests/site.pp:35


{% endhighlight %}

Reasons : Catalog ***File[/var/www/html]*** which is required by **File[/var/www/html/web2]** is not defined. 

Fix : 

- Check for the declaration of this resource. 
- If it is not neccessary, remove the **require** parameter. 

---

***TIPS***

While debugging Puppet Manifest, keep in mind that Puppet throw the exception very clearly about the Location of the error , follow it. 

Puppet Master sometimes doesn't regconize your latest code, restarting Puppet master services may help. 


---

**Previous Topic** : <a href="/puppet/2016/02/16/puppet-automation-series-part-5-How-to-use-community-nginx-module/">PUPPET AUTOMATION SERIES - PART 5 - HOW TO USE COMMUNITY MODULE : NGINX</a>