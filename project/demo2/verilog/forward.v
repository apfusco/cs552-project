/*
* Forwarding logic for data hazards in the pipelined processor.
*/
module forward(
        // outputs
        ex_fwd_Rs,
        ex_fwd_Rt,
        mem_fwd_Rs,
        mem_fwd_Rt,
        // inputs
        mem_wr_en,
        ex_mem_Rd,
        id_ex_has_Rt,
        id_ex_Rs, 
        id_ex_Rt,
        wb_wr_en
        mem_wb_Rd);

    output      ex_fwd_Rs; // forward Rs to ex from ex
    output      ex_fwd_Rt; // forward Rt to ex from ex
    output      mem_fwd_Rs; // forward Rs to ex from mem
    output      mem_fwd_Rt; // forward Rt to ex from mem
    
    input       mem_wr_en; // ex/mem stage reg write signal
    input [2:0] ex_mem_Rd;
    input       id_ex_has_Rt;
    input [2:0] id_ex_Rs;
    input [2:0] id_ex_Rt;
    input       wb_wr_en; // mem/wb stage reg write signal
    input [2:0] mem_wb_Rd;

    wire ex_mem_reg_wr;
    wire mem_wb_reg_wr;

    // foward in EX if writing result to reg and the EX/MEM dest and ID/EX 
    // source registers are same
    assign ex_fwd_Rs = mem_wr_en & ~|(ex_mem_Rd ^ id_ex_Rs);
    assign ex_fwd_Rt = mem_wr_en & id_ex_has_Rt & ~|(ex_mem_Rd ^ id_ex_Rt); 


    // TODO: may need to manually implement !(e/m_wr_en & r/m_rd != d/e_rt)

    // foward in MEM if writing result to reg and the MEM/WB dest and ID/EX
    // source registers are the same, AND there is no prior EX forwarding
    assign mem_fwd_Rs = wb_wr_en & ~|(mem_wb_Rd ^ id_ex_Rs) & ~ex_fwd_Rs;
    assign mem_fwd_Rt = wb_wr_en & id_ex_has_Rt & ~|(mem_wb_Rd ^ id_ex_Rt) & ~ex_fwd_Rt;

    // TODO: implement support for JAL and JALR? Or should we stall for now?
endmodule
