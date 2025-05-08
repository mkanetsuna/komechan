#ifndef PING_CONTROLLER_H
#define PING_CONTROLLER_H

// Forward declaration for an HTTP request/response structure if you use one.
// For simplicity, we'll pass minimal info or assume a global/contextual way
// to send responses, which would be encapsulated by the server implementation.
// typedef struct HttpRequest HttpRequest;
// typedef struct HttpResponse HttpResponse;

/**
 * @brief Handles the /ping request.
 *
 * @param req The HTTP request object (placeholder).
 * @param res The HTTP response object to be filled (placeholder).
 * @return char* A string "pong" to be sent as response body.
 * The caller (server logic) is responsible for forming the HTTP response.
 * In a real scenario, this function would likely write to a response stream
 * or fill a response struct.
 * Returns NULL on error or if the response is handled internally.
 * For this simple ping, we return the string directly.
 */
const char* handle_ping_request(void /* HttpRequest* req, HttpResponse* res */);

#endif // PING_CONTROLLER_H