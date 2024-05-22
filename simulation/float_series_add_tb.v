`timescale 1 ps / 1 ps																	// Задание единицы времени / погрешности

module test_fp_series_add;
	 
	 parameter N = 8;																		// Параметр N - количество чисел
	 
    reg clk;
    reg reset;
    reg [31:0] data;
    wire [31:0] sum_out;
	 integer i;

    fp_series_add #(N) fp_series_adder (											//Инстанцирование реализованного модуля
        .clk(clk),
        .reset(reset),
        .data(data),
        .sum_out(sum_out)
    );
	 
	 function [31:0] generate_random_float(input integer seed);				// Функция генерации случайного числа с плавающей запятой
		reg [7:0] exponent;
		reg [22:0] mantissa;
		reg sign;
		begin
			exponent = $urandom(seed) % (2**8);
			mantissa = $urandom(seed) % (2**23);
			sign = $urandom(seed) % 2;
			generate_random_float = {sign, exponent, mantissa};
		end
	endfunction
	 
   always #5000 clk = ~clk;															// Задание clock с периодом 10ns

   initial begin
		clk = 0;																				// Задание начальных значений
      reset = 1;
      data = 32'b0;
		
      #10000;
      reset = 0;

      for (i = 0; i < N; i = i + 1) begin
			data = generate_random_float($random);									// Генерация случайных чисел с периодом в один период тактового сигнала
			#10000;
      end

	end
endmodule