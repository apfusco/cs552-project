/*
* Logic for detecting when to stall in the pipelined processor. 
*/
module stall(
        // outputs
        id_ex_stall,
        // inputs
        id_ex_mem_wr,
        id_ex_Rd,
        if_id_Rs,
        if_id_Rt);

    output      id_ex_stall;

    input       id_ex_mem_wr;
    input [2:0] id_ex_Rt;
    input [2:0] if_id_Rs;
    input [2:0] if_id_Rt;

    wire id_ex_mem_rd;

    assign id_ex_mem_rd = ~id_ex_mem_wr;

    // TODO: add logic for determining if Rs/Rt exist or not
    // could accomplish this using the opcode as an input...
        // ex branches have no Rt, and jumps has nether Rs nor Rt
    
    // stall if there is a mem read and either one of the operands in the curr
    // instruction rely upon the prior insruction's result from a read
        // d/e_mem_rd & (d/e_Rt == f/d_Rs | d/e_Rt == f/d_Rt)
    assign id_ex_stall = id_ex_mem_rd & (
        ~|(id_ex_Rd ^ if_id_Rs) | 
        ~|(id_ex_Rd ^ if_id_Rt))

endmodule
