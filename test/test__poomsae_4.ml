open! Core

let poomsae = Poomsae.poomsae_4

let%expect_test "name" =
  print_string (Poomsae.name poomsae);
  [%expect {| TAE GEUG SA JANG |}]
;;

(* Some facts about this poomsae. *)

let%expect_test "displacement" =
  (* One returns at the point of origin at the end of the poomsae. *)
  print_s [%sexp (Poomsae.displacement_returns_to_origin poomsae : unit Or_error.t)];
  [%expect
    {|
    (Error
     ("Poomsae displacement does not return to origin" "TAE GEUG SA JANG"
      ((displacement
        ((north ((ap_seugui 0) (ap_koubi_seugui 2) (dwitt_koubi 1)))
         (west ((ap_seugui 1) (ap_koubi_seugui 1) (dwitt_koubi 3)))
         (east ((ap_seugui 1) (ap_koubi_seugui 1) (dwitt_koubi 3)))
         (south ((ap_seugui 0) (ap_koubi_seugui 4) (dwitt_koubi 0)))))))) |}]
;;