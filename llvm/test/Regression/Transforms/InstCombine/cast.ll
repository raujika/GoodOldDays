; Tests to make sure elimination of casts is working correctly

; RUN: llvm-as < %s | opt -instcombine -die | llvm-dis | grep '%c' | not grep cast

implementation

int %test1(int %A) {
	%c1 = cast int %A to uint
	%c2 = cast uint %c1 to int
	ret int %c2
}

ulong %test2(ubyte %A) {
	%c1 = cast ubyte %A to ushort
	%c2 = cast ushort %c1 to uint
	%Ret = cast uint %c2 to ulong
	ret ulong %Ret
}

ulong %test3(ulong %A) {    ; This function should just use bitwise AND
	%c1 = cast ulong %A to ubyte
	%c2 = cast ubyte %c1 to ulong
	ret ulong %c2
}

uint %test4(int %A, int %B) {
        %COND = setlt int %A, %B
        %c = cast bool %COND to ubyte     ; Booleans are unsigned integrals
        %result = cast ubyte %c to uint   ; for the cast elim purpose
        ret uint %result
}

int %test5(bool %B) {
        %c = cast bool %B to ubyte       ; This cast should get folded into
        %result = cast ubyte %c to int   ; this cast
        ret int %result
}

int %test6(ulong %A) {
	%c1 = cast ulong %A to uint
	%res = cast uint %c1 to int
	ret int %res
}

long %test7(bool %A) {
	%c1 = cast bool %A to int
	%res = cast int %c1 to long
	ret long %res
}

long %test8(sbyte %A) {
        %c1 = cast sbyte %A to ulong
        %res = cast ulong %c1 to long
        ret long %res
}

short %test9(short %A) {
	%c1 = cast short %A to int
	%c2 = cast int %c1 to short
	ret short %c2
}

short %test10(short %A) {
	%c1 = cast short %A to uint
	%c2 = cast uint %c1 to short
	ret short %c2
}

declare void %varargs(int, ...)

void %test11(int* %P) {
	%c = cast int* %P to short*
	call void(int, ...)* %varargs(int 5, short* %c)
	ret void
}
