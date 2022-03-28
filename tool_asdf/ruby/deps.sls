# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/ruby/map.jinja" import dependencies %}

Required packages for compiling Ruby are available:
  pkg.installed:
    - pkgs: {{ dependencies }}
