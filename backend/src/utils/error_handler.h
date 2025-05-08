#ifndef ERROR_HANDLER_H
#define ERROR_HANDLER_H

typedef enum {
    SUCCESS = 0,
    ERROR_GENERAL = 1,
    ERROR_NETWORK = 2,
    ERROR_INVALID_ARGUMENT = 3,
    // Add more specific error codes as needed
} ErrorCode;

// You might want to add a function to get error messages
// const char* error_message(ErrorCode code);

#endif // ERROR_HANDLER_H