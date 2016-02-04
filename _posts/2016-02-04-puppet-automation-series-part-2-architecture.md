---
author: Summer Nguyen
layout: post
title: "Puppet Automation Series - Part 2 - Architecture"
date: 2016-02-04 10:30
comments: true
category: puppet
tags:
- puppet
- automation
---

---
**Previous Topic** : <a href="/puppet/2016/02/03/puppet-automation-series-part-1-introduction/">PUPPET AUTOMATION SERIES - PART 1 - INTRODUCTION</a>

**Next Topic** : <a href="/puppet/2016/02/04/puppet-automation-series-part-3-installation/">PUPPET AUTOMATION SERIES - PART 3 - INSTALLATION</a>

---

***Puppet Version***

There are 2 versions of Puppet: (From: <a href="https://puppetlabs.com/puppet/puppet-open-source">https://puppetlabs.com/puppet/puppet-open-source</a>)

* *Puppet Open Source*: Open Source Puppet is a declarative, model-based configuration management solution that lets you define the state of your IT infrastructure, using the Puppet language. Open Source Puppet then automatically enforces the correct configuration to ensure the right services are up and running, on the right platforms.
* *Puppet Enterprise* : **Puppet Open Souce** +  commercial-only enhancements, supported modules and integrations. 


and I use *Puppet OpenSource*





***Overview of Puppet's Architecture***

There are 2 deployment models when using Puppet : 

+ Master / Agent architecture 
+ Stand-Alone Architecture 


<p><img src="/images/puppet-series/puppet-architecture.jpg" alt="Puppet Architecture"></p>
<p class="text-center">
(Image from <a href="http://www.slideshare.net/GiacomoVacca/automatic-kamailiodeploymentswithpuppet-33085423">http://www.slideshare.net/GiacomoVacca/automatic-kamailiodeploymentswithpuppet-33085423</a>) </p>



Deployment architecture doesn't affect how we *code* the puppet configuration. The main different is : Where the puppet are configuration files placed and how we apply the configuration to the servers. And I will focus on Master / Agent architecture . 


***Master / Agent Architecture***

*"In this architecture, managed nodes run the Puppet agent application, usually as a background service. One or more servers run the Puppet master application, usually in the form of Puppet Server."*

There are two parts in this architecture : 

+ **Puppet agent** runs on all the servers we want to config.
+ **Puppet master** runs on seperated machine(s). 



*Communication and Security*

Puppet agent nodes and Puppet masters communicate via HTTPS with client-verification.

The Puppet master provides an HTTP interface, with various endpoints available. When requesting or submitting anything to the master, the agent will make an HTTPS request to one of those endpoints.


Client-verified HTTPS means each master or agent must have an identifying SSL certificate, and will examine their counterpart’s certificate to decide whether to allow an exchange of information.

Puppet includes a built-in certificate authority (CA) for managing certificates. Agents can automatically request certificates via the master’s HTTP API, users can use the puppet cert command to inspect requests and sign new certificates, and agents can then download the signed certificates.


How master and agent communicate : 
<p><img src="/images/puppet-series/puppet-master-slave-communication.jpg" alt="Puppet Architecture"></p>

<p class="text-center">
(Image from <a href="http://www.slideshare.net/ssuser5a2151/puppet-27665547">http://www.slideshare.net/ssuser5a2151/puppet-27665547</a>) </p>

And how the whole system works : 


<p><img src="/images/puppet-series/puppet-how-it-works.jpg" alt="Puppet Architecture"></p>

<p class="text-center">
(Image from <a href="http://www.slideshare.net/glynnfoster/managing-oracle-solaris-systems-with-puppet">http://www.slideshare.net/glynnfoster/managing-oracle-solaris-systems-with-puppet</a>) </p>



Hope you can understand how it works. 


---
**Previous Topic** : <a href="/puppet/2016/02/03/puppet-automation-series-part-1-introduction/">PUPPET AUTOMATION SERIES - PART 1 - INTRODUCTION</a>

**Next Topic** : <a href="/puppet/2016/02/04/puppet-automation-series-part-3-installation/">PUPPET AUTOMATION SERIES - PART 3 - INSTALLATION</a>