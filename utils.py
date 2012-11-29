import os
from collections import deque


def make_segment(content, escape=True, **kwargs):
    '''
    Make a dzen2 segment.
    '''
    if escape:
        content = content.replace('^', '^^')
    parts = deque([content])

    for tag, arg in kwargs.items():
        if not isinstance(arg, basestring):
            try:
                arg = ','.join(map(str, arg))
            except TypeError:
                arg = str(arg)
        if arg:
            parts.appendleft('^{0}({1})'.format(tag, arg))
            parts.append('^{0}()'.format(tag))
    return ''.join(parts)


def import_config_from_env(**kwargs):
    '''
    Import configuration variables from system environment.
    '''
    config = {}
    for key, default in kwargs.iteritems():
        if key in os.environ:
            value_type = type(default)
            try:
                config[key] = value_type(os.environ[key])
            except ValueError:
                config[key] = default
        else:
            config[key] = default
    return config
