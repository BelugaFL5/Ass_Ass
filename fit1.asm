section .data
    filename db 'members.txt', 0    ; Filename for storing members
    prompt_menu db '1. Add Member', 10, '2. View Members', 10, '3. Exit', 10, 'Select an option: ', 0
    prompt_name db 'Enter name: ', 0
    prompt_age db 'Enter age: ', 0
    prompt_type db 'Enter membership type (1 for monthly, 2 for yearly): ', 0
    msg_member_added db 'Member added successfully!', 10, 0
    msg_view_members db 'Viewing members:', 10, 0
    msg_exit db 'Exiting program...', 10, 0

section .bss
    menu_option resb 1         ; Reserve 1 byte for menu input
    name resb 50              ; Reserve 50 bytes for the member's name
    age resb 1                ; Reserve 1 byte for the age
    type resb 1               ; Reserve 1 byte for the membership type
    buffer resb 256           ; Reserve 256 bytes for the file buffer

section .text
    global _start

_start:
    ; Main loop to show menu
menu_loop:
    ; Print the menu prompt
    mov eax, 4            ; syscall for sys_write
    mov ebx, 1            ; file descriptor (stdout)
    mov ecx, prompt_menu  ; address of prompt menu
    mov edx, 30           ; length of prompt menu
    int 0x80              ; call kernel

    ; Read user input (menu option)
    mov eax, 3            ; syscall for sys_read
    mov ebx, 0            ; file descriptor (stdin)
    mov ecx, menu_option  ; address to store input
    mov edx, 1            ; number of bytes to read
    int 0x80              ; call kernel

    ; Convert input (ASCII) to number
    movzx eax, byte [menu_option]
    sub eax, '0'

    ; Check if option is 1 (Add Member)
    cmp eax, 1
    je add_member

    ; Check if option is 2 (View Members)
    cmp eax, 2
    je view_members

    ; Check if option is 3 (Exit)
    cmp eax, 3
    je exit_program

    ; If invalid input, show the menu again
    jmp menu_loop

add_member:
    ; Print prompt for name
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_name
    mov edx, 13
    int 0x80

    ; Read the name (max 50 chars)
    mov eax, 3
    mov ebx, 0
    mov ecx, name
    mov edx, 50
    int 0x80

    ; Print prompt for age
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_age
    mov edx, 12
    int 0x80

    ; Read age (1 byte)
    mov eax, 3
    mov ebx, 0
    mov ecx, age
    mov edx, 1
    int 0x80

    ; Print prompt for membership type
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_type
    mov edx, 38
    int 0x80

    ; Read membership type
    mov eax, 3
    mov ebx, 0
    mov ecx, type
    mov edx, 1
    int 0x80

    ; Open the file for appending (create if doesn't exist)
    mov eax, 5              ; syscall for sys_open
    mov ebx, filename       ; filename
    mov ecx, 0xA2           ; O_WRONLY | O_CREAT | O_APPEND
    mov edx, 0644           ; permissions (rw-r--r--)
    int 0x80                ; call kernel
    mov ebx, eax            ; Store the file descriptor in ebx

    ; Write the name to the file
    mov eax, 4              ; syscall for sys_write
    mov ecx, name           ; address of name to write
    mov edx, 50             ; max name length (50)
    int 0x80                ; call kernel

    ; Write the age to the file
    mov eax, 4              ; syscall for sys_write
    mov ecx, age            ; address of age to write
    mov edx, 1              ; write 1 byte for age
    int 0x80                ; call kernel

    ; Write the membership type to the file
    mov eax, 4              ; syscall for sys_write
    mov ecx, type           ; address of type to write
    mov edx, 1              ; write 1 byte for type
    int 0x80                ; call kernel

    ; Close the file
    mov eax, 6              ; syscall for sys_close
    int 0x80                ; call kernel

    ; Print success message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_member_added
    mov edx, 22
    int 0x80

    ; Go back to the menu
    jmp menu_loop

view_members:
    ; Print message for viewing members
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_view_members
    mov edx, 18
    int 0x80

    ; Open the file for reading
    mov eax, 5              ; syscall for sys_open
    mov ebx, filename       ; filename to open
    mov ecx, 0              ; O_RDONLY (open for reading)
    mov edx, 0              ; permissions
    int 0x80                ; call kernel
    mov ebx, eax            ; Store file descriptor in ebx

    ; Read and display members
    ; Read from the file into the buffer
    mov eax, 3              ; syscall for sys_read
    mov ecx, buffer         ; buffer to read data into
    mov edx, 256            ; buffer size
    int 0x80                ; call kernel

    ; Print the content of the buffer
    mov eax, 4              ; syscall for sys_write
    mov ebx, 1              ; file descriptor (stdout)
    mov ecx, buffer         ; buffer with file content
    mov edx, 256            ; length of data to write (buffer size)
    int 0x80                ; call kernel

    ; Close the file
    mov eax, 6              ; syscall for sys_close
    int 0x80                ; call kernel

    ; Return to menu
    jmp menu_loop

exit_program:
    ; Print exit message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_exit
    mov edx, 15
    int 0x80

    ; Exit the program
    mov eax, 1          ; syscall number for sys_exit
    xor ebx, ebx        ; exit code 0
    int 0x80            ; call kernel
