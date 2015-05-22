'''Cython wrapper around the fcdctl command-line utility functionality.'''

cdef extern from "fcd.h":
    int whichdongle
    const unsigned int _usVID
    const unsigned int _usPID

    ctypedef enum FCD_MODE_ENUM:
        FCD_MODE_NONE
        FCD_MODE_BL
        FCD_MODE_APP

    FCD_MODE_ENUM fcdGetMode()
    FCD_MODE_ENUM fcdGetFwVerStr(char *str)

cdef extern from "hidapi.h":
    struct hid_device_info:
        hid_device_info *next

    hid_device_info *hid_enumerate(unsigned short vendor_id,
                                   unsigned short product_id)

cdef extern void c_print_list "print_list" ()
cdef extern void c_print_help "print_help" ()

from threading import RLock
from functools import wraps

dongle_lock = RLock()


def _dongle_call(method):
    '''Wrapper to call fcdctl api functions while holding the dongle_lock.'''
    @wraps(method)
    def wrapper(self, *args, **kwargs):
        global whichdongle
        with dongle_lock:
            whichdongle = self.donglenum
            return method(self, *args, **kwargs)
    return wrapper


class Dongle:
    '''
    A Funcube Dongle wrapper class.

    Attributes:
        donglenum (int) - the dongle number as returned by hidapi.
    '''
    def __init__(self, number):
        self.donglenum = number


def find_all_dongles():
    '''
    Return a list of Dongle objects corresponding to all Funcube Dongles
    present in the system.
    '''
    cdef hid_device_info * devices = hid_enumerate(_usVID, _usPID)
    cdef int idx = 0
    if devices == NULL:
        raise RuntimeError("No FCD found")
    global whichdongle
    dongles = []
    with dongle_lock:
        while devices != NULL:
            whichdongle = idx
            status = fcdGetMode()
            dongle = Dongle(idx)
            dongle.status = status
            dongles.append(dongle)
            idx += 1
            devices = devices.next
    return dongles


def print_list():
    '''Print list of all Funcube Dongles.'''
    c_print_list()


def print_help():
    '''Print the help string for the fcdctl app.'''
    c_print_help()
