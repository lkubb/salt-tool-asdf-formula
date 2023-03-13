"""
``asdf`` Salt Execution Module
==============================

Interface with ``asdf``. Queries available and installed
plugins and tool versions. Allows to manage those as well.
"""

# import logging
import re

import salt.utils.platform
from salt.exceptions import CommandExecutionError

# log = logging.getLogger(__name__)
__virtualname__ = "asdf"


def __virtual__():
    return __virtualname__


def _which(user=None):
    e = __salt__["cmd.run_stdout"]("command -v asdf", runas=user)
    # if e := __salt__["cmd.run_stdout"]("command -v asdf", runas=user)
    if e:
        __salt__["log.debug"]("Found asdf executable at {}".format(e))
        if "Apple" in __grains__["cpu_model"] and "x86_64" == __grains__["cpuarch"]:
            e = "arch -arm64 " + e
        return e
    if salt.utils.platform.is_darwin():
        p = __salt__["cmd.run_stdout"]("brew --prefix asdf", runas=user)
        # if p := __salt__["cmd.run_stdout"]("brew --prefix asdf", runas=user):
        if p:
            if "Apple" in __grains__["cpu_model"] and "x86_64" == __grains__["cpuarch"]:
                p = "arch -arm64 " + p
            __salt__["log.debug"]("Found asdf executable at {}".format(p))
            return p
    raise CommandExecutionError("Could not find asdf executable.")


def is_plugin_installed(name, user=None):
    """
    Checks whether a plugin with this name is installed by asdf.

    CLI Example:

    .. code-block:: bash

        salt '*' asdf.is_plugin_installed python user=user

    name
        The name of the plugin to check for.

    user
        The username to check for. Defaults to salt user.
    """

    return name in list_installed_plugins(user)


def is_plugin_available(name, user=None):
    """
    Checks whether a plugin with this name is available to asdf.

    CLI Example:

    .. code-block:: bash

        salt '*' asdf.is_plugin_available golang user=user

    name
        The name of the plugin to check for.

    user
        The username to check for. Defaults to salt user.
    """

    return name in list_available_plugins(user)


def is_version_installed(name, version, user=None):
    """
    Checks whether a tool version is installed by asdf.

    CLI Example:

    .. code-block:: bash

        salt '*' asdf.is_version_installed python 3.10.3 user=user
        salt '*' asdf.is_version_installed php latest user=user

    name
        The name of the plugin to check for.

    version
        The version of the tool to check for. Accepts ``latest``.

    user
        The username to check for. Defaults to salt user.
    """

    installed = _list_installed(user)

    if "latest" == version:
        version = get_latest(name, user)

    if name in installed.keys() and version in installed[name]:
        return True
    return False


def is_version_available(name, version, user=None):
    """
    Checks whether a tool version is available to asdf.

    CLI Example:

    .. code-block:: bash

        salt '*' asdf.is_version_available python 3.10.3 user=user

    name
        The name of the plugin to check for.

    version
        The version of the tool to check for.

    user
        The username to check for. Defaults to salt user.
    """

    if not is_plugin_available(name, user):
        raise CommandExecutionError(
            "Requested plugin {} is not available in asdf.".format(name)
        )
    return str(version) in list_available_versions(name, user)


def get_latest(name, user=None):
    """
    Returns the latest version of a tool.

    CLI Example:

    .. code-block:: bash

        salt '*' asdf.get_latest golang user=user

    name
        The name of the plugin to check for.

    user
        The username to check for. Defaults to salt user.
    """

    e = _which(user)

    return __salt__["cmd.run_stdout"]("{} latest '{}'".format(e, name), runas=user)


def install_plugin(name, user=None):
    """
    Installs a plugin to asdf.

    CLI Example:

    .. code-block:: bash

        salt '*' asdf.install_plugin python user=user

    name
        The name of the plugin to install.

    user
        The username to install the plugin. Defaults to salt user.
    """

    if not is_plugin_available(name, user):
        raise CommandExecutionError(
            "Requested plugin {} is not available in asdf.".format(name)
        )

    e = _which(user)

    __salt__["log.info"]("asdf: Installing plugin {}".format(name))

    # retcode returns shell-style retcode, need inverse
    return not __salt__["cmd.retcode"]("{} plugin-add '{}'".format(e, name), runas=user)


def install_version(name, version, user=None):
    """
    Installs a tool version with asdf.

    CLI Example:

    .. code-block:: bash

        salt '*' asdf.install_version python 3.10.3 user=user
        salt '*' asdf.install_version rust latest user=user

    name
        The name of the plugin to install the tool with.

    version
        The version of the tool to install. Accepts ``latest``.

    user
        The username to install the version for. Defaults to salt user.
    """

    if not is_plugin_installed(name, user):
        raise CommandExecutionError("Plugin {} is not installed.".format(name))

    e = _which(user)

    __salt__["log.info"]("asdf: Installing {} {}".format(name, version))

    return not __salt__["cmd.retcode"](
        "{} install '{}' '{}'".format(e, name, version), runas=user
    )


def remove_plugin(name, user=None):
    """
    Removes a plugin from asdf.

    CLI Example:

    .. code-block:: bash

        salt '*' asdf.remove_plugin ruby user=user

    name
        The name of the plugin to remove.

    user
        The username to remove the plugin for. Defaults to salt user.
    """

    if not is_plugin_installed(name, user):
        raise CommandExecutionError("Plugin {} is not installed.".format(name))

    e = _which(user)

    __salt__["log.info"]("asdf: Removing plugin {}".format(name))

    return not __salt__["cmd.retcode"](
        "{} plugin-remove '{}'".format(e, name), runas=user
    )


def remove_version(name, version, user=None):
    """
    Removes a tool version with asdf.

    CLI Example:

    .. code-block:: bash

        salt '*' asdf.remove_version python 2.7.5 user=user

    name
        The name of the plugin to remove the tool with.

    version
        The version of the tool to remove.

    user
        The username to remove the version for. Defaults to salt user.
    """

    if not is_plugin_installed(name, user):
        raise CommandExecutionError("Plugin {} is not installed.".format(name))

    if not is_version_installed(name, user):
        raise CommandExecutionError(
            "{} version {} is not installed.".format(name, version)
        )

    e = _which(user)

    __salt__["log.info"]("asdf: Removing {} {}".format(name, version))

    return not __salt__["cmd.retcode"](
        "{} uninstall '{}' '{}'".format(e, name, version), runas=user
    )


def update_plugin(name, user=None):
    """
    Updates an asdf plugin.

    CLI Example:

    .. code-block:: bash

        salt '*' asdf.update_plugin direnv user=user

    name
        The name of the plugin to update.

    user
        The username to update the plugin for. Defaults to salt user.
    """

    if not is_plugin_installed(name, user):
        raise CommandExecutionError("Plugin {} is not installed.".format(name))

    e = _which(user)

    __salt__["log.info"]("asdf: Updating plugin {}".format(name))

    return not __salt__["cmd.retcode"](
        "{} plugin-update '{}'".format(e, name), runas=user
    )


def update_plugins(user=None):
    """
    Updates all installed asdf plugins.

    CLI Example:

    .. code-block:: bash

        salt '*' asdf.update_plugins user=user

    user
        The username to update all plugins for. Defaults to salt user.
    """

    e = _which(user)

    __salt__["log.info"]("asdf: Updating plugins.")
    return not __salt__["cmd.retcode"]("{} plugin-update --all".format(e), runas=user)


def set_version(name, version, cwd="", user=None):
    """
    Sets a tool version, globally for a user or specific to a directory.

    CLI Example:

    .. code-block:: bash

        salt '*' asdf.set_version python 3.10.3 user=user
        salt '*' asdf.set_version python 2.7.5 cwd=/home/user/code/old_project user=user
        salt '*' asdf.set_version rust latest user=user

    name
        The name of the plugin that manages the tool.

    version
        The version of the tool to set. Accepts ``latest``.

    cwd
        If specified, set the local tool version for this specific directory.
        Leave empty to set the global tool version.

    user
        The username to set the version for. Defaults to salt user.
    """

    if not is_version_installed(name, version, user):
        raise CommandExecutionError(
            "{} version {} is not installed.".format(name, version)
        )

    if "latest" == version:
        version = get_latest(name, user)

    e = _which(user)

    if cwd:
        __salt__["log.info"]("asdf: Setting {} {} for {}".format(name, version, cwd))
        return not __salt__["cmd.retcode"](
            "{} local '{}' '{}'".format(e, name, version), cwd=cwd, runas=user
        )

    __salt__["log.info"]("asdf: Setting {} {} globally".format(name, version))
    return not __salt__["cmd.retcode"](
        "{} global '{}' '{}'".format(e, name, version), runas=user
    )


def reshim(user=None):
    """
    Runs an asdf reshim.

    CLI Example:

    .. code-block:: bash

        salt '*' asdf.reshim user=user

    user
        The username to reshim for. Defaults to salt user.
    """

    e = _which(user)
    __salt__["log.info"]("asdf: Starting reshim.")
    return not __salt__["cmd.retcode"]("{} reshim".format(e), runas=user)


def _list_installed(user=None):
    e = _which(user)
    installed = __salt__["cmd.run_stdout"](
        "{} list".format(e), runas=user, raise_err=True
    )

    parsed = {}
    for tool, versions in re.findall(
        r"^(\S+)\n((?:\s+\S+\n)+)", installed, re.MULTILINE
    ):
        parsed[tool] = [v.strip(" *") for v in versions.splitlines()]
    return parsed


def list_available_plugins(user=None):
    """
    Returns a list of available asdf plugins.

    CLI Example:

    .. code-block:: bash

        salt '*' asdf.list_available_plugins user=user

    user
        The username to run asdf with. Defaults to salt user.
    """

    e = _which(user)
    available = __salt__["cmd.run_stdout"](
        "{} plugin-list-all".format(e), runas=user, raise_err=True
    )
    return [x.split(" ")[0] for x in available.splitlines() if "updating " not in x]


def list_installed_plugins(user=None):
    """
    Returns a list of plugins that are installed to asdf.

    CLI Example:

    .. code-block:: bash

        salt '*' asdf.list_installed_plugins user=user

    user
        The username to list the installed plugins for. Defaults to salt user.
    """

    e = _which(user)
    installed = __salt__["cmd.run_stdout"](
        "{} plugin-list".format(e), runas=user, raise_err=True
    )
    __salt__["log.debug"]("asdf: List of installed plugins: {}".format(installed))
    return installed.splitlines()


def list_available_versions(name, user=None):
    """
    Returns a list of available versions for a specific plugin.

    CLI Example:

    .. code-block:: bash

        salt '*' asdf.list_available_versions golang user=user

    name
        The name of the plugin to list available versions for.

    user
        The username to run asdf with. Defaults to salt user.
    """

    e = _which(user)
    available = __salt__["cmd.run_stdout"](
        "{} list-all '{}'".format(e, name), runas=user, raise_err=True
    ).splitlines()

    __salt__["log.debug"]("asdf: Available versions for {}: {}".format(name, available))
    return available


def list_installed_versions(name, user=None):
    """
    Returns a list of installed versions for a specific plugin
    that were installed by asdf.

    CLI Example:

    .. code-block:: bash

        salt '*' asdf.list_installed_versions nodejs user=user

    name
        The name of the plugin to list the installed versions for.

    user
        The username to list the installed versions for. Defaults to salt user.
    """

    e = _which(user)
    installed = __salt__["cmd.run_stdout"](
        "{} list '{}'".format(e, name), runas=user, raise_err=True
    )
    if "No versions installed" in installed:
        return []
    return [v.strip(" *") for v in installed.splitlines()]


def get_current(name, cwd="", user=None):
    """
    Returns the version of a tool that is currently in use, either
    globally or for a specific directory.

    CLI Example:

    .. code-block:: bash

        salt '*' asdf.is_version_installed python 3.10.3 user=user

    name
        The name of the plugin to query the in-use version for.

    cwd
        If specified, queries the local tool version for this directory.
        Leave empty to query the global tool version.

    user
        The username to query for. Defaults to salt user.
    """

    if not cwd:
        cwd = "/"
    e = _which(user)
    current = __salt__["cmd.run_stdout"](
        "{} current '{}'".format(e, name), runas=user, cwd=cwd, raise_err=True
    )
    if not current:
        return None
    return re.split("[\s]+", current)[1]
