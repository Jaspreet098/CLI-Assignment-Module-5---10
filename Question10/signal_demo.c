#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>

volatile sig_atomic_t terminate = 0;

// Signal handlers
void handle_sigterm(int sig) {
    printf("\nParent received SIGTERM (signal %d). Performing cleanup...\n", sig);
}

void handle_sigint(int sig) {
    printf("\nParent received SIGINT (signal %d). Exiting gracefully...\n", sig);
    terminate = 1; // Flag to exit main loop
}

int main() {
    // Setup signal handlers
    struct sigaction sa_term, sa_int;

    sa_term.sa_handler = handle_sigterm;
    sigemptyset(&sa_term.sa_mask);
    sa_term.sa_flags = 0;
    sigaction(SIGTERM, &sa_term, NULL);

    sa_int.sa_handler = handle_sigint;
    sigemptyset(&sa_int.sa_mask);
    sa_int.sa_flags = 0;
    sigaction(SIGINT, &sa_int, NULL);

    pid_t child1 = fork();
    if (child1 < 0) {
        perror("fork failed");
        exit(EXIT_FAILURE);
    } else if (child1 == 0) {
        // Child 1: send SIGTERM after 5 seconds
        sleep(5);
        kill(getppid(), SIGTERM);
        printf("Child1 sent SIGTERM to parent.\n");
        exit(0);
    }

    pid_t child2 = fork();
    if (child2 < 0) {
        perror("fork failed");
        exit(EXIT_FAILURE);
    } else if (child2 == 0) {
        // Child 2: send SIGINT after 10 seconds
        sleep(10);
        kill(getppid(), SIGINT);
        printf("Child2 sent SIGINT to parent.\n");
        exit(0);
    }

    // Parent runs indefinitely
    printf("Parent PID: %d. Running indefinitely...\n", getpid());

    while (!terminate) {
        pause(); // Wait for signals
    }

    // Cleanup child processes
    int status;
    while (wait(&status) > 0)
        ; // Wait for all children

    printf("Parent exiting gracefully.\n");
    return 0;
}
