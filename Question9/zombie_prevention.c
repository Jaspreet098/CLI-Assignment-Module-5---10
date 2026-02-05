#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

#define NUM_CHILDREN 5

int main() {
    pid_t pid;
    int i;

    printf("Parent PID: %d\n", getpid());

    for (i = 0; i < NUM_CHILDREN; i++) {
        pid = fork();

        if (pid < 0) {
            perror("fork failed");
            exit(EXIT_FAILURE);
        } else if (pid == 0) {
            // Child process
            printf("Child PID %d started (i=%d)\n", getpid(), i);
            sleep(2 + i); // Simulate some work
            printf("Child PID %d exiting\n", getpid());
            exit(0);      // Child terminates
        } 
        // Parent continues loop
    }

    // Parent waits for all children
    int status;
    pid_t child_pid;
    while ((child_pid = wait(&status)) > 0) {
        if (WIFEXITED(status)) {
            printf("Parent cleaned up child PID: %d, exit status: %d\n",
                   child_pid, WEXITSTATUS(status));
        } else if (WIFSIGNALED(status)) {
            printf("Child PID %d terminated by signal %d\n",
                   child_pid, WTERMSIG(status));
        }
    }

    printf("All children have been cleaned up. Parent exiting.\n");
    return 0;
}
