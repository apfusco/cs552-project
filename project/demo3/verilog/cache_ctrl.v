module cache_ctrl(clk,
                  rst,
                  addr,
                  read,
                  write,
                  hit,
                  dirty,
                  valid,
                  busy,
                  mem_stall,
                  cnt,
                  err,
                  CacheHit,
                  Done,
                  stall,
                  comp,
                  en,
                  cache_wr,
                  mem_rd,
                  mem_wr,
                  inc,
                  flip_victimway,
                  update_victim);

   input clk;
   input rst;

   input [15:0] addr;
   input        read;
   input        write;
   input        hit;
   input        dirty;
   input        valid;
   input [3:0]  busy;
   input        mem_stall;
   input [1:0]  cnt;

   output err;

   output reg        CacheHit;
   output reg        Done;
   output reg        stall;
   output reg        comp;
   output reg        en;
   output reg        cache_wr;
   output reg        mem_rd;
   output reg        mem_wr;
   output reg        inc;
   output reg        flip_victimway;
   output reg        update_victim;

   reg case_err;
   wire [3:0] state;
   reg [3:0] nxt_state;

   wire input_error;

   assign input_error = 1'b0;
   //assign input_error = (^{clk,
   //                        rst,
   //                        addr,
   //                        read,
   //                        write,
   //                        hit,
   //                        dirty,
   //                        valid,
   //                        busy} === 1'bX) ? 1'b1 : 1'b0;
   assign err = input_error | case_err;

   register #(.N(4)) state_register(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(nxt_state), .dataOut(state), .err());

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
      flip_victimway = 1'b0;
      update_victim = 1'b0;
      nxt_state = state;

      case (state)
         4'b0000 : begin // IDLE
            en = read | write;
            comp = read | write;
            cache_wr = write;
            CacheHit = (read | write) & hit & valid;
            Done = (read | write) & hit & valid;
            stall = (read | write) & (~hit | ~valid);
            inc = (read | write) & (~hit | ~valid) & &cnt;
            flip_victimway = read | write;
            update_victim = 1'b1;
            nxt_state = ((read | write) & (~hit | ~valid)) ? 4'b0011: state;
         end
         4'b0001 : begin // TODO: Remove
         end
         4'b0010 : begin // TODO: Remove
         end
         4'b0011 : begin // ACCESS_RD
            en = 1'b1;
            inc = ~mem_stall;
            mem_wr = dirty & valid;
            mem_rd = ~dirty | ~valid;
            nxt_state = mem_stall ? state : (dirty & valid ? 4'b0100 : 4'b0101);
         end
         4'b0100 : begin // MEM_WR_1
            // No transition
            en = !(!mem_stall && !cnt);
            mem_wr = !(!mem_stall && !cnt);

            mem_rd = !mem_stall && !cnt;
            inc = !mem_stall;
            nxt_state = (!mem_stall && !cnt) ? 4'b0101 : state;
         end
         4'b0101 : begin // MEM_RD_1
            en = ~mem_stall;
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
            inc = 1'b1;
            nxt_state = 4'b0000;
         end
         4'b0111 : begin // ACCESS_WR_2
            en = 1'b1;
            cache_wr = 1'b1;
            inc = 1'b1;
            nxt_state = 4'b0110;
         end
         4'b1000 : begin // MEM_RD_2
            en = 1'b1;
            cache_wr = 1'b1;
            mem_rd = |cnt;
            inc = ~mem_stall;
            nxt_state = !cnt ? 4'b0111 : (mem_stall && |cnt) ? 4'b0101 : state;
         end
         default : begin
            nxt_state = 4'b0000;
            case_err = 1'b1;
         end
      endcase
   end

endmodule
