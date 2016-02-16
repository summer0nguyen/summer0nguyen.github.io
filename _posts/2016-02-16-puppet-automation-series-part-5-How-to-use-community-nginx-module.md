---
author: Summer Nguyen
layout: post
title: "Puppet Automation Series - Part 5 - How to use community Module : Nginx"
date: 2016-02-16 12:00
comments: true
category: puppet
tags:
- puppet
- automation
---

After 4 posts about Puppet, I think you should know how Puppet works and how we configure a basic server with directory creation, package installation, ... But there are many complicated tasks waiting for you in the System Admin life :). 

As you know, there are many System Admins like us in the world and they are very great by creating and sharing puppet modules for the community. 

You can find more many modules in <a href="https://forge.puppetlabs.com/" target="tab">Puppet Forge - Repository of Modules </a>. At the time I write this post, there are 3,963 modules in many fields and sections created and shared by the community. 

In this Post, I will instruct you how to use module <a href="https://forge.puppetlabs.com/jfryman/nginx">NGINX</a> to configure a Web Server with multiple Virtual Hosts (Server Blocks) hosting static content .


---
***TIPS***

In <a href="https://forge.puppetlabs.com/">Puppet Forge</a>, put your query search in the Search form, there may be many modules in the result set. 

<img src="/images/puppet-series/puppet-forge-search-form.png" alt="Puppet Forge Search Form">

I follow the below rules to find best module for me : (step by step )

1. Review the module with the icon <img src="/images/puppet-series/puppet-forge-supported-icon.png" alt="Supported"> which means well-tested with Puppet. 
2. Review the module with the icon <img src="/images/puppet-series/puppet-forge-approved-icon.png" alt="Approved"> which means well-written and actively maintained. 
3. Review the module with highest rating point.
4. Review the module with highest downloaded time.
5. Review all modules in the result set to find the best module for you . 

*Note : Please answer the survey for the module to help the arthors to improve their module and the community to find the right module.*

---

Okay, let's start with our basic tasks : 

1. Create directories : 
	+ */var/www/html/web1* owned by user *web1* with mode: *755*
	+ */var/www/html/web2* owned by user *web2* with mode: *755*
	+ */var/www/html/web3* owned by user *web3* with mode: *755*
2. Create files : 
	+ */var/www/html/web1/index.html* owned by user *web1* with mode: *755* and content  : **"WEB 1 Index"**
	+ */var/www/html/web2/index.html* owned by user *web2* with mode: *755* and content  : **"WEB 2 Index"**
	+ */var/www/html/web3/index.html* owned by user *web3* with mode: *755* and content  : **"WEB 3 Index"**
3. Configure Nginx Virtual Hosts ( Server Blocks )
	+ *web1.summernguyen.net* with document root */var/www/html/web1*
	+ *web2.summernguyen.net* with document root */var/www/html/web2*
	+ *web3.summernguyen.net* with document root */var/www/html/web3*

Let's have a look at the tasks and analyze : what is the order of theses tasks ? What task shoud be executed first ? what's next ? what's end ? (See <a href="/puppet/2016/02/15/puppet-automation-series-part-4-beginners-configuration-guide/#puppet_relationship_and_ordering" target="tab">Relationships and Ordering</a>)


Here is a order of tasks I recommend : 

1. Ensure User *web1 , web2 , web3* is present.
2. Ensure directory */var/www/html* is present (you know, with mode : 755 ) .
3. Ensure directories */var/www/html/web1 , /var/www/html/web2 , /var/www/html/web3* is present with righ owner. **This requires both task 1 and 2 completed before executing.**
4. Install Nginx 
5. Configure 3 Nginx Virtual Hosts . **This requires all of the above tasks completed  before executing.**


**Because we are using module <a href="https://forge.puppetlabs.com/jfryman/nginx">NGINX</a>, so we will complete task 4 and 5 by using this module**

---

***Let's start***


**1. on *Puppet Master* - Install Module <a href="https://forge.puppetlabs.com/jfryman/nginx">NGINX</a>**

{% highlight bash %}
[root@puppet-master ~]# puppet module install jfryman-nginx
Notice: Preparing to install into /etc/puppet/modules ...
Notice: Downloading from https://forgeapi.puppetlabs.com ...
Notice: Installing -- do not interrupt ...
/etc/puppet/modules
└─┬ jfryman-nginx (v0.3.0)
  ├─┬ puppetlabs-apt (v2.2.1)
  │ └── puppetlabs-stdlib (v4.11.0)
  └── puppetlabs-concat (v2.1.0)
[root@puppet-master ~]# 
{% endhighlight %}

Puppet will install Nginx Module and it's dependent modules to */etc/puppet/modules*

Before writing manifest, please have a look at the module instruction written by the author <a href="https://forge.puppetlabs.com/jfryman/nginx" target="tab">HERE</a>

**2. on *Puppet Master*, Write *manifest* for the Server *puppet-agent.summernguyen.net by creating /etc/puppet/manifests/sites.pp***

{% highlight erb %}
node 'puppet-agent.summernguyen.net' {

	#Create User : web1, web2, web3
	#See https://docs.puppetlabs.com/puppet/latest/reference/type.html#user for information
	user{"web1":
		ensure	=>	"present"
	}
	user{"web2":
		ensure	=>	"present"
	}
	user{"web3":
		ensure	=>	"present"
	}

	#Create directory : /var/www/html
	#See https://docs.puppetlabs.com/puppet/latest/reference/type.html#file for information
	file{"/var/www/html":
		ensure	=>	"directory",
		owner	=>	"root",
		mode	=>	"755"
	}

	#Create Document Root Directory with dependencies : User and directory /var/www/html
	#must  be created before. 
	file{"/var/www/html/web1":
		ensure	=>	"directory",
		owner	=>	"web1",
		mode	=>	"755",
		require	=>	[File["/var/www/html"],User["web1"]]
	}		
	file{"/var/www/html/web2":
		ensure	=>	"directory",
		owner	=>	"web2",
		mode	=>	"755",
		require	=>	[File["/var/www/html"],User["web2"]]
	}		
	file{"/var/www/html/web3":
		ensure	=>	"directory",
		owner	=>	"web3",
		mode	=>	"755",
		require	=>	[File["/var/www/html"],User["web3"]]
	}

	#Create Index File with the parent directiry required
	
	file{"/var/www/html/web1/index.html":
		ensure	=>	"present",
		owner	=>	"web1",
		mode	=>	"755",
		content	=>	"WEB 1 Index",
		require	=>	File["/var/www/html/web1"] 
	## this also require User web1 and directory /var/www/html 
	#existed before executing
	}		
	file{"/var/www/html/web2/index.html":
		ensure	=>	"present",
		owner	=>	"web2",
		mode	=>	"755",
		content	=>	"WEB 2 Index",
		require	=>	File["/var/www/html/web2"]
	}		
	file{"/var/www/html/web3/index.html":
		ensure	=>	"present",
		owner	=>	"web3",
		mode	=>	"755",
		content	=>	"WEB 3 Index",
		require	=>	File["/var/www/html/web3"]
	}		
	
	######################Configure Nginx by Community Module#####################	
	
	#Install Nginx and some basic tweaks 
	class { 'nginx': 
	
	}

	#Install Virtual Hosts 
	nginx::resource::vhost { 'web1.summernguyen.net':
		www_root	=>	'/var/www/html/web1',
		require		=>	File["/var/www/html/web1"]
	}

	## Copy and Paste 
	nginx::resource::vhost { 'web2.summernguyen.net':
		www_root	=>	'/var/www/html/web2',
		require		=>	File["/var/www/html/web2"]
	}
	nginx::resource::vhost { 'web3.summernguyen.net':
		www_root	=>	'/var/www/html/web2',
		require		=>	File["/var/www/html/web3"]
	}
}
{% endhighlight %}


**3. on *Puppet Agent* - Apply the manifest**

Run the command : 
{% highlight bash %}
puppet agent -t 
{% endhighlight %}

Well, you can check if it works by yourself. 



---
***Real Life Scenario***

Imagine that you have a cluster consist of 10 Servers with this simple configuration. 

If you do all the Server by **Bash shell**, I think it takes you about more than 1 hour. 

But, it takes me only 5 minutes to write the *manifest*  and 1 hour to write this whole post. Adding new Server is just copying and pasting. 

---

There are many modules fit your need, find it by yourself or write a module and share to the community. 

Hope you will love this post.

---

**Previous Topic** : <a href="/puppet/2016/02/15/puppet-automation-series-part-4-beginners-configuration-guide/">PUPPET AUTOMATION SERIES - PART 4 - BEGINNERS CONFIGURATION GUIDE</a>