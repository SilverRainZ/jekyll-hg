Jekyll HG
=========

Jekyll plugin for generating project home page from github repository.

Usage
----

1. Put `_plugins/*.rb` in  your jekyll site's `_plugins` directory.

2. Add the following line in your `_config.yml`:

```yaml
github: <owner>/<repo>
```

3. While building jekyll site, informations of specified repository will be
fetched and stored as [variables](#variables) in
`Jekyll::Site.config['project']`.  You can access them using liquid template
like `{{ site.project.* }}`.

4. Using these variables to construct your site!

Variables
---------

All available variables are listed here. Take
[SilverRainZ/srain](https://github.com/SilverRainZ/srain) as an example,
if you set `github: SilverRainZ/srain` in your `_config.yml`, your will get
the following variables:

```yaml
project:
    name: srain
    full_name: SilverRainZ/srain
    description: Modern, beautiful IRC client written in GTK+ 3.
    url: https://github.com/SilverRainZ/srain
    forks_count: 4
    stargazers_count: 27
    owner:
        name: SilverRainZ
        url: https://github.com/SilverRainZ
        avatar_url: https://avatars0.githubusercontent.com/u/8090459?v=4
        gravatar_id: ''
    releases:
        - name: ''
          version: 0.06.2
          date: !ruby/object:DateTime 2017-09-11 17:08:18.000000000 Z
          url: https://github.com/SilverRainZ/srain/releases/tag/0.06.2
          prerelease: true
          notes: '<release notes>'
          source:
            tar: https://api.github.com/repos/SilverRainZ/srain/tarball/0.06.2
            zip: https://api.github.com/repos/SilverRainZ/srain/zipball/0.06.2
          artifacts: {} # Not supported yet
        - <more releases...>
    readme:
        name: README.rst
        raw: '<raw content of README>'
        html: '<rendered README>'
```

Demo
----

For the simplest demo, clone this repository and built it:

```
git clone https://github.com/SilverRainZ/jekyll-hg.git
cd jekyll-hg
jekyll serve
```

In addition,
[srain.im](https://srain.im)([source](https://github.com/SilverRainZ/srain.im))
is an application of this plugin.
