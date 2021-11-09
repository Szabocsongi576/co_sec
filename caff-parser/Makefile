CC = g++
CFLAGS = -Wall -g
MAGICK_CONFIG = `Magick++-config --cppflags --cxxflags --ldflags --libs`

parser: parser.cpp
	$(CC) $(CFLAGS) -o parser parser.cpp $(MAGICK_CONFIG)