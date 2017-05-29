---
layout: page
title: Contact
permalink: /contact/
---
If you wish to contact me, my e-mail is: [{{site.email}}](mailto:{{site.email}}). <br/>
Alternatively, reach me at any of the following:
<div id="wrap">
<ul>
{% if site.twitter_username %}
  <li>
    <a href="https://twitter.com/{{ site.twitter_username }}">   {{site.twitter_username}}
      <i class="fa fa-twitter"></i>
    </a>
  </li>
{% endif %}

{% if site.github_username %}
  <li>
    <a href="https://github.com/{{ site.github_username }}">   {{site.github_username}}
      <i class="fa fa-github"></i>
    </a>
  </li>
{% endif %}
{% if site.linkedin_username %}
  <li>
    <a href="https://linkedin.com/in/{{ site.linkedin_username }}">LinkedIn
      <i class="fa fa-linkedin"></i>
    </a>
  </li>
{% endif %}
{% if site.facebook_username %}
  <li>
    <a href="https://www.facebook.com/{{ site.facebook_username }}">Facebook
      <i class="fa fa-facebook"></i>
    </a>
  </li>
{% endif %}
</ul>
</div>
