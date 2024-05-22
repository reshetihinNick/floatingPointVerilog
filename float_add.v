`include "fp_adder.v" 									//Подключение библиотечного модуля (Используется модуль ALTFP_ADD_SUB из библиотеки Quartus Prime 18.1)

module float_add(
	input clk, 												// clock
   input reset,											// reset
   input [31:0] a,										// Первое слагаемое
   input [31:0] b,										// Второе слагаемое
   output [31:0] result,								// Сумма
	output nan,												// Флаг "не число"
	output overflow,										// Флаг переполнения
	output underflow,										// Флаг понижения порядка (потеря значимости)
	output zero												// Флаг "ноль"
);

	wire [31:0] add_result;
	wire result_nan;
	wire result_overflow;
	wire result_underflow;
	wire result_zero;
	
	fp_adder add_float (									//Инстанцирование библиотечного модуля (внизу: задание входных подключений)
	.aclr ( reset ),
	.clock ( clk ),
	.dataa ( a ),
	.datab ( b ),
	.nan ( result_nan ),
	.overflow ( result_overflow),
	.result ( add_result ),
	.underflow ( result_underflow ),
	.zero ( result_zero )
	);
	
	assign nan = result_nan;							//Присваивание выходам соответствующих им значений
	assign overflow = result_overflow;
	assign underflow = result_underflow;
	assign zero = result_zero;
	assign result = add_result;
	
endmodule