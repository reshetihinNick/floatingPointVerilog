module fp_series_add #(
	parameter N = 8																	// Параметр, задающий количество чисел
)(
   input wire clk,
   input wire reset,
   input wire [31:0] data,															// Входной порт для загрузки чисел
   output reg [31:0] sum_out
);
	reg load;																			// Флаг загрузки чисел
	reg [$clog2(N):0] clk_counter;												// Счетчик тактов
   reg [31:0] partial_sums [N-1:0];												// Массив регистров для хранения промежуточных сумм
   wire [31:0] adder_sum [N/2-1:0];												// Массив выходных значений с сумматоров
	wire nan;
	wire overflow;
	wire underflow;
	wire zero;
   integer i, j, k;

   generate																				
       genvar idx;																	// Переменная для генерации сумматоров
       for (idx = 0; idx < N/2; idx = idx + 1) begin : adders			// Цикл с созданием сумматоров (их необходимо в 2 раза меньше количества чисел)
           float_add adder (
               .clk(clk),
					.reset(reset),
               .a(partial_sums[2*idx]),										// Четные элементы массива записываются как первые слогаемые
               .b(partial_sums[2*idx+1]),										// Нечетные - как вторые
               .result(adder_sum[idx]),
					.nan(nan),
					.overflow(overflow),
					.underflow(underflow),
					.zero(zero)
           );
       end
   endgenerate

   always @(posedge clk or posedge reset) begin
      if (reset) begin																// Сброс
			clk_counter <= 0;
			load <= 1;
         sum_out <= 0;
         for (i = 0; i < N; i = i + 1) begin
            partial_sums[i] <= 0;
         end
		end else if (load) begin													// Загрузка чисел
			if (clk_counter == N) begin											// Признак окончания загрузки
				load <= 0;
				clk_counter <= 0;
			end
			partial_sums[clk_counter] <= data;									// Запись чисел в массив (одно число за один такт)
			clk_counter <= clk_counter + 1;										// Инкремент счетчика тактов
      end else begin
         for (k = 0; k < $clog2(N); k = k + 1) begin						// Цикл для итерации суммирования
            for (j = 0; j < (N >> (k + 1)); j = j + 1) begin			// Вложенный цикл для суммирования пар
					partial_sums[j] <= adder_sum[j];								// Обновление промежуточных сумм 
            end
            if (k >= $clog2(N) - 1) begin										// Если достигнут последний этап суммирования
					sum_out <= partial_sums[0];									// Обновление выходной суммы
				end
         end
     end
  end
endmodule



