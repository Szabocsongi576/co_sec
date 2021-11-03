#include <iostream>
#include <fstream>

int64_t convertBytesToFixedInt(const char* bytes) {
    uint64_t value = static_cast<uint64_t>(bytes[0]) |
                    static_cast<uint64_t>(bytes[1]) << 8 |
                    static_cast<uint64_t>(bytes[2]) << 16 |
                    static_cast<uint64_t>(bytes[3]) << 24 |
                    static_cast<uint64_t>(bytes[4]) << 32 |
                    static_cast<uint64_t>(bytes[5]) << 40 |
                    static_cast<uint64_t>(bytes[6]) << 48 |
                    static_cast<uint64_t>(bytes[7]) << 56;

    return value;
}

class Header {
public:
    int64_t numberOfAnimations;

    void parse(char* fileData, unsigned int& bytesRead) {
        char eightbyteslonginteger[8];

        // magic (4 byte)
        char magic[4 + 1];
        strncpy(magic, fileData + bytesRead, sizeof(magic));
        magic[4] = '\0';
        bytesRead += 4;

        if (strcmp(magic, "CAFF") != 0) {
            std::cerr << "Header data must begin with magic value 'CAFF'.";
            exit(1);
        }

        // header size (8 byte)
        strncpy(eightbyteslonginteger, fileData + bytesRead, sizeof(eightbyteslonginteger));
        bytesRead += 8;

        int64_t headerSizeInt = convertBytesToFixedInt(eightbyteslonginteger);

        // number of animations (8 byte)
        strncpy(eightbyteslonginteger, fileData + bytesRead, sizeof(eightbyteslonginteger));
        bytesRead += 8;

        numberOfAnimations = convertBytesToFixedInt(eightbyteslonginteger);
    }
};

class Credits {
public:
    int year;
    int month;
    int day;
    int hour;
    int minute;
    char* creator;

    void parse(char* fileData, unsigned int& bytesRead) {
        // YY
        char twobyteslonginteger[2];
        strncpy(twobyteslonginteger, fileData + bytesRead, sizeof(twobyteslonginteger));
        bytesRead += 2;

        year = (unsigned char)(twobyteslonginteger[0]) | (unsigned char)(twobyteslonginteger[1]) << 8;

        // M
        char onebytelonginteger[1];
        strncpy(onebytelonginteger, fileData + bytesRead, sizeof(onebytelonginteger));
        bytesRead += 1;

        month = onebytelonginteger[0];

        // D
        strncpy(onebytelonginteger, fileData + bytesRead, sizeof(onebytelonginteger));
        bytesRead += 1;

        day = onebytelonginteger[0];

        // h
        strncpy(onebytelonginteger, fileData + bytesRead, sizeof(onebytelonginteger));
        bytesRead += 1;

        hour = onebytelonginteger[0];

        // m
        strncpy(onebytelonginteger, fileData + bytesRead, sizeof(onebytelonginteger));
        bytesRead += 1;

        minute = onebytelonginteger[0];

        // creator length
        char creatorLength[8];
        strncpy(creatorLength, fileData + bytesRead, sizeof(creatorLength));
        bytesRead += 8;

        int64_t creatorLengthInt = convertBytesToFixedInt(creatorLength);

        // creator
        strncpy(creator, fileData + bytesRead, creatorLengthInt);
        creator[creatorLengthInt] = '\0';
        bytesRead += creatorLengthInt;
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

    int fileSize;

    std::ifstream file(fileName, std::ios::in | std::ios::binary);
    if (!file.good()) {
        std::cerr << "Failed to open file.";
        exit(1);
    }

    // get file size
    file.seekg(0, std::ios::end);
    fileSize = file.tellg();
    file.seekg(0, std::ios::beg);

    if (fileSize == 0) {
        std::cerr << "The file's size is 0.";
        exit(1);
    }

    // read file data
    char fileData[fileSize];
    file.read(fileData, fileSize);

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
    strncpy(blockLength, fileData + bytesRead, sizeof(blockLength));
    bytesRead += 8;

    int64_t blockLengthInt = convertBytesToFixedInt(blockLength);

    Header header;
    header.parse(fileData, bytesRead);

    // read first block's id (1 byte)
    blockId = fileData[bytesRead];
    bytesRead += 1;
    if (blockId != 0x2) {
        std::cerr << "Second block is not the credits.";
        exit(1);
    }

    // read block's length (8 byte)
    strncpy(blockLength, fileData + bytesRead, sizeof(blockLength));
    bytesRead += 8;

    blockLengthInt = convertBytesToFixedInt(blockLength);

    Credits credits;
    credits.parse(fileData, bytesRead);

    return 0;
}