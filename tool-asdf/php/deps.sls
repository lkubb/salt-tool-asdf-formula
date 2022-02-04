{%- from 'tool-asdf/php/map.jinja' import dependencies, pkg_mode -%}

Required packages for compiling PHP are available:
  pkg.{{ pkg_mode }}:
    - pkgs: {{ dependencies }}
