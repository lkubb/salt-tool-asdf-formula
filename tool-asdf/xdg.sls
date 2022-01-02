{%- from 'tool-asdf/map.jinja' import asdf -%}

include:
  - .package

{%- for user in asdf.users | rejectattr('xdg', 'sameas', False) %}
asdf configuration is migrated to XDG_CONFIG_HOME for user '{{ user.name }}':
  file.rename:
    - names:
      - {{ user.xdg.config }}/asdf/tool-versions:
        - source: {{ user.home }}/.tool-versions
      - {{ user.xdg.config }}/asdf/asdfrc:
        - source: {{ user.home }}/.asdfrc
    - makedirs: true

asdf data is migrated to XDG_DATA_HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user.xdg.data }}/asdf
    - source: {{ user.home }}/.asdf
    - makedirs: true

asdf uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        ASDF_CONFIG_FILE: "{{ user.xdg.config }}/asdf/asdfrc"
        ASDF_DATA_DIR: "{{ user.xdg.data }}/asdf"
        ASDF_DEFAULT_TOOL_VERSIONS_FILENAME: "{{ user.xdg.config }}/asdf/tool-versions"

  {%- if user.get('persistenv') %}
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
