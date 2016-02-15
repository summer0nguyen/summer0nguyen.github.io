---
author: Summer Nguyen
layout: post
title: "Puppet Automation Series - Part 4 - Beginners Configuration Guide"
date: 2016-02-15 12:00
comments: true
category: puppet
tags:
- puppet
- automation
---

After understanding how Puppet works, let's see what puppet can do with some simple lines of code .

First of all, we use Puppet to configure servers by **code** , and there must be a directory skeleton usually in **/etc/puppet/** as below  : 

+ puppet.conf : Puppet application configuration file 
+ manifests   : **a directory**, store Puppet language files, store configuration of servers/ agents in *code*
+ modules	  : **a directory**, store modules - self-contained bundles of code and data.



***1. Basic definitions and rules***


**Resource**

Resources are the fundamental unit for modeling system configurations. Each resource describes some aspect of a system, like a specific service or package.

A resource declaration is an expression that describes the desired state for a resource and tells Puppet to add it to the catalog. When Puppet applies that catalog to a target system, it manages every resource it contains, ensuring that the actual state matches the desired state.

Here is how we define a resource : 
{% highlight erb %}

<TYPE> { '<TITLE>':
  <ATTRIBUTE> => <VALUE>,
}
{% endhighlight %}

The form of a resource declaration is:

+ The **resource type**, which is a word with no quotes.
+ An opening curly brace (**{**).
+ The **title**, which is a *string*.
+ A colon (**:**).
+ Optionally, any number of **attribute and value pairs**, each of which consists of:
	+ An **attribute name**, which is a lowercase word with no quotes.
	+ A **=>** (called an arrow, “fat comma,” or “hash rocket”).
	+ A value, which can have any data type.
	+ A trailing comma.
+ A closing curly brace (}).



example  : 
{% highlight erb %}
package {"httpd":
	ensure	=>	"present"
}


file { '/tmp/testfile':
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0600',
}
{% endhighlight %}


*Keep in mind that the combination* {% highlight erb %} <TYPE> and <TITLE> {% endhighlight %} *is unique on a Node*


**Resource Types**

Every resource is associated with a resource type, which determines the kind of configuration it manages.

Puppet has many built-in resource types, like files, cron jobs, services, etc. See the <a href="https://docs.puppetlabs.com/puppet/latest/reference/type.html">resource type reference</a>  for information about the built-in resource types.


 You can create your own resource type which I will instruct you in another post.


**Catalog**

We use **Puppet language** by writing multiple *resource* definitions. 
And Puppet master will compile our code to catalog and send it to the nodes. That's simple. 



**Relationships and Ordering**

By default, Puppet applies resources in the order they’re declared in their manifest. However, if a group of resources must always be managed in a specific order, you should explicitly declare such relationships with relationship metaparameters, chaining arrows, and the require function.

Example : 

+ Starting service httpd require package httpd installed before. 
+ Create a directory *bar* owned by user *foo* require User *foo* existed . 



***2. Create first Manifest file for a node***

Now we have a task setting up 1 server in CentOS 6, with : 

+ Create User *foo*
+ Create directory */tmp/bar* owned by user *foo*
+ Install package *httpd*
+ Start service *httpd* 

*On Puppet Master, create file */etc/puppet/manifests/sites.pp*

{% highlight erb %}

node 'puppet-agent.summernguyen.net' {

	user{'foo':
		ensure	=>	"present"
	}

	file{"/tmp/bar":
		ensure	=>	"directory",
		require	=>	User["foo"]

	}

	package{"httpd":
		ensure	=>	"present"
	}

	service{"httpd":
		ensure	=>	"running",
		require	=>	Package["httpd"]
	}
	
}


{% endhighlight %}


*On Puppet Agent, run command*
{% highlight bash %}
[root@puppet-agent ~]# puppet agent -t 
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Caching catalog for puppet-agent.summernguyen.net
Info: Applying configuration version '1455522532'
Notice: /Stage[main]/Main/Node[puppet-agent.summernguyen.net]/User[foo]/ensure: created
Notice: /Stage[main]/Main/Node[puppet-agent.summernguyen.net]/File[/tmp/bar]/ensure: created
Notice: /Stage[main]/Main/Node[puppet-agent.summernguyen.net]/Package[httpd]/ensure: created
Notice: /Stage[main]/Main/Node[puppet-agent.summernguyen.net]/Service[httpd]/ensure: ensure changed 'stopped' to 'running'
Info: /Stage[main]/Main/Node[puppet-agent.summernguyen.net]/Service[httpd]: Unscheduling refresh on Service[httpd]
Notice: Finished catalog run in 142.77 seconds
[root@puppet-agent ~]# 

{% endhighlight %}


Next time, when we run this command again, Puppet will detect that everying existed, nothing will executed : 

{% highlight bash %}

[root@puppet-agent ~]# puppet agent -t 
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Caching catalog for puppet-agent.summernguyen.net
Info: Applying configuration version '1455522532'
Notice: Finished catalog run in 0.40 seconds
[root@puppet-agent ~]# 



{% endhighlight %}


***3. Further research***

*Basic Research*

There are 2 locations I recommend you to research : 

+ <a href="http://www.puppetcookbook.com/" target="tab">Puppet Cookbook</a>
+ <a href="https://docs.puppetlabs.com/puppet/latest/reference/type.html" target="tab">Puppet official Resource Type</a>



***4. Puppet modules***

Installing a Server is not just simple as creating a new user, creating a directory, installing a package, starting a services, ... It's more complicated than that. 
We have to configure many configuration files with dirrent parameters, ... repeatly in time by time in many servers . 

We write *code* line by line on each node definition ? Ofcourse not, we can create a *module* to reuse our code in many servers with just simple lines of codes. 


There are many modules have been published by the community. We can use them if they are fit our needs.

You can search what you want in <a href="https://forge.puppetlabs.com/" target="tab">Puppet Forge</a>




That's how I start at the beginning time. You can do it this way. 

Hope you will love it. 

---

**Previous Topic** : <a href="/puppet/2016/02/04/puppet-automation-series-part-3-installation/">PUPPET AUTOMATION SERIES - PART 3 - INSTALLATION</a>