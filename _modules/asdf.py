from salt.exceptions import CommandExecutionError
# import logging
import re

import salt.utils.platform

# log = logging.getLogger(__name__)
__virtualname__ = "asdf"


def __virtual__():
    return __virtualname__


def _which(user=None):
    e = __salt__["cmd.run_stdout"]("command -v asdf", runas=user)
    # if e := __salt__["cmd.run_stdout"]("command -v asdf", runas=user)
    if e:
        __salt__['log.debug']('Found asdf executable at {}'.format(e))
        if 'Apple' in __grains__['cpu_model'] and 'x86_64' == __grains__['cpuarch']:
            e = 'arch -arm64 ' + e
        return e
    if salt.utils.platform.is_darwin():
        p = __salt__["cmd.run_stdout"]("brew --prefix asdf", runas=user)
        # if p := __salt__["cmd.run_stdout"]("brew --prefix asdf", runas=user):
        if p:
            if 'Apple' in __grains__['cpu_model'] and 'x86_64' == __grains__['cpuarch']:
                p = 'arch -arm64 ' + p
            __salt__['log.debug']('Found asdf executable at {}'.format(p))
            return p
    raise CommandExecutionError("Could not find asdf executable.")


def is_plugin_installed(name, user=None):
    return name in list_installed_plugins(user)


def is_plugin_available(name, user=None):
    return name in list_available_plugins(user)


def is_version_installed(name, version, user=None):
    installed = _list_installed(user)

    if 'latest' == version:
        version = get_latest(name, user)

    if name in installed.keys() and version in installed[name]:
        return True
    return False


def is_version_available(name, version, user=None):
    if not is_plugin_available(name, user):
        raise CommandExecutionError('Requested plugin {} is not available in asdf.'.format(name))
    return str(version) in list_available_versions(name, user)


def get_latest(name, user=None):
    e = _which(user)

    return __salt__['cmd.run_stdout']("{} latest '{}'".format(e, name), runas=user)

def install_plugin(name, user=None):
    if not is_plugin_available(name, user):
        raise CommandExecutionError('Requested plugin {} is not available in asdf.'.format(name))

    e = _which(user)

    __salt__['log.info']('asdf: Installing plugin {}'.format(name))

    # retcode returns shell-style retcode, need inverse
    return not __salt__['cmd.retcode']("{} plugin-add '{}'".format(e, name), runas=user)


def install_version(name, version, user=None):
    if not is_plugin_installed(name, user):
        raise CommandExecutionError('Plugin {} is not installed.'.format(name))

    e = _which(user)

    __salt__['log.info']('asdf: Installing {} {}'.format(name, version))

    return not __salt__['cmd.retcode']("{} install '{}' '{}'".format(e, name, version), runas=user)


def remove_plugin(name, user=None):
    if not is_plugin_installed(name, user):
        raise CommandExecutionError('Plugin {} is not installed.'.format(name))

    e = _which(user)

    __salt__['log.info']('asdf: Removing plugin {}'.format(name))

    return not __salt__['cmd.retcode']("{} plugin-remove '{}'".format(e, name), runas=user)


def remove_version(name, version, user=None):
    if not is_plugin_installed(name, user):
        raise CommandExecutionError('Plugin {} is not installed.'.format(name))

    if not is_version_installed(name, user):
        raise CommandExecutionError('{} version {} is not installed.'.format(name, version))

    e = _which(user)

    __salt__['log.info']('asdf: Removing {} {}'.format(name, version))

    return not __salt__['cmd.retcode']("{} uninstall '{}' '{}'".format(e, name, version), runas=user)


def update_plugin(name, user=None):
    if not is_plugin_installed(name, user):
        raise CommandExecutionError('Plugin {} is not installed.'.format(name))

    e = _which(user)

    __salt__['log.info']('asdf: Updating plugin {}'.format(name))

    return not __salt__['cmd.retcode']("{} plugin-update '{}'".format(e, name), runas=user)


def update_plugins(name=None, user=None):
    e = _which(user)

    __salt__['log.info']('asdf: Updating plugins.')
    return not __salt__['cmd.retcode']("{} plugin-update --all".format(e), runas=user)


def set_version(name, version, user=None, cwd=''):
    if not is_version_installed(name, version, user):
        raise CommandExecutionError('{} version {} is not installed.'.format(name, version))

    if 'latest' == version:
        version = get_latest(name, user)

    e = _which(user)

    if cwd:
        __salt__['log.info']('asdf: Setting {} {} for {}'.format(name, version, cwd))
        return not __salt__['cmd.retcode']("{} local '{}' '{}'".format(e, name, version), cwd=cwd, runas=user)

    __salt__['log.info']('asdf: Setting {} {} globally'.format(name, version))
    return not __salt__['cmd.retcode']("{} global '{}' '{}'".format(e, name, version), runas=user)


def reshim(user=None):
    e = _which(user)
    __salt__['log.info']('asdf: Starting reshim.')
    return not __salt__['cmd.retcode']('{} reshim'.format(e), runas=user)


def _list_installed(user=None):
    e = _which(user)
    installed = __salt__['cmd.run_stdout']('{} list'.format(e), runas=user, raise_err=True)

    parsed = {}
    cur = ''
    for s in installed.splitlines():
        if '  ' != s[:2]:
            cur = s
            continue
        parsed[cur] = s[2:]
    return parsed


def list_available_plugins(user=None):
    e = _which(user)
    available = __salt__['cmd.run_stdout']('{} plugin-list-all'.format(e), runas=user, raise_err=True)
    return [x.split(' ')[0] for x in available.splitlines() if 'updating ' not in x]


def list_installed_plugins(user=None):
    e = _which(user)
    installed = __salt__['cmd.run_stdout']('{} plugin-list'.format(e), runas=user, raise_err=True)
    __salt__['log.debug']('asdf: List of installed plugins: {}'.format(installed))
    return installed.splitlines()


def list_available_versions(name, user=None):
    e = _which(user)
    available = __salt__['cmd.run_stdout']('{} list-all \'{}\''.format(e, name), runas=user, raise_err=True).splitlines()

    __salt__['log.debug']('asdf: Available versions for {}: {}'.format(name, available))
    return available


def list_installed_versions(name, user=None):
    e = _which(user)
    installed = __salt__['cmd.run_stdout']('{} list \'{}\''.format(e, name), runas=user, raise_err=True)
    if 'No versions installed' in installed:
        return []
    return installed.splitlines()


def get_current(name, cwd='', user=None):
    if not cwd:
        cwd = '/'
    e = _which(user)
    current = __salt__['cmd.run_stdout']('{} current \'{}\''.format(e, name), runas=user, cwd=cwd, raise_err=True)
    return re.split('[\s]+', current)[1]
