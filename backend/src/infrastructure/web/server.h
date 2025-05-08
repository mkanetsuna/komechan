#ifndef SERVER_H
#define SERVER_H

#include "../../utils/error_handler.h"

// Define a function pointer type for request handlers
// The actual signature will depend heavily on the chosen HTTP library or custom implementation.
// It typically takes some form of request and response objects.
typedef const char* (*request_handler_t)(void /* HttpRequest* req, HttpResponse* res */);

/**
 * @brief Initializes the web server.
 *
 * @param port The port number to listen on.
 * @return ErrorCode SUCCESS or an error code.
 */
ErrorCode server_init(unsigned short port);

/**
 * @brief Registers a route and its handler.
 *
 * @param http_method The HTTP method (e.g., "GET", "POST").
 * @param path The URL path (e.g., "/ping").
 * @param handler The function to handle requests to this path.
 * @return ErrorCode SUCCESS or an error code.
 */
ErrorCode server_register_route(const char* http_method, const char* path, request_handler_t handler);

/**
 * @brief Starts the web server and begins listening for requests.
 * This function will typically block.
 *
 * @return ErrorCode SUCCESS or an error code if it fails to start or exits with error.
 */
ErrorCode server_start(void);

/**
 * @brief Stops and cleans up the web server.
 */
void server_shutdown(void);

#endif // SERVER_H