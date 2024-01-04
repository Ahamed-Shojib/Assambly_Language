.stack 100h

.data

posX      db 1 dup(0)        
posY      db 1 dup(0)        
matrix    db 40*25 dup(' ') 
curr_line dw ?
curr_char dw ?
color     db 169

filename db "C:/file.txt",0
handler dw ?
length dw dup(0)

start_menu_str dw '  ',0ah,0dh

dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw '                ====================================================',0ah,0dh
dw '               ||                                                  ||',0ah,0dh                                        
dw '               ||       *     Text Editor in Assembly   *          ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||--------------------------------------------------||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||                 Developed By                     ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh          
dw '               ||                 Mehedi Hasan                     ||',0ah,0dh
dw '               ||                  212902069                       ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||              Press Enter to start                ||',0ah,0dh 
dw '               ||                                                  ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '                ====================================================',0ah,0dh
dw '$',0ah,0dh

.code

    mov  ax,@data
    mov  ds,ax
  
    call main_menu        
    
start_prog:
    call clear_screen
    jmp program
    
program: 

    mov  curr_line, offset matrix
    mov  curr_char, 0

start:
call read_char

any_char:
    mov  ah, 9
    mov  bh, 0
    mov  bl, color                            
    mov  cx, 1          
    int  10h             

    mov  si, curr_line   
    add  si, curr_char   
    mov  [ si ], al     
    inc  length      

moveRight:
    inc  curr_char       
    mov  dl, posX
    mov  dh, posY
    inc  dl             
    mov  posX, dl
    jmp  prntCrs

moveLeft:
    dec  curr_char      
    mov  dl, posX
    mov  dh, posY
    dec  dl      
    mov  posX, dl
    jmp  prntCrs

moveUp: 
    sub  curr_line, 80  
    mov  dl, posX
    mov  dh, posY
    dec  dh           
    mov  posY, dh
    jmp  prntCrs    

moveDown:   
    add  curr_line, 80 
    mov  dl, posX
    mov  dh, posY
    inc  dh         
    mov  posY, dh
    jmp  prntCrs 

moveNewLine:        
    mov si, curr_line
    add si, 79
    mov [si], 0dh
    add curr_line, 80
    mov curr_char, 0
    mov posX, 0
    mov dl, posX
    mov dh, posY
    inc dh
    mov posY, dh
    add length, 80
    jmp prntCrs

moveToBeginning:
    mov curr_char, 0
    mov posX, 0
    mov dl, posX
    jmp prntCrs
    
backSpace:
    cmp curr_char, 0
    je  preventBackSpace
    dec curr_char
    mov si, curr_line   
    add si, curr_char   
    mov [ si ], ' '    
    dec length       
    dec posX
    mov dl, posX
    mov  ah, 2h
    int  10h
        
    mov  al,' '
    mov  ah, 9
    mov  bh, 0
    mov  bl, 0000
    mov  cx, 1          
    int  10h         
    jmp prntCrs
prntCrs:            
    mov  ah, 2h
    int  10h
    jmp  start         

fin:
    int  20h
    
saveToFile:

  mov  ah, 3ch
  mov  cx, 0
  mov  dx, offset filename
  int  21h  


  mov  handler, ax


  mov  ah, 40h
  mov  bx, handler
  mov  cx, length  
  mov  dx, offset matrix
  int  21h
  mov  ah, 3eh
  mov  bx, handler
  int  21h
  jmp fin
  
preventBackSpace:
    call read_char

clear_screen proc near
        mov ah,0             
        mov al,3            
        int 10h        
        ret
clear_screen endp

main_menu proc
    mov ah,09h
    mov dh,0
    mov dx, offset start_menu_str
    int 21h
    
    input:      
        mov  ah, 0
        int  16h
        cmp  al, 27          
        je   fin
        cmp  ax, 1C0Dh     
        je   start_prog
        jmp input
    
main_menu endp

read_char proc
    mov  ah, 0
    int  16h  
       
    cmp  al, 27          ; ESC
    je   fin
    cmp  ax, 4800h       ; UP.
    je   moveUp
    cmp  ax, 4B00h       ; LEFT.
    je   moveLeft
    cmp  ax, 4D00H       ; RIGHT.
    je   moveRight
    cmp  ax, 5000h       ; DOWN.
    je   moveDown
    cmp  ax, 1C0Dh       ; ENTER.
    je   moveNewLine
    cmp  ax, 4700h       ; HOME.
    je   moveToBeginning
    cmp  ax, 3F00h       ; F5.
    je   saveToFile
    cmp  ax, 0E08h       ; BackSpace.
    je   backSpace
    cmp  al, 32
    jae  any_char
    jmp  start
read_char endp

get_file_location_from_user proc
    ret
get_file_location_from_user endp