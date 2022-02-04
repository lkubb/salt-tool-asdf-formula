{%- from 'tool-asdf/golang/map.jinja' import dependencies, pkg_mode -%}

Required packages for compiling Go are available:
  pkg.{{ pkg_mode }}:
    - pkgs: {{ dependencies }}
