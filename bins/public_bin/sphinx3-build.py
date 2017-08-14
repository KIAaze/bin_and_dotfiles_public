#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Same as /usr/bin/sphinx-build but with different interpreter
cf https://stackoverflow.com/questions/8015225/how-to-force-sphinx-to-use-python-3-x-interpreter
"""

import sys

if __name__ == '__main__':
    from sphinx import main, make_main
    if sys.argv[1:2] == ['-M']:
        sys.exit(make_main(sys.argv))
    else:
        sys.exit(main(sys.argv))
