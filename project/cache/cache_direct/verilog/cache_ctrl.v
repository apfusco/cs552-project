module cache_ctrl(clk,
                  rst,
                  addr,
                  dataIn,
                  read,
                  write,
                  hit,
                  dirty,
                  valid,
                  busy,
                  err,
                  dataOut,
                  CacheHit,
                  Done,
                  stall,
                  comp,
                  en,
                  cache_wr,
                  mem_rd,
                  mem_wr);

   input clk;
   input rst;

   input [15:0] addr;
   input [15:0] dataIn;
   input        read;
   input        write;
   input        hit;
   input        dirty;
   input        valid;
   input [3:0]  busy;

   output err;

   output reg [15:0] dataOut;
   output reg        CacheHit;
   output reg        Done;
   output reg        stall;
   output reg        comp;
   output reg        en;
   output reg        cache_wr;
   output reg        mem_rd;
   output reg        mem_wr;

   reg case_err;
   reg [3:0] state;
   reg [3:0] nxt_state;

   wire input_error;

   assign input_error = (^{clk,
                           rst,
                           addr,
                           dataIn,
                           read,
                           write,
                           hit,
                           dirty,
                           valid,
                           busy} === 1'bX) ? 1'b1 : 1'b0;
   assign err = input_error | case_err;

   always @(posedge clk) begin
      if (rst)
         state <= 1'b0;
      else
         state <= nxt_state;
   end

   always @(*) begin
      CacheHit = 1'b0;
      Done = 1'b0;
      stall = 1'b1;
      comp = 1'b0;
      en = 1'b0;
      cache_wr = 1'b0;
      mem_rd = 1'b0;
      mem_wr = 1'b0;
      case_err = 1'b0;
      nxt_state = state;

      case (state)
         4'b0000 : begin // IDLE
            if (read) begin
               en = 1'b1;
               comp = 1'b1;
               if (hit & valid) begin
                  CacheHit = 1'b1;
                  Done = 1'b1;
                  stall = 1'b0;
               end else if (dirty) begin
                  en = 1'b1;
                  nxt_state = 4'b0011;
               end else begin
                  mem_rd = 1'b0;
                  nxt_state = 4'b0101;
               end
            end else if (write) begin
               en = 1'b1;
               comp = 1'b1;
               cache_wr = 1'b1;
               if (hit & valid) begin
                  CacheHit = 1'b1;
                  Done = 1'b1;
                  stall = 1'b0;
               end else begin
                  en = 1'b1;
                  nxt_state = 4'b0011;
               end
            end else
               stall = 1'b0;
         end
         4'b0001 : begin // CMP_WR
            if (hit & valid) begin
               CacheHit = 1'b1;
               Done = 1'b1;
               nxt_state = 4'b0000;
            end else begin
               en = 1'b1;
               nxt_state = 4'b0011;
            end
         end
         4'b0010 : begin // CMP_RD
            if (hit & valid) begin
               CacheHit = 1'b1;
               Done = 1'b1;
               nxt_state = 4'b0000;
            end else if (dirty) begin
               en = 1'b1;
               nxt_state = 4'b0011;
            end else begin
               mem_rd = 1'b0;
               nxt_state = 4'b0101;
            end
         end
         4'b0011 : begin // ACCESS_RD
            if (dirty) begin
               mem_wr = 1'b1;
               nxt_state = 4'b0100;
            end else begin
               mem_rd = 1'b1;
               nxt_state = 4'b0101;
            end
         end
         4'b0100 : begin // MEM_WR
            if (!busy)
               nxt_state = 4'b0101;
         end
         4'b0101 : begin // MEM_RD
            if (!busy) begin
               en = 1'b1;
               cache_wr = 1'b1;
               nxt_state = 4'b0110;
            end
         end
         4'b0110 : begin // ACCESS_WR
            nxt_state = 4'b0000;
            Done = 1'b1;
            stall = 1'b0;
            en = 1'b1;
            comp = 1'b1;
            cache_wr = write;
         end
         4'b0111 : begin // MISS_WR
            Done = 1'b1;
            stall = 1'b0;
            nxt_state = 4'b0000;
         end
         4'b1000 : begin // MISS_RD
            Done = 1'b1;
            stall = 1'b0;
            nxt_state = 4'b0000;
         end
         default : begin
            nxt_state = 4'b0000;
            case_err = 1'b1;
         end
      endcase
   end

endmodule
