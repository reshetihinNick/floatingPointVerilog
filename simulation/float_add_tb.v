`timescale 1 ps/ 1 ps 																	// Задание единицы времени / погрешности

module test_float_add;
	
	parameter N = 10; 																	// Параметр N - количество тестовых пар чисел
	
	reg clk;
	reg reset;
	reg [31:0] a;
   reg [31:0] b;
   wire [31:0] result;
	wire nan;
	wire overflow;
	wire underflow;
	wire zero;
	integer i;
	
	float_add test_add (																	//Инстанцирование реализованного модуля
		.clk(clk),
		.reset(reset),
		.a(a),
		.b(b),
		.result(result),
		.nan(nan),
		.overflow(overflow),
		.underflow(underflow),
		.zero(zero)
	);
	
	reg [31:0] test_a_data [N:0]; 													// Массивы регистров для хранения тестовых чисел с плавающей запятой
	reg [31:0] test_b_data [N:0];
	
	function [31:0] generate_random_float(input integer seed);				// Функция генерации случайного числа с плавающей запятой
		reg [7:0] exponent;																// Регистры для записи экспоненты, мантиссы и знака числа
		reg [22:0] mantissa;
		reg sign;
		begin
			exponent = $urandom(seed) % (2**8);										// Генерация случайной экспоненты, мантиссы и знака
			mantissa = $urandom(seed) % (2**23);
			sign = $urandom(seed) % 2;
			generate_random_float = {sign, exponent, mantissa};				// "Сборка" числа
		end
	endfunction
	
	always #5000 clk = ~clk;															// Задание clock с периодом 10ns
	
	initial begin
		for (i = 0; i < N; i = i + 1) begin											// Цикл for в котором записываются в регистры рандомные числа с плавающей запятой
			test_a_data[i] = generate_random_float($random);
			test_b_data[i] = generate_random_float($random);
		end
		clk = 0;																				//Задаем начальные установки
		reset = 1;
		#100000
		reset = 0;
	end
	
	initial begin																			
		for (i = 0; i < N; i = i + 1) begin	
			#80000 a = test_a_data[i];													//Запись на входы случайных чисел
			b = test_b_data[i];
      end
	end
	
endmodule