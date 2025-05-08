#include <stdio.h>
#include "infrastructure/web/server.h"
#include "interfaces/controllers/ping_controller.h"
#include "utils/error_handler.h"

#define DEFAULT_PORT 8080

int main(void) {
    printf("Application starting...\n");

    unsigned short port = DEFAULT_PORT; // Port can be read from env or args later

    // Initialize the server
    if (server_init(port) != SUCCESS) {
        fprintf(stderr, "Failed to initialize server.\n");
        return 1;
    }

    // Register routes (Dependency Injection: passing controller function to server)
    // The server_register_route function will store this handler.
    // When a request for "GET /ping" comes, the server's dispatch logic
    // (which you'd implement or is part of the HTTP library) will call handle_ping_request.
    if (server_register_route("GET", "/ping", handle_ping_request) != SUCCESS) {
        fprintf(stderr, "Failed to register /ping route.\n");
        server_shutdown();
        return 1;
    }

    // Add more routes here for future features
    // Example: server_register_route("POST", "/users", handle_create_user_request);

    // Start the server (this will block in a real server)
    ErrorCode server_status = server_start();

    if (server_status != SUCCESS) {
        fprintf(stderr, "Server exited with error code %d.\n", server_status);
    }

    // Shutdown the server (might be called from a signal handler in a real app)
    server_shutdown();

    printf("Application finished.\n");
    return server_status == SUCCESS ? 0 : 1;
}