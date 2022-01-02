{%- from 'tool-asdf/ruby/map.jinja' import users %}

{%- for user in users %}
asdf ruby plugin global configuration is migrated to XDG_CONFIG_HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user.xdg.config }}/asdf/default-gems
    - source: {{ user.home }}/.default-gems
    - makedirs: true

asdf python uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        ASDF_GEM_DEFAULT_PACKAGES_FILE: "{{ user.xdg.config }}/asdf/default-gems"

  {%- if user.get('persistenv') %}
asdf python plugin knows about XDG location for user '{{ user.name }}':
  file.append:
    - name: {{ user.home }}/{{ user.persistenv }}
    - text: export ASDF_GEM_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/default-gems"
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
  {%- endif %}
{%- endfor %}
