{%- for user in salt['pillar.get']('tool:asdf', []) | rejectattr('xdg', 'sameas', False) %}
  {%- from 'tool-asdf/map.jinja' import user, xdg with context %}

asdf python plugin global configuration is migrated to XDG_CONFIG_HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ xdg.config }}/asdf/default-python-packages
    - source: {{ user.home }}/.default-python-packages
    - makedirs: true

asdf python uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        ASDF_PYTHON_DEFAULT_PACKAGES_FILE: "{{ xdg.config }}/asdf/default-python-packages"

  {%- if user.persistenv %}
asdf python plugin knows about XDG location for user '{{ user.name }}':
  file.append:
    - name: {{ user.home }}/{{ user.persistenv }}
    - text: export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/default-python-packages"
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
  {%- endif %}
{%- endfor %}
