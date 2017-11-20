/*
Main steps of a ping program:

	1 - Connects to the website.
		- Create a socket: http://man7.org/linux/man-pages/man2/socket.2.html
		- Bind to it: http://man7.org/linux/man-pages/man2/bind.2.html
		- Connect to it: http://man7.org/linux/man-pages/man2/connect.2.html
	
	2 - Sends packet.
		- Send a message: http://man7.org/linux/man-pages/man2/send.2.html
	
	3 - Gets sys_time (1).
	
	4 - Wait for the packet receival.
		- Listen for connections (wait for the returned data)
	
	5 - Receives packet.
		- Accept a connection: http://man7.org/linux/man-pages/man2/accept.2.html
	
	6 - Gets sys_time (2).
	
	7 - Elapsed time = sys_time(2) - sys_time(1)
	
	8 - Prints a string with the packet size, accessed URL/IP
		and the elapsed time.
	
	9. Jumps to the 1st step.


	Useful links:
		Get address:
			http://man7.org/linux/man-pages/man3/getaddrinfo.3.html
		Implementation of sys/socket.h:
			http://unix.superglobalmegacorp.com/Net2/newsrc/sys/socket.h.html
*/

