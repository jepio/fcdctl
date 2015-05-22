LIBS = `pkg-config --libs --cflags libusb-1.0` -lpthread
CC = gcc

SOURCE = fcd.c hid-libusb.c
EXEC = fcdctl
LIB_SONAME = libfcdctl.so.1
LIB_NAME = $(LIB_SONAME).0

all: $(SOURCE) main.c
	$(CC) $^ $(LIBS) -o $(EXEC) -Wall

fcdpp: main.c $(LIB_NAME)
	$(CC) -DFCDPP $^ $(LIBS) -o $(EXEC) -Wall

$(LIB_NAME): $(SOURCE)
	$(CC) -fPIC -DFCDPP $^ $(LIBS) -shared -Wl,-soname,$(LIB_SONAME) -o $@ -Wall
	ln -s $(LIB_NAME) $(LIB_SONAME)

clean:
	rm -rf *.o *~ $(EXEC) $(LIB_NAME)
	unlink $(LIB_SONAME)
