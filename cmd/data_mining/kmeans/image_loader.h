#ifndef IMAGE_LOADER_H
#define IMAGE_LOADER_H

unsigned char* load_image(const char* filename, int* width, int* height, int* channels);
void free_image(unsigned char* data);

#endif

