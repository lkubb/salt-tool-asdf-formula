"""
``asdf`` Salt State Module
==========================

Manage asdf plugins and tool versions.
"""

# import logging
import salt.exceptions

# import salt.utils.platform

# log = logging.getLogger(__name__)

__virtualname__ = "asdf"


def __virtual__():
    return __virtualname__


def plugin_installed(name, user=None):
    """
    Make sure asdf plugin is installed.

    name
        The name of the plugin to install, if not installed already.

    user
        The username to install the plugin for. Defaults to salt user.

    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    try:
        if __salt__["asdf.is_plugin_installed"](name, user):
            ret["comment"] = "Plugin is already installed."
        elif __opts__["test"]:
            ret["result"] = None
            ret[
                "comment"
            ] = "Plugin {} would have been installed for user '{}'.".format(name, user)
            ret["changes"] = {"installed": name}
        elif __salt__["asdf.install_plugin"](name, user):
            ret["comment"] = "Plugin {} was installed for user '{}'.".format(name, user)
            ret["changes"] = {"installed": name}
        else:
            ret["result"] = False
            ret["comment"] = "Something went wrong while calling asdf."
    except salt.exceptions.CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = str(e)

    return ret


def plugin_latest(name, user=None):
    """
    Make sure asdf plugins are up to date.

    name
        The name of the plugin to update. Use 'all' to update all plugins.

    user
        The username to update the plugin for. Defaults to salt user.

    """
    ret = {"name": name or "all", "result": True, "comment": "", "changes": {}}

    try:
        if name is None or name == "all":
            if __opts__["test"]:
                ret["result"] = None
                ret[
                    "comment"
                ] = "All plugins would have been updated for user '{}'.".format(user)
                ret["changes"] = {"updated": "all"}
            elif __salt__["asdf.update_plugins"](None, user):
                ret["comment"] = "All plugins were updated for user '{}'.".format(user)
                ret["changes"] = {"updated": "all"}
            else:
                ret["result"] = False
                ret["comment"] = "Something went wrong while calling asdf."
            return ret

        if __salt__["asdf.is_plugin_installed"](name, user):
            ret["comment"] = "Plugin is already installed."
        elif __opts__["test"]:
            ret["result"] = None
            ret[
                "comment"
            ] = "Plugin {} would have been installed for user '{}'.".format(name, user)
            ret["changes"] = {"installed": name}
        elif __salt__["asdf.install_plugin"](name, user):
            ret["comment"] = "Plugin {} was installed for user '{}'.".format(name, user)
            ret["changes"] = {"installed": name}
        else:
            ret["result"] = False
            ret["comment"] = "Something went wrong while calling asdf."
    except salt.exceptions.CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = str(e)

    return ret


def plugin_absent(name, user=None):
    """
    Make sure asdf plugin is removed.

    name
        The name of the plugin to remove, if installed.

    user
        The username to remove the plugin for. Defaults to salt user.

    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    try:
        if not __salt__["asdf.is_plugin_installed"](name, user):
            ret["comment"] = "Plugin is already removed."
        elif __opts__["test"]:
            ret["result"] = None
            ret["comment"] = "Plugin {} would have been removed for user '{}'.".format(
                name, user
            )
            ret["changes"] = {"removed": name}
        elif __salt__["asdf.remove_plugin"](name, user):
            ret["comment"] = "Plugin {} was removed for user '{}'.".format(name, user)
            ret["changes"] = {"removed": name}
        else:
            ret["result"] = False
            ret["comment"] = "Something went wrong while calling asdf."
    except salt.exceptions.CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = str(e)

    return ret


def version_installed(name, version, user=None):
    """
    Make sure a specific tool version is installed. Installs the required
    plugin as well, if it's not already installed.

    CLI Example:

    .. code-block:: bash

        salt '*' asdf.version_installed python latest

    name
        The name of the plugin to install, if not installed already.

    version
        The version to install, if not installed already.

    user
        The username to install the tool version for.

    """
    ret = {"name": name, "result": True, "comment": "", "changes": {"installed": []}}

    try:
        if __salt__["asdf.is_version_installed"](name, version, user):
            ret["comment"] = "Requested {} version {} is already installed.".format(
                name, version
            )
            ret["changes"] = {}
            return ret
        if not __salt__["asdf.is_plugin_installed"](name, user):
            if __opts__["test"]:
                ret["result"] = None
            elif not __salt__["asdf.install_plugin"](name, user=user):
                ret["result"] = False
                ret[
                    "comment"
                ] = "Requested plugin is not installed and could not be installed automatically."
                ret["changes"] = {}
                return ret
            ret["changes"]["installed"].append("plugin '{}'.".format(name))
        if __opts__["test"]:
            ret["result"] = None
            ret[
                "comment"
            ] = "{} version {} would have been installed for user '{}'.".format(
                name, version, user
            )
            ret["changes"]["installed"].append("{} version {}".format(name, version))
        elif __salt__["asdf.install_version"](name, version, user):
            ret["comment"] = "{} version {} was installed for user '{}'.".format(
                name, version, user
            )
            ret["changes"]["installed"].append("{} version {}".format(name, version))
        else:
            ret["result"] = False
            ret["comment"] = "Something went wrong while calling asdf."
    except salt.exceptions.CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = str(e)

    if not ret["changes"]["installed"]:
        ret["changes"] = {}

    return ret


def version_absent(name, version, user=None):
    """
    Make sure a specific tool version is not installed.

    name
        The name of the plugin for the tool.

    version
        The tool version to remove, if not absent already.

    user
        The username to remove the tool version for.

    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    try:
        if not __salt__["asdf.is_version_installed"](name, version, user):
            ret["comment"] = "{} version {} is already absent.".format(name, version)
        elif __opts__["test"]:
            ret["result"] = None
            ret[
                "comment"
            ] = "{} version {} would have been removed for user '{}'.".format(
                name, version, user
            )
            ret["changes"] = {"removed": "{} version {}".format(name, version)}
        elif __salt__["asdf.remove_version"](name, version, user):
            ret["comment"] = "{} version {} was removed for user '{}'.".format(
                name, version, user
            )
            ret["changes"] = {"removed": "{} version {}".format(name, version)}
        else:
            ret["result"] = False
            ret["comment"] = "Something went wrong while calling asdf."
    except salt.exceptions.CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = str(e)

    return ret


def version_set(name, version, cwd="", user=None):
    """
    Make sure a specific tool version is set as default. If cwd is specified,
    it will be the default local to the path. If it is empty, the tool version
    will be set globally.

    name
        The name of the tool

    version
        The tool version that is to be set as default

    cwd
        If specified, set the local tool version for this specific directory.
        Leave empty to set the global tool version.

    user
        The username to set the tool version for.
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    try:
        if not __salt__["asdf.is_version_installed"](name, version, user):
            ret["result"] = False
            ret["comment"] = "Requested tool version is not installed."
            if __opts__["test"]:
                ret["result"] = None
                ret[
                    "comment"
                ] += " If you installed the tool version in a previous state, everything will be fine."
            return ret

        current = __salt__["asdf.get_current"](name, cwd, user)
        if "latest" == version:
            version = __salt__["asdf.get_latest"](name, user)
        if current == version:
            ret["comment"] = "{} version {} is already used".format(name, version)
            ret["comment"] += " globally." if not cwd else " in path '{}'.".format(cwd)
        elif __opts__["test"]:
            ret["result"] = None
            ret["comment"] = "{} version {} would have been set for user '{}'".format(
                name, version, user
            )
            ret["comment"] += " globally." if not cwd else " in path '{}'.".format(cwd)
            ret["changes"]["system default"] = "Default {} {} version {}".format(
                name, "local" if cwd else "global", version
            )
        elif __salt__["asdf.set_version"](name, version, cwd, user):
            ret["comment"] = "{} version {} was set for user '{}'".format(
                name, version, user
            )
            ret["comment"] += " globally." if not cwd else " in path '{}'.".format(cwd)
            ret["changes"]["system default"] = "Default {} {} version {}".format(
                name, "local" if cwd else "global", version
            )
        else:
            ret["result"] = False
            ret["comment"] = "Something went wrong while calling asdf."
    except salt.exceptions.CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = str(e)

    return ret
