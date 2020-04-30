/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err, 
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
   input [15:0] Addr;
   input [15:0] DataIn;
   input        Rd;
   input        Wr;
   input        createdump;
   input        clk;
   input        rst;
   
   output [15:0] DataOut;
   output Done;
   output Stall;
   output CacheHit;
   output err;

   wire cache_ctrl_error;
   wire four_bank_mem_error;
   wire c0_error;
   wire c2_error;
   wire input_error;

   // Flopped inputs
   wire [15:0] Addr_reg;
   wire [15:0] DataIn_reg;
   wire        Rd_reg;
   wire        Wr_reg;
   wire        createdump_reg;

   wire        c0_hit;
   wire        c2_hit;
   wire        c0_dirty;
   wire        c2_dirty;
   wire        c0_valid;
   wire        c2_valid;
   wire [4:0]  c0_tag_out;
   wire [4:0]  c2_tag_out;
   wire        en;
   wire [4:0]  tag_in;
   wire [2:0]  cache_offset_in;
   wire [2:0]  mem_offset_in;
   wire [15:0] mem_data_in;
   wire        comp;
   wire        cache_wr;
   wire        c0_wr;
   wire        c2_wr;
   wire        mem_rd;
   wire        mem_wr;
   wire        inc;
   wire        mem_stall;
   wire [1:0]  cnt;
   wire [1:0]  cnt_inc;
   wire [1:0]  cnt_dec;
   wire [3:0]  busy;
   wire        victimway;
   wire        flip_victimway;
   wire        update_victim;

   wire [15:0] cache_data_in;
   wire [15:0] c0_data_out;
   wire [15:0] c2_data_out;
   wire [15:0] mem_data_out;

   assign input_error = (^{Addr,
                           DataIn,
                           Rd,
                           Wr,
                           createdump,
                           clk,
                           rst} === 1'bX) ? 1'b1 : 1'b0;
   assign err = cache_ctrl_error | four_bank_mem_error | c0_error | c2_error | input_error;

   // Flopped inputs
   register #(.N(16)) Addr_register(.clk(clk), .rst(rst), .writeEn(~Stall), .dataIn(Addr), .dataOut(Addr_reg), .err());
   register #(.N(16)) DataIn_register(.clk(clk), .rst(rst), .writeEn(~Stall), .dataIn(DataIn), .dataOut(DataIn_reg), .err());
   register #(.N(1)) Rd_register(.clk(clk), .rst(rst), .writeEn(~Stall), .dataIn(Rd), .dataOut(Rd_reg), .err());
   register #(.N(1)) Wr_register(.clk(clk), .rst(rst), .writeEn(~Stall), .dataIn(Wr), .dataOut(Wr_reg), .err());
   register #(.N(1)) createdump_register(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(createdump), .dataOut(createdump_reg), .err());

   register #(.N(1)) victimway_register(.clk(clk), .rst(rst), .writeEn(flip_victimway), .dataIn(~victimway), .dataOut(victimway), .err());
   register #(.N(1)) victim_register(.clk(clk), .rst(rst), .writeEn(update_victim), .dataIn(nxt_victim), .dataOut(victim), .err());

   // Counter
   counter_2b adder(.A(cnt), .B(2'b01), .C_in(1'b0), .S(cnt_inc), .C_out());
   register #(.N(2)) cnt_register(.clk(clk), .rst(rst), .writeEn(inc), .dataIn(cnt_inc), .dataOut(cnt), .err());
   assign cnt_dec = {~cnt[1], cnt[0]};

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (c0_tag_out),
                          .data_out             (c0_data_out),
                          .hit                  (c0_hit),
                          .dirty                (c0_dirty),
                          .valid                (c0_valid),
                          .err                  (c0_error),
                          // Inputs
                          .enable               (en),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump_reg),
                          .tag_in               (Addr_reg[15:11]),
                          .index                (Addr_reg[10:3]),
                          .offset               (cache_offset_in),
                          .data_in              (cache_data_in),
                          .comp                 (comp),
                          .write                (c0_wr),
                          .valid_in             (1'b1));
   cache #(2 + memtype) c1(// Outputs
                          .tag_out              (c2_tag_out),
                          .data_out             (c2_data_out),
                          .hit                  (c2_hit),
                          .dirty                (c2_dirty),
                          .valid                (c2_valid),
                          .err                  (c2_error),
                          // Inputs
                          .enable               (en),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (Addr_reg[15:11]),
                          .index                (Addr_reg[10:3]),
                          .offset               (cache_offset_in),
                          .data_in              (cache_data_in),
                          .comp                 (comp),
                          .write                (c2_wr),
                          .valid_in             (1'b1));

   four_bank_mem mem(// Outputs
                     .data_out          (mem_data_out),
                     .stall             (mem_stall),
                     .busy              (busy),
                     .err               (four_bank_mem_error),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              ({tag_in, Addr_reg[10:3], mem_offset_in}),
                     .data_in           (mem_data_in),
                     .wr                (mem_wr),
                     .rd                (mem_rd));
   
   // your code here
   cache_ctrl FSM(.clk(clk),
                  .rst(rst),
                  .addr(Addr_reg),
                  .read(Rd_reg),
                  .write(Wr_reg),
                  .hit(c0_hit | c2_hit),
                  .dirty(nxt_victim ? c2_dirty : c0_dirty),
                  .valid((c0_hit & c0_valid) | (c2_hit & c2_valid)),
                  .busy(busy),
                  .mem_stall(mem_stall),
                  .cnt(cnt),
                  .err(cache_ctrl_error),
                  .CacheHit(CacheHit),
                  .Done(Done),
                  .stall(Stall),
                  .comp(comp),
                  .en(en),
                  .cache_wr(cache_wr),
                  .mem_rd(mem_rd),
                  .mem_wr(mem_wr),
                  .inc(inc),
                  .flip_victimway(flip_victimway),
                  .update_victim(update_victim));

   mux2_1 mux_cache_data_in[15:0](.InA(mem_data_out), .InB(DataIn_reg), .S(comp), .Out(cache_data_in));
   mux2_1 mux_tag_in[4:0](.InA(victim ? c2_tag_out : c0_tag_out), .InB(Addr_reg[15:11]), .S(~mem_wr), .Out(tag_in));
   mux2_1 mux_cache_offset_in[2:0](.InA({cache_wr ? cnt_dec : cnt, 1'b0}), .InB(Addr_reg[2:0]), .S(comp), .Out(cache_offset_in));
   mux2_1 mux_mem_offset_in[2:0](.InA({cnt, 1'b0}), .InB(Addr_reg[2:0]), .S(comp), .Out(mem_offset_in));

   assign nxt_victim = (victimway | ~c2_valid) & c0_valid;
   assign mem_data_in = victim ? c2_data_out : c0_data_out;
   assign c0_wr = (comp | ~victim) & cache_wr;
   assign c2_wr = (comp | victim) & cache_wr;

   // Will only output non-zero when there's a hit and the data is valid.
   assign DataOut = (c2_hit && c2_valid) ? c2_data_out : (c0_hit && c0_valid) ? c0_data_out : 16'h0000;
   
endmodule // mem_system

   


// DUMMY LINE FOR REV CONTROL :9:
