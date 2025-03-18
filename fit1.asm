section .data
    prompt_menu db '1. Add Member', 10, '2. View Members', 10, '3. Exit', 10, 'Select an option: ', 0
    prompt_name db 'Enter name: ', 0
    prompt_age db 'Enter age: ', 0
    prompt_type db 'Enter membership type (1 for monthly, 2 for yearly): ', 0
    msg_member_added db 'Member added successfully!', 10, 0
    msg_view_members db 'Viewing members:', 10, 0
    msg_exit db 'Exiting program...', 10, 0
    member_db db 100, 0  ; To store member count (max 100 members)
    name_db db 100*20     ; To store member names (max 100 members with 20 char max)
    age_db db 100*1       ; To store ages of members
    type_db db 100*1      ; To store membership types (1 for monthly, 2 for yearly)

section .bss
    menu_option resb 1
    name resb 50         ; Reserve space for the name
    age resb 1           ; Reserve space for age input
    member_count resb 1  ; To keep track of number of members

section .text
    global _start

_start:
    ; Initialize member count to 0
    mov byte [member_count], 0

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
    mov ecx, type_db
    mov edx, 1
    int 0x80

    ; Add member information to "database"
    ; Store member name
    mov eax, [member_count]
    mov ebx, eax           ; Load member count into ebx
    mov ecx, name          ; Load the address of name
    mov edx, 50            ; Set max name length to 50
    call store_member_name

    ; Store member age
    mov eax, [member_count]
    mov ecx, age
    call store_member_age

    ; Store membership type
    mov eax, [member_count]
    mov ecx, type_db
    call store_member_type

    ; Increment member count
    inc byte [member_count]

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

    ; Display member details
    ; Print all member details here (names, ages, types)
    ; For simplicity, this part is just a placeholder

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

store_member_name:
    ; Store name in name_db at index ebx (member count)
    ; This is a placeholder for actual storing logic
    ret

store_member_age:
    ; Store age in age_db at index ebx (member count)
    ; This is a placeholder for actual storing logic
    ret

store_member_type:
    ; Store membership type in type_db at index ebx (member count)
    ; This is a placeholder for actual storing logic
    ret
