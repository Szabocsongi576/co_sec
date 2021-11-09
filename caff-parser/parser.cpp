#include <iostream>
#include <fstream>
#include <vector>
#include <cstring>
#include <Magick++.h>

int64_t convertBytesToFixedInt(const char* bytes, int size) {
    int64_t value = 0;
    for (int i = 0; i < size; i++) {
        value = value | (unsigned char)(bytes[i]) << (i * 8);
    }

    return value;
}

class Header {
public:
    int64_t headerSize;
    int64_t numberOfAnimations;

    void parse(const char* fileData, unsigned int& bytesRead) {
        // magic
        char magic[4 + 1];
        strncpy(magic, fileData + bytesRead, sizeof(magic));
        magic[4] = '\0';
        bytesRead += 4;

        if (strcmp(magic, "CAFF") != 0) {
            std::cerr << "Header data must begin with magic value 'CAFF'.";
            exit(1);
        }

        // header size
        char bytes[8];
        strncpy(bytes, fileData + bytesRead, sizeof(bytes));
        bytesRead += 8;

        headerSize = convertBytesToFixedInt(bytes, sizeof(bytes));

        // number of animations
        strncpy(bytes, fileData + bytesRead, sizeof(bytes));
        bytesRead += 8;

        numberOfAnimations = convertBytesToFixedInt(bytes, sizeof(bytes));
    }
};

class Credits {
public:
    int64_t year;
    int64_t month;
    int64_t day;
    int64_t hour;
    int64_t minute;
    std::string creator;

    void parse(const char* fileData, unsigned int& bytesRead) {
        // YY
        char twobyteslonginteger[2];
        strncpy(twobyteslonginteger, fileData + bytesRead, sizeof(twobyteslonginteger));
        bytesRead += 2;

        year = convertBytesToFixedInt(twobyteslonginteger, sizeof(twobyteslonginteger));

        // M
        char byte[1];
        strncpy(byte, fileData + bytesRead, sizeof(byte));
        bytesRead += 1;

        month = convertBytesToFixedInt(byte, sizeof(byte));

        // D
        strncpy(byte, fileData + bytesRead, sizeof(byte));
        bytesRead += 1;

        day = convertBytesToFixedInt(byte, sizeof(byte));

        // h
        strncpy(byte, fileData + bytesRead, sizeof(byte));
        bytesRead += 1;

        hour = convertBytesToFixedInt(byte, sizeof(byte));

        // m
        strncpy(byte, fileData + bytesRead, sizeof(byte));
        bytesRead += 1;

        minute = convertBytesToFixedInt(byte, sizeof(byte));

        // creator length
        char creatorLength[8];
        strncpy(creatorLength, fileData + bytesRead, sizeof(creatorLength));
        bytesRead += 8;

        int64_t creatorLengthInt = convertBytesToFixedInt(creatorLength, sizeof(creatorLength));

        // creator
        char creatorTemp[creatorLengthInt];
        strncpy(creatorTemp, fileData + bytesRead, sizeof(creatorTemp));
        creatorTemp[creatorLengthInt] = '\0';
        bytesRead += creatorLengthInt;

        creator.assign(creatorTemp);
    }
};

struct Pixel {
    int64_t r;
    int64_t g;
    int64_t b;
};

class CIFFImage {
public:
    int64_t headerSize;
    int64_t contentSize;
    int64_t width;
    int64_t height;
    std::string caption;
    std::vector<std::string> tags;
    std::vector<Pixel> pixels;

    void parse(const char* fileData, unsigned int& bytesRead) {
        // magic
        char magic[4 + 1];
        strncpy(magic, fileData + bytesRead, sizeof(magic));
        magic[4] = '\0';
        bytesRead += 4;

        if (strcmp(magic, "CIFF") != 0) {
            std::cerr << "Header data must begin with magic value 'CIFF'.";
            exit(1);
        }

        // header_size
        char bytes[8];
        strncpy(bytes, fileData + bytesRead, sizeof(bytes));
        bytesRead += 8;

        headerSize = convertBytesToFixedInt(bytes, sizeof(bytes));

        // content_size
        strncpy(bytes, fileData + bytesRead, sizeof(bytes));
        bytesRead += 8;

        contentSize = convertBytesToFixedInt(bytes, sizeof(bytes));

        // width
        strncpy(bytes, fileData + bytesRead, sizeof(bytes));
        bytesRead += 8;

        width = convertBytesToFixedInt(bytes, sizeof(bytes));

        // height
        strncpy(bytes, fileData + bytesRead, sizeof(bytes));
        bytesRead += 8;

        height = convertBytesToFixedInt(bytes, sizeof(bytes));

        if (contentSize != width * height * 3) {
            std::cerr << "Invalid content size. Its value must be width*height*3";
            exit(1);
        }

        // caption
        int rest = headerSize - 4 - 8 - 8 - 8 - 8;
        int captionLength = 0;
        for (int i = 0; i < rest; i++) {
            if (fileData[bytesRead + i] == '\n') {
                captionLength = i;
                break;
            }
        }

        if (captionLength > 0) {
            char captionTemp[captionLength];
            strncpy(captionTemp, fileData + bytesRead, sizeof(captionTemp));
            captionTemp[captionLength] = '\0';
            bytesRead += captionLength;

            caption.assign(captionTemp);

            bytesRead += 1;
        }

        // tags
        rest = headerSize - 4 - 8 - 8 - 8 - 8 - captionLength;
        int tagsNumber = 0;
        for (int i = 0; i < rest; i++) {
            if (fileData[bytesRead + i] == '\0') {
                tagsNumber++;
            }
        }

        for (int i = 0; i < tagsNumber; i++) {
            for (int j = 0; j < rest; j++) {
                if (fileData[bytesRead + j] == '\0') {
                    char tagTemp[j + 1];
                    strncpy(tagTemp, fileData + bytesRead, sizeof(tagTemp));
                    bytesRead += j + 1;

                    tags.push_back(std::string(tagTemp));
                    break;
                }
            }
        }

        // pixels
        int pixelsRead = 0;
        for (int i = 0; i < contentSize / 3; i++) {
                char byte[1];
                strncpy(byte, fileData + bytesRead, sizeof(byte));
                bytesRead += 1;
                pixelsRead += 1;

                int64_t r = convertBytesToFixedInt(byte, sizeof(byte));

                strncpy(byte, fileData + bytesRead, sizeof(byte));
                bytesRead += 1;
                pixelsRead += 1;

                int64_t g = convertBytesToFixedInt(byte, sizeof(byte));

                strncpy(byte, fileData + bytesRead, sizeof(byte));
                bytesRead += 1;
                pixelsRead += 1;

                int64_t b = convertBytesToFixedInt(byte, sizeof(byte));

                Pixel pixel;
                pixel.r = r;
                pixel.g = g;
                pixel.b = b;

                pixels.push_back(pixel);
            }

        if (pixelsRead != contentSize) {
            std::cerr << "Wrong number of pixels read.";
            exit(1);
        }
    }
};

class Animation {
public:
    int64_t duration;
    CIFFImage image;

    void parse(const char* fileData, unsigned int& bytesRead) {
        // duration
        char bytes[8];
        strncpy(bytes, fileData + bytesRead, sizeof(bytes));
        bytesRead += 8;

        duration = convertBytesToFixedInt(bytes, sizeof(bytes));

        // CIFF
        image.parse(fileData, bytesRead);
    }
};

int main(int argc, char* argv[]) {
    if (argc < 2 || argc > 2) {
        std::cerr << "Bad number of arguments!";
        exit(1);
    }

    std::string fileName = argv[1];
    int extensionPosition = fileName.find_last_of(".");
    std::string extension = fileName.substr(extensionPosition + 1);
    if (extension.compare("caff") != 0) {
        std::cerr << "Wrong file format.";
        exit(1);
    }

    std::ifstream file(fileName, std::ios::in | std::ios::binary);
    if (!file.good()) {
        std::cerr << "Failed to open file.";
        exit(1);
    }

    // get file size
    unsigned int fileSize;
    file.seekg(0, std::ios::end);
    fileSize = file.tellg();
    file.seekg(0, std::ios::beg);

    if (fileSize == 0) {
        std::cerr << "The file's size is 0.";
        exit(1);
    }

    // read file data
    std::vector<unsigned char> fileData(fileSize); 
    file.read((char*) fileData.data(), fileSize);

    unsigned int bytesRead = 0;

    // read first block's id (1 byte)
    char blockId = fileData[0];
    bytesRead += 1;
    if (blockId != 0x1) {
        std::cerr << "First block is not the header.";
        exit(1);
    }

    // read block's length (8 byte)
    char blockLength[8];
    strncpy(blockLength, (char*) fileData.data() + bytesRead, sizeof(blockLength));
    bytesRead += 8;

    int64_t blockLengthInt = convertBytesToFixedInt(blockLength, sizeof(blockLength));

    if (blockLengthInt < 0) {
        std::cerr << "Length of block can not be negative.";
        exit(1);
    }

    Header header;
    header.parse((char*) fileData.data(), bytesRead);

    // read second block's id (1 byte)
    blockId = fileData[bytesRead];
    bytesRead += 1;
    if (blockId != 0x2) {
        std::cerr << "Second block is not the credits.";
        exit(1);
    }

    // read block's length (8 byte)
    strncpy(blockLength, (char*) fileData.data() + bytesRead, sizeof(blockLength));
    bytesRead += 8;

    blockLengthInt = convertBytesToFixedInt(blockLength, sizeof(blockLength));

    if (blockLengthInt < 0) {
        std::cerr << "Length of block can not be negative.";
        exit(1);
    }

    Credits credits;
    credits.parse((char*) fileData.data(), bytesRead);

    std::vector<Animation> animations;
    for (int i = 0; i < header.numberOfAnimations; i++) {
        // read block's id
        blockId = fileData[bytesRead];
        bytesRead += 1;
        if (blockId != 0x3) {
            std::cerr << "We already parsed the header and the credits.";
            exit(1);
        }

        // read block's length
        strncpy(blockLength, (char*) fileData.data() + bytesRead, sizeof(blockLength));
        bytesRead += 8;

        blockLengthInt = convertBytesToFixedInt(blockLength, sizeof(blockLength));

        if (blockLengthInt < 0) {
            std::cerr << "Length of block can not be negative.";
            exit(1);
        }

        Animation animation;
        animation.parse((char*) fileData.data(), bytesRead);

        animations.push_back(animation);
    }

    if (bytesRead != fileSize) {
        std::cerr << "Something is wrong. There are bytes left in this file.";
        exit(1);
    }

    std::cout << "Parse successful." << std::endl;

    Magick::InitializeMagick(nullptr);

    std::vector<Magick::Image> images(header.numberOfAnimations);
    for (int i = 0; i < header.numberOfAnimations; i++) {
        unsigned int width = animations[i].image.width;
        unsigned int height = animations[i].image.height;
        Magick::StorageType storageType = Magick::CharPixel;
        std::vector<unsigned char> pixels;
        for (unsigned int j = 0; j < width * height; j++) {
            pixels.push_back(animations[i].image.pixels[j].r);
            pixels.push_back(animations[i].image.pixels[j].g);
            pixels.push_back(animations[i].image.pixels[j].b);
        }

        Magick::Image image(width, height, "RGB", storageType, pixels.data());
        image.animationDelay(animations[i].duration / 10);

        images.push_back(image);
    }

    std::string gifFileName = fileName.substr(0, extensionPosition) + ".gif";
    writeImages(images.begin(), images.end(), gifFileName);

    std::cout << "Gif's name: " << gifFileName << std::endl;

    return 0;
}