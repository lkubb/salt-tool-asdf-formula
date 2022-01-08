{%- from 'tool-asdf/rust/init.sls' import users %}

include:
  - ..package

# Rust plugin uses rustup and does not compile from source, so no dependencies needed

{%- for user in users %}
  {%- if user.asdf.get('update_auto') %}

Rust plugin is up to date for user '{{ user.name }}':
  asdf.plugin_latest:
    - name: rust
    - user: {{ user.name }}
  {%- endif %}

  {%- for version in user.asdf.rust %}

Rust {{ version }} is installed for user '{{ user.name }}':
  asdf.version_installed:
    - name: rust
    - version: {{ version }}
    - user: {{ user.name }}
    - require:
      - asdf setup is completed
  {%- endfor %}
{%- endfor %}
