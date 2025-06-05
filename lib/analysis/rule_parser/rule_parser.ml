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

(* TODO: right now we do not care if two instructions cannot be executed in sequence, we have to do that for loops and if/else branches *)
(** applies the specified rule  *)
let search_specific_instruction (wasm_mod : Wasm_module.t) (mnemonic : string) : unit = 
  List.iter wasm_mod.funcs ~f:(fun func ->
    Printf.printf "_______________ function %ld _______________\n" func.idx;
    let flat_instrs = flatten_instrs func.code.body in
    List.iteri flat_instrs ~f:(fun idx instr ->
      (* Printf.printf "Instr %d: %s\n" (idx+1) (Instr.to_mnemonic instr) *)
      (* Uncomment to match specific instructions *)
      if String.equal (Instr.to_mnemonic instr) mnemonic then
        Printf.printf "%s present in function %ld at offset %d\n" (Instr.to_mnemonic instr) func.idx idx
    )
  )
;;
