#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import os.path as path

XUSE = "/home/ismail/.termcolors/xuse"

ZATHURA_TEMPLATE = "/home/ismail/.config/zathura/zathura_colors.template"

VIMB_TEMPLATE = "/home/ismail/.config/vimb/vimb_colors.template"


def template(this_template):

    with open(this_template) as _template:
        fmt = _template.read()

    return fmt


def xuse_data(this_xuse=XUSE):
    with open(this_xuse) as _xuse:
        for line in _xuse.readlines():
            if line.startswith("#define"):
                _, n, v = line.strip().split()
                yield (n, v)

if __name__ == "__main__":
    
    ztemplate = template(ZATHURA_TEMPLATE)

    ztarget = path.join(path.dirname(ZATHURA_TEMPLATE),
                        "zathurarc")

    vtemplate = template(VIMB_TEMPLATE)

    vtarget = path.join(path.dirname(VIMB_TEMPLATE),
                        "vimb_colors")

    with open(ztarget, "w") as _zt, \
            open(vtarget, "w") as _vt:

        xuse = dict(xuse_data())

        _zt.write(ztemplate.format(**xuse))

        _vt.write(vtemplate.format(**xuse))


