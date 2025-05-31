open Core
open Helpers

(* TODO: This module will handle the rule parsing *)
(* for now we suppose to have a parsed rule structure *)
let rec flatten_instrs (instrs : unit Instr.t list) : unit Instr.t list =
  List.concat_map instrs ~f:(fun instr ->
    match instr with
    | Control c -> begin
        match c.instr with
        | Block (_bt, _, inner_instrs) ->
            instr :: flatten_instrs inner_instrs
        | Loop (_bt, _, inner_instrs) ->
            instr :: flatten_instrs inner_instrs
        | If (_bt, _, then_instrs, else_instrs) ->
            instr :: (flatten_instrs then_instrs @ flatten_instrs else_instrs)
        | _ ->
            [instr]
      end
    | _ ->
        [instr]
  )
;;

let search_specific_instruction (wasm_mod : Wasm_module.t) (mnemonic : string) : unit = 
  List.iter wasm_mod.funcs ~f:(fun func ->
    Printf.printf "_______________ function %ld _______________\n" func.idx;
    let flat_instrs = flatten_instrs func.code.body in
    List.iteri flat_instrs ~f:(fun idx instr ->
      Printf.printf "Instr %d: %s\n" (idx+1) (Instr.to_mnemonic instr)
    )
  )
;;


(* let apply_rule *)
(* TODO: read from multiline and parse rules *)
(* TODO: create a structure to represent the rule *)
(*
  A rule file contains a list of at least one rule
  All the rules will be applied with a logic-AND fashion and a constraint on sequence can be enforced
  E.G.
  
  rule1 > rule2 means that rule2 only applies to instructions that are following the one instruction that verifies rule1
  rule1; rule2 means that both rules must be verified, but there's no constraint on the order

  Every rule must contain: 
  - the mnemonic of the instruction to which it is related (i.e. int32.div_s)
  - the conditions on the parameters (if not present, the instruction just needs to be there)
 *)