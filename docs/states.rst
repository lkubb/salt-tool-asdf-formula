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
Has a dependency on `tool_asdf.package`_.


