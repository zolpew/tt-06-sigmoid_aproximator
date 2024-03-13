
module testbench_sigmoid;
    reg [15:0] X;
    reg [7:0] ui_in;
    wire [7:0] uo_out;
    reg [7:0] uio_in;
    wire [7:0] uio_out;
    reg ena;
    reg clk;
    reg rst_n;

    

    


    alipi_aprox_sigmoid t1 (.ui_in(ui_in), .uo_out(uo_out), .uio_in(uio_in), .uio_out(uio_out), .ena(ena), .clk(clk), .rst_n(rst_n));

    initial begin
        $dumpfile("chazim_sigmoid.vcd");
        $dumpvars(0,testbench_sigmoid);
        #10
        X = 16'b00000010_10000000;
        ui_in = X[15:8];
        uio_in = X[7:0];
        #10
        X = 16'b11111110_10000000;
        ui_in = X[15:8];
        uio_in = X[7:0];
        #10
        $finish;

        


    end

endmodule
    







module alipi_aprox_sigmoid (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);  

        wire [15:0] X = {ui_in,uio_in};
        wire [15:0] y;



        wire [15:0] out1x;
 
        wire [15:0] out2x;
        wire [15:0] out3x;
        wire out_selx;
        
        absoluter a1 ( .x(X), .out1(out1x), .out_sel(out_selx) );
        first u1 (.out1(out1x),.sel_first(out_selx) ,.out2(out2x));
        mux u2 (.sel2(out_selx), .out2(out2x) ,.out3(out3x));

        assign y = out3x;
        assign uo_out = y[15:8];
        assign uio_out = y[7:0];

 

endmodule


module absoluter(input wire [15:0] x, output wire [15:0] out1, output wire out_sel);
    reg [15:0] x_1;
    reg [15:0] x_2;
    reg sel1;
    always@* begin
        if (x[15] == 1'b0)begin
            sel1 = 1'b1;
        end 

        else begin
            sel1 = 1'b0;
        end

        x_1 = x - 16'b00000001_00000000;
        x_2 = {~ x_1[15:8],x_1[7:0]};
    end
    assign out1 = sel1? x:x_2;
    assign out_sel = sel1;
endmodule

module first (input wire [15:0] out1, input wire sel_first, output wire [15:0] out2);
    reg [15:0] c;
    reg [15:0] d;
    reg [15:0] e;
    reg [15:0] f;
    reg [15:0] g;
    reg [15:0] h;

    // Calculate the value of x[15:8] outside the array indexing
 
    
    

    always @* begin
  
        d = {8'b00000000, out1[7:0]};
    
        f = d >> 2;

        if (sel_first == 1'b1) begin
            g = f + 16'b00000000_10000000;
        

        end

        else begin
            g = 16'b00000000_10000000 - f;


        end


        
        h = g >> out1[15:8];
    end

    assign out2 = h;
endmodule

module mux(input wire sel2, input wire [15:0] out2, output wire [15:0] out3);
    reg [15:0]  a;
    always @* begin
        
        a = 16'b00000001_00000000 - out2;
    end
    assign out3 = ~sel2? out2:a;
endmodule










