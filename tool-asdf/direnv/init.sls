{%- from 'tool-asdf/map.jinja' import asdf %}

{%- set users = asdf.users | selectattr('asdf.direnv', 'defined') | list -%} {# casting to list ensures it can be imported #}
{%- set pkg_mode = 'latest' if asdf.get('update_auto') else 'installed' %}

include:
  - .package
{%- if users | selectattr('rchook', 'defined') | list %}
  - .hook
{%- endif %}
{%- if users | selectattr('asdf.integrate-direnv', 'defined') | selectattr('asdf.integrate-direnv') | list %}
  - .integrate
{%- endif %}
