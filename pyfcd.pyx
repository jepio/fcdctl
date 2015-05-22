cdef extern from "fcd.h":
    pass

cdef extern from "hidapi.h":
    pass

cdef extern void c_print_list "print_list" ()
cdef extern void c_print_help "print_help" ()

def print_list():
    c_print_list()

def print_help():
    c_print_help()
