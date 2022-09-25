open! Core

let poomsae = Poomsae.poomsae_3

let%expect_test "name" =
  print_string (Poomsae.name poomsae);
  [%expect {| TAE GEUG SAM JANG |}]
;;

(* Some facts about this poomsae. *)

let%expect_test "elements" =
  print_s [%sexp (Poomsae.elements poomsae : Poomsae.Elements.t)];
  [%expect
    {|
    ((positions (Ap_Seugui Ap_Koubi_Seugui Dwitt_Koubi))
     (blocks (Maki Han_Sonnal_Maki))
     (hand_attacks (Jileugui Han_Sonnal_Mok_Tchigui)) (kicks (Ap_Tchagui))) |}]
;;

let%expect_test "new elements" =
  print_s [%sexp (Poomsae.new_elements poomsae : Poomsae.Elements.t)];
  [%expect
    {|
    ((positions (Dwitt_Koubi)) (blocks (Han_Sonnal_Maki))
     (hand_attacks (Han_Sonnal_Mok_Tchigui))) |}]
;;

let%expect_test "displacement" =
  (* One returns at the point of origin at the end of the poomsae. *)
  print_s [%sexp (Poomsae.displacement_returns_to_origin poomsae : unit Or_error.t)];
  [%expect {| (Ok ()) |}]
;;
