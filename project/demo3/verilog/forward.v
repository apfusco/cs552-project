/*
* Forwarding logic for data hazards in the pipelined processor.
*/
module forward(
        // outputs
        ex_fwd_Rs,
        ex_fwd_Rt,
        mem_fwd_Rs,
        mem_fwd_Rt,
        ex_Rs_data,
        ex_Rt_data,
        mem_Rs_data,
        mem_Rt_data,
        mem_fwd_ST,
        mem_to_mem_Rs,
        mem_to_mem_fwd_Rs,
        err,
        // inputs
        stall,
        mem_wr_en,
        mem_Rd,
        ex_has_Rt,
        ex_Rs, 
        ex_Rt,
        mem_Rt,
        wb_wr_en,
        wb_Rd,
        mem_alu_result,
        mem_set_result,
        mem_lbi_result,
        mem_slbi_result,
        mem_wr_sel,
        ex_mem_wr,
        wb_alu_result,
        wb_mem_result,
        wb_set_result,
        wb_lbi_result,
        wb_slbi_result,
        wb_wr_sel,
        mem_mem_wr);

// TODO: make set_inputs be 1 bit and then add zeros

    output        ex_fwd_Rs; // forward Rs to ex from ex
    output        ex_fwd_Rt; // forward Rt to ex from ex
    output        mem_fwd_Rs; // forward Rs to ex from mem
    output        mem_fwd_Rt; // forward Rt to ex from mem
    output        mem_fwd_ST;
    output        mem_to_mem_fwd_Rs; // forward Rs to mem from mem
    output [15:0] ex_Rs_data; // actual values forwarded
    output [15:0] ex_Rt_data;
    output [15:0] mem_Rs_data;
    output [15:0] mem_Rt_data;
    output [15:0] mem_to_mem_Rs;
    output        err;
    
    input        stall;
    input        mem_wr_en; // ex/mem stage reg write signal
    input [2:0]  mem_Rd;
    input        ex_has_Rt;
    input [2:0]  ex_Rs;
    input [2:0]  ex_Rt;
    input [2:0]  mem_Rt;
    input        wb_wr_en; // mem/wb stage reg write signal
    input [2:0]  wb_Rd;
    input [15:0] mem_alu_result; // ex stage results
    input [15:0] mem_set_result;
    input [15:0] mem_lbi_result;
    input [15:0] mem_slbi_result;
    input [2:0]  mem_wr_sel;
    input        ex_mem_wr;
    input [15:0] wb_alu_result; // mem stage results
    input [15:0] wb_mem_result;
    input [15:0] wb_set_result;
    input [15:0] wb_lbi_result;
    input [15:0] wb_slbi_result;
    input [2:0]  wb_wr_sel;
    input        mem_mem_wr;

   assign err = (^{stall,
                   mem_wr_en,
                   mem_Rd,
                   ex_has_Rt,
                   ex_Rs,
                   ex_Rt,
                   mem_Rt,
                   wb_wr_en,
                   wb_Rd,
                   mem_alu_result,
                   mem_set_result,
                   mem_lbi_result,
                   mem_slbi_result,
                   mem_wr_sel,
                   ex_mem_wr,
                   wb_alu_result,
                   wb_mem_result,
                   wb_set_result,
                   wb_lbi_result,
                   wb_slbi_result,
                   wb_wr_sel,
                   mem_mem_wr
                   } === 1'bX) ? 1'b1 : 1'b0;

    // TODO: PC_inc results needed or no?

    wire [15:0] ex_wr_data;
    wire [15:0] mem_wr_data;


    // foward in EX if writing result to reg and the EX/MEM dest and ID/EX 
    // source registers are same
    assign ex_fwd_Rs = mem_wr_en & ~|(mem_Rd ^ ex_Rs);
    assign ex_fwd_Rt = mem_wr_en & ex_has_Rt & ~|(mem_Rd ^ ex_Rt);

    // TODO: may need to manually implement !(e/m_wr_en & r/m_rd != d/e_rt)

    // foward in MEM if writing result to reg and the MEM/WB dest and ID/EX
    // source registers are the same, AND there is no prior EX forwarding
    assign mem_fwd_Rs = wb_wr_en & ~|(wb_Rd ^ ex_Rs) & ~ex_fwd_Rs;
    assign mem_fwd_Rt = wb_wr_en & ex_has_Rt & ~|(wb_Rd ^ ex_Rt) & ~ex_fwd_Rt;

//    assign mem_fwd_Rs = wb_wr_en & ~|(mem_wb_Rd ^ id_ex_Rs) & ~ex_fwd_Rs;
    assign mem_fwd_ST = wb_wr_en & ~|(wb_Rd ^ ex_Rt) & ex_mem_wr;

    assign mem_to_mem_fwd_Rs = mem_wr_en & ex_mem_wr & ~|(mem_Rd ^ ex_Rt);

    // hard to compress into a 4:1 mux because of how wr_sel is set up
        // could feasibly just make this a one-hot-esque thing
    mux8_1 mux8_1_ex_data[15:0](.InA(mem_alu_result),
                             .InB(16'h0000),
                             .InC(16'h0000),
                             .InD(mem_set_result),
                             .InE(mem_lbi_result),
                             .InF(mem_slbi_result),
                             .InG(16'h0000),
                             .InH(16'h0000),
                             .S(mem_wr_sel),
                             .Out(ex_wr_data));

    mux8_1 mux8_1_mem_data[15:0](.InA(wb_alu_result),
                             .InB(wb_mem_result),
                             .InC(16'h0000),//PC_inc
                             .InD(wb_set_result),
                             .InE(wb_lbi_result),
                             .InF(wb_slbi_result),
                             .InG(16'h0000),
                             .InH(16'h0000),
                             .S(wb_wr_sel),
                             .Out(mem_wr_data));

    assign ex_Rs_data = ex_wr_data;     // Should be used when ex_fwd_Rs
    assign ex_Rt_data = ex_wr_data;     // Should be used when ex_fwd_Rt
    assign mem_Rs_data = mem_wr_data;   // Should be used when mem_fwd_Rs
    assign mem_Rt_data = mem_wr_data;   // Should be used when mem_fwd_Rt
    assign mem_to_mem_Rs = ex_wr_data; // Should be used when mem_to_mem_fwd_Rs

endmodule
