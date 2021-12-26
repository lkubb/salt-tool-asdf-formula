{%- for user in salt['pillar.get']('tool:asdf', []) | rejectattr('xdg', 'sameas', False) %}
  {%- from 'tool-asdf/map.jinja' import user, xdg with context %}

asdf configuration is migrated to XDG_CONFIG_HOME for user '{{ user.name }}':
  file.rename:
    - names:
      - {{ xdg.config }}/asdf/tool-versions:
        - source: {{ user.home }}/.tool-versions
      - {{ xdg.config }}/asdf/asdfrc:
        - source: {{ user.home }}/.asdfrc
    - makedirs: true

asdf data is migrated to XDG_DATA_HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ xdg.data }}/asdf
    - source: {{ user.home }}/.asdf
    - makedirs: true

asdf uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        ASDF_CONFIG_FILE: "{{ xdg.config }}/asdf/asdfrc"
        ASDF_DATA_DIR: "{{ xdg.data }}/asdf"
        ASDF_DEFAULT_TOOL_VERSIONS_FILENAME: "{{ xdg.config }}/asdf/tool-versions"

  {%- if user.persistenv %}
asdf knows about XDG locations for user '{{ user.name }}':
  file.append:
    - name: {{ user.home }}/{{ user.persistenv }}
    - text: |
        export ASDF_CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/asdfrc"
        export ASDF_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/asdf"
        export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/tool-versions"
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
  {%- endif %}
{%- endfor %}
