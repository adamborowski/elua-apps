### eLua script Launcher
Java GUI tool to send and execute elua programs via xmodem over COM connection.
The program contains file browser, Send&Execute button, a field to write into COM and text area with COM output.

The workflow:

1. At start it connects to tty serial port
1. click The Button
1. program sends CTRL+X special chars to kill any executed lua script
2. program compiles selected file into lua bytecode
1. program writes "recv" command to begin transaction
1. program sends selected bytecode through XMODEM, after that the script is starting.
