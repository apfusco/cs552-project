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
                  mem_stall,
                  cnt,
                  err,
                  dataOut,
                  CacheHit,
                  Done,
                  stall,
                  comp,
                  en,
                  cache_wr,
                  mem_rd,
                  mem_wr,
                  inc);

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
   input        mem_stall;
   input [1:0]  cnt;

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
   output reg        inc;

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
      inc = 1'b0;
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
               end else begin
                  nxt_state = 4'b0011;
//               end else begin
//                  mem_rd = 1'b1;
//                  inc = 1'b1;
//                  nxt_state = 4'b0101;
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
                  nxt_state = 4'b0011;
               end
            end else // No request is made
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
            en = 1'b1;
            inc = ~mem_stall;
            if (dirty) begin
               mem_wr = 1'b1;
            end else begin
               mem_rd = 1'b1;
            end
            nxt_state = |busy ? state : (dirty ? 4'b0100 : 4'b0101);
         end
         4'b0100 : begin // MEM_WR_1
            // No transition
            en = !(!mem_stall && !cnt);
            mem_wr = !(!mem_stall && !cnt);

            mem_rd = !mem_stall && !cnt;
            inc = !mem_stall;
            nxt_state = (!mem_stall && !cnt) ? 4'b0111 : state;
         end
         4'b0101 : begin // MEM_RD_1
            en = ~mem_stall;
            cache_wr = ~mem_stall;
            mem_rd = 1'b1;
            inc = ~mem_stall;
            nxt_state = mem_stall ? state : 4'b1000;
         end
         4'b0110 : begin // ACCESS_WR
            en = 1'b1;
            comp = 1'b1;
            cache_wr = write;
            Done = 1'b1;
            stall = 1'b0;
            nxt_state = 4'b0000;
         end
         4'b0111 : begin // MEM_WR_2
            // TODO: Not used
            mem_rd = 1'b1;
            nxt_state = mem_stall ? state : 4'b0101;
         end
         4'b1000 : begin // MEM_RD_2
            en = 1'b1;
            cache_wr = 1'b1;
            mem_rd = !cnt;
            inc = |cnt & ~mem_stall;
            nxt_state = !cnt ? 4'b0110 : (stall && |cnt) ? 4'b0101 : state;
         end
         default : begin
            nxt_state = 4'b0000;
            case_err = 1'b1;
         end
      endcase
   end

endmodule
