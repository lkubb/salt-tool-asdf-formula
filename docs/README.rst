.. _readme:

asdf Formula
============

Manages asdf and some selected tools for development environments in the user environment.

.. contents:: **Table of Contents**
   :depth: 1

Usage
-----
Applying ``tool_asdf`` will make sure ``asdf`` and its managed packages are configured as specified.

Execution and state module
~~~~~~~~~~~~~~~~~~~~~~~~~~
This formula provides a custom execution module and state to manage packages installed with asdf. The functions are self-explanatory, please see the source code or the rendered docs at :ref:`em_asdf` and :ref:`sm_asdf`.

Configuration
-------------

This formula
~~~~~~~~~~~~
The general configuration structure is in line with all other formulae from the `tool` suite, for details see :ref:`toolsuite`. An example pillar is provided, see :ref:`pillar.example`. Note that you do not need to specify everything by pillar. Often, it's much easier and less resource-heavy to use the ``parameters/<grain>/<value>.yaml`` files for non-sensitive settings. The underlying logic is explained in :ref:`map.jinja`.

User-specific
^^^^^^^^^^^^^
The following shows an example of ``tool_asdf`` per-user configuration. If provided by pillar, namespace it to ``tool_global:users`` and/or ``tool_asdf:users``. For the ``parameters`` YAML file variant, it needs to be nested under a ``values`` parent key. The YAML files are expected to be found in

1. ``salt://tool_asdf/parameters/<grain>/<value>.yaml`` or
2. ``salt://tool_global/parameters/<grain>/<value>.yaml``.

.. code-block:: yaml

  user:

      # Force the usage of XDG directories for this user.
    xdg: true

      # Put shell completions into this directory, relative to user home.
    completions: '.config/zsh/completions'

      # Sync this user's config from a dotfiles repo.
      # The available paths and their priority can be found in the
      # rendered `config/sync.sls` file (currently, @TODO docs).
      # Overview in descending priority:
      # salt://dotconfig/<minion_id>/<user>/asdf
      # salt://dotconfig/<minion_id>/asdf
      # salt://dotconfig/<os_family>/<user>/asdf
      # salt://dotconfig/<os_family>/asdf
      # salt://dotconfig/default/<user>/asdf
      # salt://dotconfig/default/asdf
    dotconfig:              # can be bool or mapping
      file_mode: '0600'     # default: keep destination or salt umask (new)
      dir_mode: '0700'      # default: 0700
      clean: false          # delete files in target. default: false

      # Persist environment variables used by this formula for this
      # user to this file (will be appended to a file relative to $HOME)
    persistenv: '.config/zsh/zshenv'

      # Add runcom hooks specific to this formula to this file
      # for this user (will be appended to a file relative to $HOME)
    rchook: '.config/zsh/zshrc'

      # This user's configuration for this formula. Will be overridden by
      # user-specific configuration in `tool_asdf:users`.
      # Set this to `false` to disable configuration for this user.
    asdf:
        # plugin: version to install. Can be True (for latest), list or string.
      direnv: 2.30.3
      golang: latest
        # If direnv is installed, make sure envrc files can use asdf.
      integrate_direnv: true
      nodejs: 17.8.0
      php: 8.1.4
      python: 3.10.3
      ruby: 3.1.0
      rust: latest
        # User-specific defaults of global tool versions.
      system:
        python: 3.10.3
        # Keep plugins updated to latest version on subsequent runs.
      update_auto: true

Formula-specific
^^^^^^^^^^^^^^^^

.. code-block:: yaml

  tool_asdf:

      # Specify an explicit version (works on most Linux distributions) or
      # keep asdf updated to the latest version on subsequent runs
      # by leaving version empty or setting it to 'latest'
      # (again for Linux, brew does that anyways).
    version: latest

      # Default formula configuration for all users.
    defaults:
      update_auto: default value for all users


Global files
~~~~~~~~~~~~
Some tools need global configuration files. A default one is provided with the formula, but can be overridden via the TOFS pattern. See :ref:`tofs_pattern` for details.

Dotfiles
~~~~~~~~
``tool_asdf.config.sync`` will recursively apply templates from

* ``salt://dotconfig/<minion_id>/<user>/asdf``
* ``salt://dotconfig/<minion_id>/asdf``
* ``salt://dotconfig/<os_family>/<user>/asdf``
* ``salt://dotconfig/<os_family>/asdf``
* ``salt://dotconfig/default/<user>/asdf``
* ``salt://dotconfig/default/asdf``

to the user's config dir for every user that has it enabled (see ``user.dotconfig``). The target folder will not be cleaned by default (ie files in the target that are absent from the user's dotconfig will stay).

The URL list above is in descending priority. This means user-specific configuration from wider scopes will be overridden by more system-specific general configuration.


Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``tool_asdf``
~~~~~~~~~~~~~
*Meta-state*.

Performs all operations described in this formula according to the specified configuration.


``tool_asdf.package``
~~~~~~~~~~~~~~~~~~~~~
Installs the asdf package only.


``tool_asdf.xdg``
~~~~~~~~~~~~~~~~~
Ensures asdf adheres to the XDG spec
as best as possible for all managed users.
Has a dependency on `tool_asdf.package`_.


``tool_asdf.config``
~~~~~~~~~~~~~~~~~~~~
Manages the asdf package configuration by

* recursively syncing from a dotfiles repo

Has a dependency on `tool_asdf.package`_.


``tool_asdf.completions``
~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_asdf.system``
~~~~~~~~~~~~~~~~~~~~



``tool_asdf.system.configure``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_asdf.direnv``
~~~~~~~~~~~~~~~~~~~~



``tool_asdf.direnv.hook``
~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_asdf.direnv.integrate``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_asdf.direnv.package``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_asdf.golang``
~~~~~~~~~~~~~~~~~~~~



``tool_asdf.golang.deps``
~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_asdf.golang.package``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_asdf.golang.xdg``
~~~~~~~~~~~~~~~~~~~~~~~~



``tool_asdf.nodejs``
~~~~~~~~~~~~~~~~~~~~



``tool_asdf.nodejs.deps``
~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_asdf.nodejs.package``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_asdf.nodejs.xdg``
~~~~~~~~~~~~~~~~~~~~~~~~



``tool_asdf.php``
~~~~~~~~~~~~~~~~~



``tool_asdf.php.deps``
~~~~~~~~~~~~~~~~~~~~~~



``tool_asdf.php.package``
~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_asdf.python``
~~~~~~~~~~~~~~~~~~~~



``tool_asdf.python.deps``
~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_asdf.python.package``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_asdf.python.xdg``
~~~~~~~~~~~~~~~~~~~~~~~~



``tool_asdf.ruby``
~~~~~~~~~~~~~~~~~~



``tool_asdf.ruby.deps``
~~~~~~~~~~~~~~~~~~~~~~~



``tool_asdf.ruby.package``
~~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_asdf.ruby.xdg``
~~~~~~~~~~~~~~~~~~~~~~



``tool_asdf.rust``
~~~~~~~~~~~~~~~~~~



``tool_asdf.rust.package``
~~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_asdf.rust.xdg``
~~~~~~~~~~~~~~~~~~~~~~



``tool_asdf.clean``
~~~~~~~~~~~~~~~~~~~
*Meta-state*.

Undoes mostly everything performed in the ``tool_asdf`` meta-state
in reverse order.


``tool_asdf.package.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes the asdf package.
Has a dependency on `tool_asdf.config.clean`_.


``tool_asdf.xdg.clean``
~~~~~~~~~~~~~~~~~~~~~~~
Removes asdf XDG compatibility crutches for all managed users.


``tool_asdf.config.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes the configuration of the asdf package.


``tool_asdf.completions.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes asdf completions for all managed users.



Development
-----------

Contributing to this repo
~~~~~~~~~~~~~~~~~~~~~~~~~

Commit messages
^^^^^^^^^^^^^^^

Commit message formatting is significant.

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``.

.. code-block:: console

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

State documentation
~~~~~~~~~~~~~~~~~~~
There is a script that semi-autodocuments available states: ``bin/slsdoc``.

If a ``.sls`` file begins with a Jinja comment, it will dump that into the docs. It can be configured differently depending on the formula. See the script source code for details currently.

This means if you feel a state should be documented, make sure to write a comment explaining it.

Todo
----
- finish migration to new format for subcomponents
- allow arbitrary plugins (easily doable with new format)
- generalize plugins to definitions to avoid repetition. maybe like that:

  .. code-block:: yaml

    python:
      dependencies:
        - list
        - of
        - pkgs
      xdg_vars:
        config:
          - GIMME_BLOODY_XDG_YO: .default-stuff
