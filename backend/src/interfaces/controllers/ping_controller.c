#include "ping_controller.h"
#include <stdio.h> // For printf in a real scenario if logging

const char* handle_ping_request(void /* HttpRequest* req, HttpResponse* res */) {
    // In a real web server context, you would construct a proper HTTP response here.
    // For example, setting status code to 200 OK, content type to text/plain,
    // and then writing "pong" to the response body.

    // For this phase 0, we'll just return the string "pong".
    // The server.c (or equivalent) will need to know how to interpret this.
    printf("LOG: Handling /ping request.\n");
    return "pong";
}