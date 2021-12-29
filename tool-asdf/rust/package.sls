{%- from 'tool-asdf/map.jinja' import asdf %}

include:
  - ..package

# Rust plugin uses rustup and does not compile from source, so no dependencies needed

{%- for user in asdf.users | selectattr('asdf.rust') %}
  {# ugly workaround for uglier statement
    {%- set versions = user.rust if user.rust is iterable and (user.rust is not string and user.rust is not mapping) else [user.rust] %}#}
  {%- set versions = user.rust if user.rust.__class__.__name__ == 'list' else [user.rust if user.rust is not sameas True else 'latest'] %}
  {%- for version in versions %}
Rust {{ version }} is installed for user '{{ user.name }}':
  asdf.version_installed:
    - name: rust
    - version: {{ version }}
    - user: {{ user.name }}
    - require:
      - sls: ..package
  {%- endfor %}
{%- endfor %}
