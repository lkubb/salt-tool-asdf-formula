# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/python/map.jinja" import dependencies %}

Required packages for compiling Python are available:
  pkg.installed:
    - pkgs: {{ dependencies }}
