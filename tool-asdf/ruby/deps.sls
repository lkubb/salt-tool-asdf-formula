{%- from 'tool-asdf/ruby/map.jinja' import dependencies, pkg_mode -%}

Required packages for compiling Ruby are available:
  pkg.{{ pkg_mode }}:
    - pkgs: {{ dependencies }}
