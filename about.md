---
layout: page
permalink: /about/index.html
title: Summer Nguyen
tags: [Summer, Nguyen]
chart: true
---

Thank you for your interest in my *notes*. I'm **Summer Nguyen**, from ***Viet Nam***, a small and beautiful country in South East Asia . 

I'm a System Enginneer working with Linux, especially CentOS and Ubuntu .





**Here is my Working TimeLine**
<section id="{{ page.section-type }}" class="container content-section text-center">
 <div class="row">
     <div class="col-md-10 col-md-offset-1">
	<ul class="timeline">

        {% for event in site.events %}
          {% assign loopindex = forloop.index | modulo: 2 %}
          {% capture class %}
          {% if loopindex == 0 %}
            timeline-inverted
          {% endif %}
          {% endcapture %}

          <li class="{{ class }}">
            <div class="timeline-image">
              <img class="img-circle img-responsive" style="border-radius:50%" src="{{site.baseurl}}{{ event.image }}" alt="">
            </div>
            <div class="timeline-panel">
              <div class="timeline-heading">
                <h4>{{ event.date }}</h4>
              </div>
              <div class="timeline-body">
                {{ event.description | markdownify }}
              </div>
            </div>
          </li>
        {% endfor %}

        <li class="timeline-inverted">
          <div class="timeline-image">
            <img class="img-circle img-responsive" style="border-radius:50%" src="{{site.baseurl}}{{ site.timeline-img }}" alt="">
          </div>
        </li>
      </ul>
     </div>
</div>


</section>