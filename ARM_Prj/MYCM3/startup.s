 AREA RESET,CODE
 EXPORT __Vectors
 EXPORT Reset_Handler
__Vectors
 DCD __initial_sp
 DCD Reset_Handler
 
Reset_Handler PROC 
 NOP
 NOP
DATA1
 DCD 10,-1,3,7,16,5,15,2,6,3
	 
	 
;模块1：将DATA1的数据存储到可以编写的地址。
 LDR R0,DATA1  ;把DATA1的地址写给R0
 ADD R0,R0,#2   ;跳过数组DATA1地址前端的0X00BF，以便可以直接读取数据
 
 MOV R1, #0xA  ; 把DATA1的长度写给R1，用于和R2比较，设置是否跳出循环
 MOV R2, #0X0   ; 设置用于循环的指针，用于和R1比较，判断是否跳出循环
 
 LDR R4,=0X20000100 ;可以编写的地址
PushLoop
    LDR R3, [R0, R2, LSL #2] ; 将DATA1[R2]的值写进R3
	STR R3,[R4]  ; 将R3写入我们希望能够编写的地址
	ADD R4,R4,#4 ; 使地址自增，以便于下一个R3存储
    ADD R2, R2, #1 ; 增加指针的值
    CMP R2, R1 ; 将指针与数组长度比较
    BLT PushLoop ; 如果R2 < R1，跳转到PushLoop
 
 
;模块2：对DATA1按数据从小到大排序
 LDR R0,=0X20000100 ;可以编写的地址
 MOV R1, #0XA  ; 把DATA1的长度写给R1，用于和R2比较，设置是否跳出循环
 MOV R2, #0X0   ; 设置用于冒泡排序外层循环的指针，用于和R1比较，判断是否跳出外层循环
 MOV R6, #0X9	;R6用于判断是否跳出内层循环，冒泡排序内层循环n-1次

OuterLoop
    MOV R3, #0X0  ;  设置用于冒泡排序内层循环的指针，用于和R1比较，判断是否跳出内层循环

InnerLoop
    LDR R4, [R0, R3, LSL #2] ; 将DATA1[R3]的值写进R4
	ADD R0,R0,#4             ;使R0自增，以便R5能取到[R3+1]的值
    LDR R5, [R0, R3, LSL #2] ; 将DATA1[R3+1]的值写进R5
	SUB R0,R0,#4		     ;复原R0
	
    CMP R4, R5 ; 将这两个数值进行比较
    BLE NoSwap ; 如果R4 <= R5, 不需要交换数值

    ; 交换数值
    STR R5, [R0, R3, LSL #2] ;DATA1[R3]的值写进R5
	ADD R0,R0,#4			 ;使R0自增，以便R4能取到[R3+1]的值
    STR R4, [R0, R3, LSL #2] ;将DATA1[R3+1]的值写进R4
	SUB R0,R0,#4			 ;复原R0
	
NoSwap
    ADD R3, R3, #1 ; 增加内层指针的值
    CMP R3, R6 ; 将指针与数组长度比较
    BLT InnerLoop ; 如果R3 < R6，跳转到InnerLoop

    ADD R2, R2, #1 ; 增加外层指针的值
    CMP R2, R1 ; 将指针与数组长度比较
    BLT OuterLoop ;如果R2 < R1，跳转到OuterLoop


;模块三：将地址为0x20000100排好序的十个数写进DATA2
 LDR R7,=DATA2		;读取DATA2的地址
 LDR R9,=0x20000128		;将0x20000100的第10+1个数的地址写进R9，便于后面判断是否跳出循环
InLoop
 LDR R8,[R0]		;从0x20000100读取数值写进R8
 STR R8,[R7]		;将R8的数值下写进DATA2的地址
 ADD R0,R0,#4		;使得R0地址自增，便于取第n+1个数
 ADD R7,R7,#4		;使得R7地址自增，便于写入DATA2的第n+1个数的位置
 CMP R0,R9			;比较R0,R9
 BLT InLoop			;如果R0<R9,则回到循环InLoop
 
 
 B .
 ENDP
 
 AREA STACK,DATA
DATA2
 DCD 0,0,0,0,0,0,0,0,0,0 
 SPACE 0x100
__initial_sp

 END

