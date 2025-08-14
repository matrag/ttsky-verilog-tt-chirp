module clk_generator (
    input  wire                    i_rst_n,
    output reg                     o_clk
);

always @ (*) begin
  if(!rst_n) begin
    o_clk = 0;
  end else begin
    o_clk = !o_clk;
  end
end

endmodule
