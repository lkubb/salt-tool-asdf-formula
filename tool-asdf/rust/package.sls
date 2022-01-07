{%- from 'tool-asdf/rust/init.sls' import users %}

include:
  - ..package

# Rust plugin uses rustup and does not compile from source, so no dependencies needed

{%- for user in users %}
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
