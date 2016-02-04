---
author: Summer Nguyen
layout: post
title: "Puppet Automation Series - Part 1 - Introduction"
date: 2016-02-03 17:30
comments: true
category: puppet
tags:
- puppet
- automation
---


"Puppet is an amazingly powerful and flexible tool. It's one that can change your daily work flow for the better once you start using it, but like all open ended tools, it can take a little while to become familiar with." - <a href="http://www.puppetcookbook.com/" >Puppet Cookbook</a>


***About the history***

I am a *manual* system engineer for a long time from the beginning of my Career through Oct ,2014 . With my jobs, I always get the simple tasks days by days : 

+ Create user ***foo***
+ Create directory ***bar*** owned by ***foo*** with mode **755**
+ Mount the NFS *path* to the *mount point*
+ Add a Virtual Host in Apache HTTPD with domain *www.domain.com* , document root *docroot* , ... 
+ ...

And I *ssh* to the server, and type commands . There is nothing easier than that, you know :) . 

*All the tasks are very simple .... until :*

+ System Engineer don't have tasks on normal days, but some days, we have to build **many** servers a time .
+ We have to build a new server exactly the same with the old one. (**most common task**)
+ The old server has a serious problem in storage that we can not recover. (**rarely task, but posible** )


*And the result is :*

+ I am a bit free on normal days, and very busy at some days that makes me crazy. 
+ It takes me half a day to install a server, and I still don't know if it is really the same as the one one :(
+ I had a terrible incident when I had a task migrating all services from *Server A* to *Server B* : I forgot starting the **scribed** log server, and we had lost all the logs for about 20 hours -.-!
+ I had to do the same commands everytime I have to build a new Server : create user, add directory, install services , ... . And it took me too much time . 
+ The developers sometimes asked me a terrible question : **Why did the services work last week, but not now ??** . (Actually, it has never worked before, but I can not prove it -.-!)


**And Now, when I use Puppet**

+ I can *code* and carefully review the configuration file for the servers before I got the server. (FYI, I have to request Server to the Server & Storage Department, and they will give me the server after 3 days).
+ It tooks me only 5 minutes to install a new Servers. 
+ I can *clone* a new server in 5 minutes. Yeah, *clone* means exactly the same.
+ I commit my puppet configuration files to a GIT repository, so that I have evidences of server changes history. 
+ I have much time for researching new technologies, relaxing my life, ... 



***About this Series***

As there are many documents using Puppet on the internet, I won't dig into Puppet configuration too much. I just write about my experiences: 

+ How do I build my automation system using Puppet
+ How to use some useful modules
+ How to create your own modules 


Hope you will love this series. Please feel free to feedback to my posts.  Thank you.