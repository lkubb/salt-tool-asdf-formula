{%- from 'tool-asdf/map.jinja' import asdf %}

{%- if asdf.users | selectattr('system') %}
include:
  - .system
{%- endif %}

asdf is updated to latest version:
{%- if grains['kernel'] == 'Darwin' %}
  pkg.installed: # assumes homebrew as package manager. homebrew always installs the latest version, mac_brew_pkg does not support upgrading a single package
{%- else %}
  pkg.latest:
{%- endif %}
    - name: {{ asdf.package }}

{%- for user in asdf.users %}
asdf plugins are up to date:
  asdf.plugin_uptodate:
    - user: {{ user.name }}
{%- endfor %}
