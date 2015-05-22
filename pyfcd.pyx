'''Cython wrapper around the fcdctl command-line utility functionality.'''

cdef extern from "fcd.h":
    pass

cdef extern from "hidapi.h":
    pass

cdef extern void c_print_list "print_list" ()
cdef extern void c_print_help "print_help" ()

def print_list():
    '''Print list of all Funcube Dongles.'''
    c_print_list()


def print_help():
    '''Print the help string for the fcdctl app.'''
    c_print_help()
