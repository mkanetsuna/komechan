#include "server.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// --- IMPORTANT ---
// This is a SKELETON implementation.
// You NEED to integrate a real HTTP server library (e.g., libmicrohttpd, CivetWeb, Mongoose)
// or implement socket-level programming here.
// The current code does NOT create a functional web server.

// Placeholder for server instance or context
static void* server_instance = NULL;
static unsigned short server_port = 0;

// Placeholder for registered routes (simplified)
#define MAX_ROUTES 10
typedef struct {
    char method[10];
    char path[100];
    request_handler_t handler;
} Route;
static Route routes[MAX_ROUTES];
static int route_count = 0;

ErrorCode server_init(unsigned short port) {
    server_port = port;
    printf("LOG: Server attempting to initialize on port %u...\n", port);

    // TODO: Initialize your chosen HTTP server library here.
    // Example with a hypothetical library:
    // server_instance = my_http_lib_create(port);
    // if (!server_instance) {
    //     fprintf(stderr, "ERROR: Failed to initialize HTTP server library.\n");
    //     return ERROR_GENERAL;
    // }

    printf("LOG: HTTP server library would be initialized here.\n");
    route_count = 0; // Reset routes
    return SUCCESS;
}

ErrorCode server_register_route(const char* http_method, const char* path, request_handler_t handler) {
    if (route_count >= MAX_ROUTES) {
        fprintf(stderr, "ERROR: Max routes reached.\n");
        return ERROR_GENERAL;
    }
    if (strlen(http_method) >= sizeof(routes[route_count].method) || strlen(path) >= sizeof(routes[route_count].path)) {
        fprintf(stderr, "ERROR: Method or path string too long.\n");
        return ERROR_INVALID_ARGUMENT;
    }

    strncpy(routes[route_count].method, http_method, sizeof(routes[route_count].method) - 1);
    strncpy(routes[route_count].path, path, sizeof(routes[route_count].path) - 1);
    routes[route_count].handler = handler;
    route_count++;

    printf("LOG: Registered route: %s %s\n", http_method, path);

    // TODO: Register this route with your HTTP server library.
    // Example with a hypothetical library:
    // my_http_lib_add_route(server_instance, http_method, path, internal_generic_handler_wrapper);
    // The internal_generic_handler_wrapper would then find the correct user-provided handler.
    return SUCCESS;
}

// This is a conceptual dispatcher. A real HTTP library would handle dispatching.
static void dispatch_request(const char* method, const char* path) {
    printf("LOG: Dispatching request for %s %s\n", method, path);
    for (int i = 0; i < route_count; ++i) {
        if (strcmp(routes[i].method, method) == 0 && strcmp(routes[i].path, path) == 0) {
            if (routes[i].handler) {
                const char* response_body = routes[i].handler(); // Simplified call
                // In a real server, you'd construct a full HTTP response here.
                // This might involve a more complex handler signature that gets request/response objects.
                printf("LOG: Handler for %s returned: %s\n", path, response_body ? response_body : "(null)");
                printf("SIMULATED HTTP RESPONSE:\nHTTP/1.1 200 OK\nContent-Type: text/plain\nContent-Length: %zu\n\n%s\n",
                       response_body ? strlen(response_body) : 0,
                       response_body ? response_body : "");
                return;
            }
        }
    }
    printf("LOG: No handler found for %s %s\n", method, path);
    printf("SIMULATED HTTP RESPONSE:\nHTTP/1.1 404 Not Found\nContent-Type: text/plain\nContent-Length: 9\n\nNot Found\n");
}


ErrorCode server_start(void) {
    if (server_port == 0) {
        fprintf(stderr, "ERROR: Server not initialized or port not set.\n");
        return ERROR_GENERAL;
    }
    printf("LOG: Server attempting to start on port %u...\n", server_port);
    printf("LOG: Waiting for requests (simulated)...\n");

    // TODO: Start your chosen HTTP server library's listening loop here.
    // This function would typically block.
    // Example with a hypothetical library:
    // my_http_lib_start_blocking(server_instance);

    // --- SIMULATION for Phase 0 without a real HTTP library ---
    // This part simulates receiving a few requests to demonstrate the flow.
    // In a real server, this would be an event loop or blocking call from the HTTP library.
    printf("--- Server started (simulation mode) ---\n");
    printf("To test, you would normally use: curl http://localhost:%u/ping\n", server_port);
    printf("Simulating a GET /ping request internally:\n");
    dispatch_request("GET", "/ping"); // Simulate a ping request
    printf("Simulating a GET /nonexistent request internally:\n");
    dispatch_request("GET", "/nonexistent"); // Simulate a 404
    printf("--- Server simulation finished. In a real server, press Ctrl+C to stop. ---\n");
    // --- END SIMULATION ---

    // If the library's start function is non-blocking, ensure this function
    // doesn't exit immediately, or manage it in a separate thread.
    // For most embedded/simple C servers, the start function is blocking.

    return SUCCESS; // Or error from the library
}

void server_shutdown(void) {
    printf("LOG: Shutting down server...\n");

    // TODO: Gracefully stop your chosen HTTP server library and clean up resources.
    // Example with a hypothetical library:
    // if (server_instance) {
    //     my_http_lib_stop(server_instance);
    //     my_http_lib_destroy(server_instance);
    //     server_instance = NULL;
    // }
    printf("LOG: HTTP server library would be shut down here.\n");
}