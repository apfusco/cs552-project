/*
* Forwarding logic for data hazards in the pipelined processor.
*/
module forward(
        // outputs
        ex_fwd_Rs,
        ex_fwd_Rt,
        mem_fwd_Rs,
        mem_fwd_Rt,
        ex_Rs,
        ex_Rt,
        mem_Rs,
        mem_Rt,
        mem_fwd_ST,
        mem_to_mem_Rs,
        mem_to_mem_fwd_Rs,
        // inputs
        stall,
        mem_wr_en,
        ex_mem_Rd,
        id_ex_has_Rt,
        id_ex_Rs, 
        id_ex_Rt,
        ex_mem_Rs,
        wb_wr_en,
        mem_wb_Rd,
        ex_mem_alu_result,
        ex_mem_set_result,
        ex_mem_lbi_result,
        ex_mem_slbi_result,
        ex_mem_wr_sel,
        ex_mem_mem_wr,
        mem_wb_alu_result,
        mem_wb_mem_result,
        mem_wb_set_result,
        mem_wb_lbi_result,
        mem_wb_slbi_result,
        mem_wb_wr_sel,
        mem_wb_mem_wr);

// TODO: make set_inputs be 1 bit and then add zeros

    output        ex_fwd_Rs; // forward Rs to ex from ex
    output        ex_fwd_Rt; // forward Rt to ex from ex
    output        mem_fwd_Rs; // forward Rs to ex from mem
    output        mem_fwd_Rt; // forward Rt to ex from mem
    output        mem_fwd_ST;
    output        mem_to_mem_fwd_Rs; // forward Rs to mem from mem
    output [15:0] ex_Rs; // actual values forwarded
    output [15:0] ex_Rt;
    output [15:0] mem_Rs;
    output [15:0] mem_Rt;
    output [15:0] mem_to_mem_Rs;
    
    input        stall;
    input        mem_wr_en; // ex/mem stage reg write signal
    input [2:0]  ex_mem_Rd;
    input        id_ex_has_Rt;
    input [2:0]  id_ex_Rs;
    input [2:0]  id_ex_Rt;
    input [2:0]  ex_mem_Rs;
    input        wb_wr_en; // mem/wb stage reg write signal
    input [2:0]  mem_wb_Rd;
    input [15:0] ex_mem_alu_result; // ex stage results
    input [15:0] ex_mem_set_result;
    input [15:0] ex_mem_lbi_result;
    input [15:0] ex_mem_slbi_result;
    input [2:0]  ex_mem_wr_sel;
    input        ex_mem_mem_wr;
    input [15:0] mem_wb_alu_result; // mem stage results
    input [15:0] mem_wb_mem_result;
    input [15:0] mem_wb_set_result;
    input [15:0] mem_wb_lbi_result;
    input [15:0] mem_wb_slbi_result;
    input [2:0]  mem_wb_wr_sel;
    input        mem_wb_mem_wr;
    // TODO: PC_inc results needed or no?

    wire ex_mem_reg_wr;// TODO: This signal isn't used...?
    wire mem_wb_reg_wr;// TODO: This signal isn't used...?
    wire [15:0] ex_wr_data;
    wire [15:0] mem_wr_data;


    // foward in EX if writing result to reg and the EX/MEM dest and ID/EX 
    // source registers are same
    assign ex_fwd_Rs = mem_wr_en & ~|(ex_mem_Rd ^ id_ex_Rs);
    assign ex_fwd_Rt = mem_wr_en & id_ex_has_Rt & ~|(ex_mem_Rd ^ id_ex_Rt);

    // TODO: may need to manually implement !(e/m_wr_en & r/m_rd != d/e_rt)

    // foward in MEM if writing result to reg and the MEM/WB dest and ID/EX
    // source registers are the same, AND there is no prior EX forwarding
    assign mem_fwd_Rs = wb_wr_en & ~|(mem_wb_Rd ^ id_ex_Rs) & ~ex_fwd_Rs;
    assign mem_fwd_Rt = wb_wr_en & id_ex_has_Rt & ~|(mem_wb_Rd ^ id_ex_Rt) & ~ex_fwd_Rt;

//    assign mem_fwd_Rs = wb_wr_en & ~|(mem_wb_Rd ^ id_ex_Rs) & ~ex_fwd_Rs;
    assign mem_fwd_ST = wb_wr_en & ~|(mem_wb_Rd ^ id_ex_Rt) & ex_mem_mem_wr;

    assign mem_to_mem_fwd_Rs = wb_wr_en & mem_wb_mem_wr & ~|(mem_wb_Rd ^ ex_mem_Rs);

    // hard to compress into a 4:1 mux because of how wr_sel is set up
        // could feasibly just make this a one-hot-esque thing
    mux8_1 mux8_1_ex_data[15:0](.InA(ex_mem_alu_result),
                             .InB(16'h0000),
                             .InC(16'h0000),
                             .InD(ex_mem_set_result),
                             .InE(ex_mem_lbi_result),
                             .InF(ex_mem_slbi_result),
                             .InG(16'h0000),
                             .InH(16'h0000),
                             .S(ex_mem_wr_sel),
                             .Out(ex_wr_data));

    mux8_1 mux8_1_mem_data[15:0](.InA(mem_wb_alu_result),
                             .InB(mem_wb_mem_result),
                             .InC(16'h0000),//PC_inc
                             .InD(mem_wb_set_result),
                             .InE(mem_wb_lbi_result),
                             .InF(mem_wb_slbi_result),
                             .InG(16'h0000),
                             .InH(16'h0000),
                             .S(mem_wb_wr_sel),
                             .Out(mem_wr_data));

    // TODO: probably a better way to do this, but I'm tired
    // TODO: There can't be don't cares in the processor, so idk how this
    // should be implemented.
//    assign ex_Rs = (ex_fwd_Rs == 1'b1) ? ex_wr_data : dontcare;
//    assign ex_Rt = (ex_fwd_Rt == 1'b1) ? ex_wr_data : dontcare;
//    assign mem_Rs = (mem_fwd_Rs == 1'b1) ? mem_wr_data : dontcare;
//    assign mem_Rt = (mem_fwd_Rt == 1'b1) ? mem_wr_data : dontcare;

    assign ex_Rs = ex_wr_data;
    assign ex_Rt = ex_wr_data;
    assign mem_Rs = mem_wr_data;
    assign mem_Rt = mem_wr_data;

    // TODO: can I replace the true val with just an alu_result...
    assign mem_to_mem_Rs = mem_to_mem_fwd_Rs ? mem_wr_data : 16'h0000;
endmodule
