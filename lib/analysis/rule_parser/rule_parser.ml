open Core
open Helpers
let debug_print (fidx : Int32.t) (instr : unit Instr.t) : unit =
  Printf.printf "Processing instruction in function %ld: %s\n"
    fidx (Instr.to_string instr);
  flush stdout
