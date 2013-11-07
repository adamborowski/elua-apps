Java GUI tool to send and execute elua programs via xmodem over COM connection.
The program contains file browser, Send&Execute button, a field to write into COM and text area with COM input.
At start it connects to tty serial port and when you click the button, program sends CTRL+X special chars to kill any executed lua script, writes "recv" command to begin transaction and sends selected file through XMODEM, after that the script is starting.
