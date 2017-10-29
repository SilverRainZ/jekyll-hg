---
---

- name: {{ site.project.name }}
- owner: {{ site.project.owner }}
- url: {{ site.project.url }}
- description: {{ site.project.description }}

README
------

{{ site.project.readme.html }}

RELEASE
------

{% for new in site.project.releases %}

---

{{ new.date | date:"%m/%d/%Y" }} - {{ new.version }}

{{ new.notes }}{% endfor %}

