{%- from 'tool-asdf/map.jinja' import asdf -%}

{%- set mode = 'latest' if asdf.get('update_auto')
                        and not grains['kernel'] == 'Darwin'
          else 'installed' %}

asdf is installed:
  pkg.{{ mode }}:
    - name: asdf

asdf setup is completed:
  test.nop:
    - name: asdf setup has finished, hooray.
    - require:
      - asdf is installed
