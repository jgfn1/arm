/*
Main steps of a ping program:
	0 - Reads IP from the keyboard.

	1 - Connects to the website.
		- Create a socket: http://man7.org/linux/man-pages/man2/socket.2.html
		- Bind to it: http://man7.org/linux/man-pages/man2/bind.2.html
	
	2 - Sends packet.
		- Send a message: http://man7.org/linux/man-pages/man2/send.2.html
		- http://man7.org/linux/man-pages/man7/packet.7.html
	3 - Gets sys_time (1).
	
	4 - Wait for the packet receival.
		- Listen for connections: http://man7.org/linux/man-pages/man2/listen.2.html
	
	5 - Receives packet.
		- Accept a connection: http://man7.org/linux/man-pages/man2/accept.2.html
	
	6 - Gets sys_time (2).
	
	7 - Elapsed time = sys_time(2) - sys_time(1)
	
	8 - Prints a string with the packet size, accessed URL/IP
		and the elapsed time.
	
	9. Jumps to the 1st step.

	Other useful links:
		Implementation of sys/socket.h:
			http://unix.superglobalmegacorp.com/Net2/newsrc/sys/socket.h.html
		Server snippet in x86 ASM:
			https://gist.github.com/geyslan/5174296 
		Socket client-server tutorial:
			http://www.cs.rpi.edu/~moorthy/Courses/os98/Pgms/socket.html
*/
.data
	format: .asciz "%d"
	message1: .asciz "Accessed IP: %d | Ping time: %d\n"

.text
	.global _start

_start:
	@ 0 - Reads IP from the keyboard.
	ldr r0, =format
	mov r1, sp
	bl scanf

	ldr r8, [sp] @ Stores the IP in r8

	@ 1 - Connects to the website.
	@ 	- Create a socket: http://man7.org/linux/man-pages/man2/socket.2.html
	mov r7, #102 @ 102 is the socketcall number, only needs to be assgined
	mov r0, #1 @ Selecting sys_socket

	@Arguments of sys_socket
	mov r6, #0		@ 0 - IPPROTO_IP  
	push {r6}	

	mov r6, #1		@ 1 - SOCK_STREAM
	push {r6}

	mov r6, #10		@ 10 - AF_INET6
	push {r6}

	mov r1, sp	@ Passes the args vector in r1

	svc #0			@ Creates the socket

	mov r2, r0 @ Stores the socket file descriptor(sockfd) in r2

	@ Preventing seg fault when trying to reconnet before closing socket
	@ Reference: Starting line 31 from: https://gist.github.com/geyslan/5174296
	@ r7 already contains the call's number
	mov r0, 14 @ sys_setsocketopt

	mov r6, #4		@ sizeof socklen_t
	push {r6}	 
	
	push {sp}		@ address of socklen_t - on the stack
	
	mov r6, #2		@ SO_REUSEADDR = 2
	push {r6}
	
	mov r6, #1		@ SOL_SOCKET = 1
	push {r6}
	
	push {r2}		@ sockfd

	mov r1, sp		@ ptr to argument array

	svc #0

	@ 	- Bind to it: http://man7.org/linux/man-pages/man2/bind.2.html
	@ r7 already contains the call's number
	mov r0, #2 @ sys_bind

	@ struct sockaddr_in6
	mov r6, #10		@ AF_INET6
	push {r6}

	mov r6, #443	@ port number (https)
	push {r6}

	@ Did not grasp what exactly should be pushed below.
	mov r6, #		@ IPv6 flow information
	push {r6}

	@ Could not find out how to convert the IP from r8 into a
	@ number which could be sent in 4 pushes to the stack.

	mov r6, #		@ 4th - Pushes of address are in reverse order
	push {r6}

	mov r6, #		@ 3rd
	push {r6}

	mov r6, #		@ 2nd
	push {r6}

	mov r6, #		@ 1st byte - (Address size = 16 bytes) => 4 pushes 
	push {r6}

	mov r6, #10		@ AF_INET6
	push {r6}

	mov r1, sp		@ Pointer to the struct

	@ Passing arguments
	mov r6, #28		@ Size of the struct
	push {r6}	
	
	push {r1}		@ Pointer to the struct		

	push {r2}		@ sockfd

	mov r1, sp		@ Pointer to allargs

	svc #0

	@ 2 - Sends packet.
	@ 	- Send a message: http://man7.org/linux/man-pages/man2/send.2.html
	@ 	- http://man7.org/linux/man-pages/man7/packet.7.html

	/* The best way to send a message is writing
	into the socket file.*/

	@ 3 - Gets sys_time (1).
	@_time0:
	mov r7, #13
	eor r0, r0
	svc #0

	mov r4, r0	@ Saves sys_time (1) in r4

	@4 - Wait for the packet receival.
	@  - Listen for connections: http://man7.org/linux/man-pages/man2/listen.2.html
	@ r7 already contains the call's number
	mov r1, #4 @ sys_listen

	@ Pushing args
	mov r6, #0		@ Size of the connections queue
	push {r6}

	push {r2}		@ sockfd 

	mov r1, sp	@ args from the stack into the reg 

	svc #0

	@5 - Receives packet.
	@	- Accept a connection: http://man7.org/linux/man-pages/man2/accept.2.html
	@ r7 already contains the call's number
	mov r0, #5 @ sys_accept

	mov r6, #0 		@ NULL if we don't wanna know info about the server
	push {r6}
	push {r6}
	
	push {r2} 		@ sockfd

	mov r1, sp 		@ args from the stack into the reg 

	svc #0

	mov r2, r0		@ stores the sockfd from the server on r2

	@ 6 - Gets sys_time (2).
	@_time0:
	mov r7, #13
	eor r0, r0
	svc #0

	mov r5, r0	@ Saves sys_time (2) in r5	

	@ 7 - Elapsed time = sys_time(2) - sys_time(1)
	sub r5, r4 @ Elapsed time in r5

	@ 8 - Prints a string with the accessed IP and the elapsed time.
	ldr r0, =message1 @ Format into r1

	push {r5} 	@ Pushes the elapsed time into the stack
	mov r1, sp 	@ Time's address into r1

	push {r8} 	@ IP into the stack
	mov r2, sp 	@ IP's address into r2
	bl printf

	@ 9. Jumps to the 1st step.
	b _start