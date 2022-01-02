{%- from 'tool-asdf/rust/init.sls' import users %}

{%- for user in users | rejectattr('xdg', 'sameas', False) %}
asdf Rust plugin global configuration is migrated to XDG_CONFIG_HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ users.xdg.config }}/asdf/.default-cargo-crates
    - source: {{ user.home }}/.default-cargo-crates
    - makedirs: true

# rust plugin only allows to set basedir and always appends .default-cargo-crates

asdf Rust uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        ASDF_CRATE_DEFAULT_PACKAGES_FILE: "{{ users.xdg.config }}/asdf"

  {%- if user.get('persistenv') %}
asdf Rust plugin knows about XDG location for user '{{ user.name }}':
  file.append:
    - name: {{ user.home }}/{{ user.persistenv }}
    - text: |
        export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/asdf"
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
  {%- endif %}
{%- endfor %}
