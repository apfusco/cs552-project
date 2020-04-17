/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err,
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );

   // TODO: Right now, this module assumes that the input values will not
   // change while stall is asserted.
   
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
   wire cache_error;
   wire input_error;

   // Flopped inputs
   wire [15:0] Addr_reg;
   wire [15:0] DataIn_reg;
   wire        Rd_reg;
   wire        Wr_reg;
   wire        createdump_reg;

   wire        hit;
   wire        dirty;
   wire        valid;
   wire [4:0]  tag_out;
   wire        en;
   wire [4:0]  tag_in;
   wire        comp;
   wire        cache_wr;
   wire        mem_rd;
   wire        mem_wr;
   wire        mem_stall;// TODO: IDK what this signal is for.
   wire [3:0]  busy;

   wire [15:0] cache_data_in;
   wire [15:0] cache_data_out;
   wire [15:0] mem_data_out;
   wire [15:0] FSM_data_out;

   assign input_error = (^{Addr,
                           DataIn,
                           Rd,
                           Wr,
                           createdump,
                           clk,
                           rst} === 1'bX) ? 1'b1 : 1'b0;
   assign err = cache_ctrl_error | four_bank_mem_error | cache_error | input_error;

   register #(.N(16)) Addr_register(.clk(clk), .rst(rst), .writeEn(~Stall), .dataIn(Addr), .dataOut(Addr_reg), .err());
   register #(.N(16)) DataIn_register(.clk(clk), .rst(rst), .writeEn(~Stall), .dataIn(DataIn), .dataOut(DataIn_reg), .err());
   register #(.N(1)) Rd_register(.clk(clk), .rst(rst), .writeEn(~Stall), .dataIn(Rd), .dataOut(Rd_reg), .err());
   register #(.N(1)) Wr_register(.clk(clk), .rst(rst), .writeEn(~Stall), .dataIn(Wr), .dataOut(Wr_reg), .err());
   register #(.N(1)) createdump_register(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(createdump), .dataOut(createdump_reg), .err());

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (tag_out),
                          .data_out             (cache_data_out),
                          .hit                  (hit),
                          .dirty                (dirty),
                          .valid                (valid),
                          .err                  (cache_error),
                          // Inputs
                          .enable               (en),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump_reg),
                          .tag_in               (tag_in),
                          .index                (Addr_reg[10:3]),
                          .offset               (Addr_reg[2:0]),
                          .data_in              (cache_data_in),
                          .comp                 (comp),
                          .write                (cache_wr),
                          .valid_in             (1'b1));

   four_bank_mem mem(// Outputs
                     .data_out          (mem_data_out),
                     .stall             (mem_stall/* TODO: IDK what this is */),
                     .busy              (busy),
                     .err               (four_bank_mem_error),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump_reg),
                     .addr              ({tag_in, Addr_reg[10:0]}),
                     .data_in           (cache_data_out),
                     .wr                (mem_wr),
                     .rd                (mem_rd));

   
   // your code here
   cache_ctrl FSM(.clk(clk),
                  .rst(rst),
                  .addr(Addr_reg),
                  .dataIn(DataIn_reg/* FIXME: Not used */),
                  .read(Rd_reg),
                  .write(Wr_reg),
                  .hit(hit),
                  .dirty(dirty),
                  .valid(valid),
                  .busy(busy),
                  .err(cache_ctrl_error),
                  .dataOut(FSM_data_out/* FIXME: Not used */),
                  .CacheHit(CacheHit),
                  .Done(Done),
                  .stall(Stall),
                  .comp(comp),
                  .en(en),
                  .cache_wr(cache_wr),
                  .mem_rd(mem_rd),
                  .mem_wr(mem_wr));

   mux2_1 mux_cache_data_in[15:0](.InA(mem_data_out), .InB(DataIn_reg), .S(comp), .Out(cache_data_in));
   mux2_1 mux_tag_in[4:0](.InA(tag_out), .InB(Addr_reg[15:11]), .S(comp | mem_rd), .Out(tag_in));

   assign DataOut = cache_data_out;
   
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
