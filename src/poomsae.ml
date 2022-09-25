open! Core
module Block = Block
module Direction = Direction
module Hand_attack = Hand_attack
module Kick = Kick
module Level = Level
module Movement = Movement
module Position = Position
module Side = Side
module Technique = Technique

type t =
  { name : string
  ; movements : Movement.t list
  }
[@@deriving fields, sexp_of]

let create ~name movements = { name; movements }

let displacement_returns_to_origin t =
  let displacement =
    List.fold ~init:Displacement.origin t.movements ~f:Displacement.move
  in
  if Displacement.equal displacement Displacement.origin
  then Ok ()
  else
    error_s
      [%sexp
        "Poomsae displacement does not return to origin"
        , (t.name : string)
        , { displacement : Displacement.t }]
;;

let iter_consecutive_movements t ~f =
  List.reduce t.movements ~f:(fun m1 m2 ->
    f m1 m2;
    m2)
  |> (ignore : Movement.t option -> unit)
;;

let poomsae_1 =
  create
    ~name:"TAE GEUG IL JANG"
    [ { direction = West
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Left; level = Ale })
      }
    ; { direction = West
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Hand_attack (Jileugui { hand = Right; level = Momtong })
      }
    ; { direction = East
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Block (Maki { hand = Right; level = Ale })
      }
    ; { direction = East
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Hand_attack (Jileugui { hand = Left; level = Momtong })
      }
    ; { direction = North
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique =
          Linked
            [ Block (Maki { hand = Left; level = Ale })
            ; Hand_attack (Jileugui { hand = Right; level = Momtong })
            ]
      }
    ; { direction = East
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Block (Maki { hand = Left; level = Momtong })
      }
    ; { direction = East
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Hand_attack (Jileugui { hand = Right; level = Momtong })
      }
    ; { direction = West
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Right; level = Momtong })
      }
    ; { direction = West
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Hand_attack (Jileugui { hand = Left; level = Momtong })
      }
    ; { direction = North
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique =
          Linked
            [ Block (Maki { hand = Right; level = Ale })
            ; Hand_attack (Jileugui { hand = Left; level = Momtong })
            ]
      }
    ; { direction = West
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Left; level = Eulgoul })
      }
    ; { direction = West
      ; position = Ap_Seugui { front_foot = Right }
      ; technique =
          Linked
            [ Kick (Ap_Tchagui { foot = Right; level = Eulgoul })
            ; Hand_attack (Jileugui { hand = Right; level = Momtong })
            ]
      }
    ; { direction = East
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Block (Maki { hand = Right; level = Eulgoul })
      }
    ; { direction = East
      ; position = Ap_Seugui { front_foot = Left }
      ; technique =
          Linked
            [ Kick (Ap_Tchagui { foot = Left; level = Eulgoul })
            ; Hand_attack (Jileugui { hand = Left; level = Momtong })
            ]
      }
    ; { direction = South
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Left; level = Ale })
      }
    ; { direction = South
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique = Hand_attack (Jileugui { hand = Right; level = Momtong })
      }
    ]
;;

let poomsae_2 =
  create
    ~name:"TAE GEUG YI JANG"
    [ { direction = West
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Left; level = Ale })
      }
    ; { direction = West
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique = Hand_attack (Jileugui { hand = Right; level = Momtong })
      }
    ; { direction = East
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Block (Maki { hand = Left; level = Ale })
      }
    ; { direction = East
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique = Hand_attack (Jileugui { hand = Left; level = Momtong })
      }
    ; { direction = North
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Right; level = Momtong })
      }
    ; { direction = North
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Block (Maki { hand = Left; level = Momtong })
      }
    ; { direction = West
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Left; level = Ale })
      }
    ; { direction = West
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique =
          Linked
            [ Kick (Ap_Tchagui { foot = Right; level = Eulgoul })
            ; Hand_attack (Jileugui { hand = Right; level = Eulgoul })
            ]
      }
    ; { direction = East
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Block (Maki { hand = Right; level = Ale })
      }
    ; { direction = East
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique =
          Linked
            [ Kick (Ap_Tchagui { foot = Left; level = Eulgoul })
            ; Hand_attack (Jileugui { hand = Left; level = Eulgoul })
            ]
      }
    ; { direction = North
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Left; level = Eulgoul })
      }
    ; { direction = North
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Block (Maki { hand = Right; level = Eulgoul })
      }
    ; { direction = East (* Rotating going through South *)
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Right; level = Momtong })
      }
    ; { direction = West (* Rotating going through South *)
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Block (Maki { hand = Left; level = Momtong })
      }
    ; { direction = South
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Left; level = Ale })
      }
    ; { direction = South
      ; position = Ap_Seugui { front_foot = Right }
      ; technique =
          Linked
            [ Kick (Ap_Tchagui { foot = Right; level = Eulgoul })
            ; Hand_attack (Jileugui { hand = Right; level = Momtong })
            ]
      }
    ; { direction = South
      ; position = Ap_Seugui { front_foot = Left }
      ; technique =
          Linked
            [ Kick (Ap_Tchagui { foot = Left; level = Eulgoul })
            ; Hand_attack (Jileugui { hand = Left; level = Momtong })
            ]
      }
    ; { direction = South
      ; position = Ap_Seugui { front_foot = Right }
      ; technique =
          Linked
            [ Kick (Ap_Tchagui { foot = Right; level = Eulgoul })
            ; Hand_attack (Jileugui { hand = Right; level = Momtong })
            ]
      }
    ]
;;

let poomsae_3 =
  create
    ~name:"TAE GEUG SAM JANG"
    [ { direction = West
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Left; level = Ale })
      }
    ; { direction = West
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique =
          Linked
            [ Kick (Ap_Tchagui { foot = Right; level = Eulgoul })
            ; Hand_attack (Jileugui { hand = Right; level = Momtong })
            ; Hand_attack (Jileugui { hand = Left; level = Momtong })
            ]
      }
    ; { direction = East
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Block (Maki { hand = Right; level = Ale })
      }
    ; { direction = East
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique =
          Linked
            [ Kick (Ap_Tchagui { foot = Left; level = Eulgoul })
            ; Hand_attack (Jileugui { hand = Left; level = Momtong })
            ; Hand_attack (Jileugui { hand = Right; level = Momtong })
            ]
      }
    ; { direction = North
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Hand_attack (Han_Sonnal_Mok_Tchigui { hand = Right })
      }
    ; { direction = North
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Hand_attack (Han_Sonnal_Mok_Tchigui { hand = Left })
      }
    ; { direction = West
      ; position = Dwitt_Koubi { front_foot = Left }
      ; technique = Block (Han_Sonnal_Maki { hand = Left; level = Momtong })
      }
    ; { direction = West
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique = Hand_attack (Jileugui { hand = Right; level = Momtong })
      }
    ; { direction = East
      ; position = Dwitt_Koubi { front_foot = Right }
      ; technique = Block (Han_Sonnal_Maki { hand = Right; level = Momtong })
      }
    ; { direction = East
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique = Hand_attack (Jileugui { hand = Left; level = Momtong })
      }
    ; { direction = North
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Right; level = Momtong })
      }
    ; { direction = North
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Block (Maki { hand = Left; level = Momtong })
      }
    ; { direction = East (* Rotating going through South *)
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Left; level = Ale })
      }
    ; { direction = East
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique =
          Linked
            [ Kick (Ap_Tchagui { foot = Right; level = Eulgoul })
            ; Hand_attack (Jileugui { hand = Right; level = Momtong })
            ; Hand_attack (Jileugui { hand = Left; level = Momtong })
            ]
      }
    ; { direction = West (* Rotating going through South *)
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Block (Maki { hand = Left; level = Ale })
      }
    ; { direction = West
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique =
          Linked
            [ Kick (Ap_Tchagui { foot = Left; level = Eulgoul })
            ; Hand_attack (Jileugui { hand = Left; level = Momtong })
            ; Hand_attack (Jileugui { hand = Right; level = Momtong })
            ]
      }
    ; { direction = South
      ; position = Ap_Seugui { front_foot = Left }
      ; technique =
          Linked
            [ Block (Maki { hand = Left; level = Ale })
            ; Hand_attack (Jileugui { hand = Right; level = Momtong })
            ]
      }
    ; { direction = South
      ; position = Ap_Seugui { front_foot = Right }
      ; technique =
          Linked
            [ Block (Maki { hand = Right; level = Ale })
            ; Hand_attack (Jileugui { hand = Left; level = Momtong })
            ]
      }
    ; { direction = South
      ; position = Ap_Seugui { front_foot = Left }
      ; technique =
          Linked
            [ Kick (Ap_Tchagui { foot = Left; level = Eulgoul })
            ; Block (Maki { hand = Left; level = Ale })
            ; Hand_attack (Jileugui { hand = Right; level = Momtong })
            ]
      }
    ; { direction = South
      ; position = Ap_Seugui { front_foot = Right }
      ; technique =
          Linked
            [ Kick (Ap_Tchagui { foot = Right; level = Eulgoul })
            ; Block (Maki { hand = Right; level = Ale })
            ; Hand_attack (Jileugui { hand = Left; level = Momtong })
            ]
      }
    ]
;;

let poomsae_4 = create ~name:"TAE GEUG SA JANG" []
let poomsae_5 = create ~name:"TAE GEUG OH JANG" []
let poomsae_6 = create ~name:"TAE GEUG YOOK JANG" []
let poomsae_7 = create ~name:"TAE GEUG CHIL JANG" []
let poomsae_8 = create ~name:"TAE GEUG PAL JANG" []

let all =
  [ poomsae_1
  ; poomsae_2
  ; poomsae_3
  ; poomsae_4
  ; poomsae_5
  ; poomsae_6
  ; poomsae_7
  ; poomsae_8
  ]
;;

let hello_world = [%sexp "Hello, World!"]

let print_cmd =
  Command.basic
    ~summary:"print hello world"
    (let%map_open.Command () = return () in
     fun () -> print_s hello_world)
;;

let main = Command.group ~summary:"" [ "print", print_cmd ]
