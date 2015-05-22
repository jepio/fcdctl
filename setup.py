from distutils.core import setup, Extension
from Cython.Build import cythonize
from subprocess import check_output


def _call_pkgconfig(flag, prefix):
    cflags = check_output(
        ['pkg-config', flag, 'libusb-1.0']).decode('utf-8')
    assert cflags[:2] == prefix
    return cflags[2:].strip()


def find_libusb_include():
    return _call_pkgconfig(flag='--cflags', prefix='-I')


def find_libusb_libs():
    return _call_pkgconfig(flag='--libs', prefix='-l')

extension = Extension('pyfcd',
                      ['pyfcd.pyx', 'main.c', 'fcd.c', 'hid-libusb.c'],
                      include_dirs=[find_libusb_include()],
                      libraries=[find_libusb_libs()])

setup(
    name='pyfcd',
    ext_modules=cythonize([extension])
)
