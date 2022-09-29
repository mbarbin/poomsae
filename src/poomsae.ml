open! Core
module Block = Block
module Direction = Direction
module Elements = Elements
module Hand_attack = Hand_attack
module Kick = Kick
module Level = Level
module Movement = Movement
module Position = Position
module Side = Side
module Technique = Technique
module Trigram = Trigram

type t =
  { name : string
  ; movements : Movement.t list
  }
[@@deriving fields, sexp_of]

let create ~name movements = { name; movements }
let elements t = List.fold t.movements ~init:Elements.empty ~f:Elements.add_movement

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

module Maybe_mirror = struct
  type t =
    | New_movement of { index : int }
    | Equal of { equal_index : int }
    | Mirror of { mirror_of_index : int }
  [@@deriving equal, compare, hash]

  let char i = Char.of_int_exn (i + Char.to_int 'a')

  let sexp_of_t = function
    | New_movement { index } | Equal { equal_index = index } ->
      Sexp.Atom (sprintf "%c" (char index))
    | Mirror { mirror_of_index = index } -> Sexp.Atom (sprintf "%c'" (char index))
  ;;
end

let find_mirror_movements t =
  let rec aux acc indices = function
    | [] -> List.rev acc
    | (movement : Movement.t) :: tl ->
      let maybe_mirror, indices =
        match
          List.find_mapi indices ~f:(fun index m ->
            if Movement.equal movement { m with direction = movement.direction }
            then Some (Maybe_mirror.Equal { equal_index = index })
            else if Movement.equal
                      (Movement.mirror movement)
                      { m with direction = movement.direction }
            then Some (Maybe_mirror.Mirror { mirror_of_index = index })
            else None)
        with
        | Some maybe_mirror -> maybe_mirror, indices
        | None ->
          ( Maybe_mirror.New_movement { index = List.length indices }
          , indices @ [ movement ] )
      in
      aux ((movement, maybe_mirror) :: acc) indices tl
  in
  aux [] [] t.movements
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
      ; technique = Hand_attack (Jileugui { hand = Right; level = Montong })
      }
    ; { direction = East
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Block (Maki { hand = Right; level = Ale })
      }
    ; { direction = East
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Hand_attack (Jileugui { hand = Left; level = Montong })
      }
    ; { direction = North
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique =
          Chained
            [ Block (Maki { hand = Left; level = Ale })
            ; Hand_attack (Jileugui { hand = Right; level = Montong })
            ]
      }
    ; { direction = East
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Block (Maki { hand = Left; level = Montong })
      }
    ; { direction = East
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Hand_attack (Jileugui { hand = Right; level = Montong })
      }
    ; { direction = West
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Right; level = Montong })
      }
    ; { direction = West
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Hand_attack (Jileugui { hand = Left; level = Montong })
      }
    ; { direction = North
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique =
          Chained
            [ Block (Maki { hand = Right; level = Ale })
            ; Hand_attack (Jileugui { hand = Left; level = Montong })
            ]
      }
    ; { direction = West
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Left; level = Eulgoul })
      }
    ; { direction = West
      ; position = Ap_Seugui { front_foot = Right }
      ; technique =
          Chained
            [ Kick (Ap_Tchagui { foot = Right; level = Eulgoul })
            ; Hand_attack (Jileugui { hand = Right; level = Montong })
            ]
      }
    ; { direction = East
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Block (Maki { hand = Right; level = Eulgoul })
      }
    ; { direction = East
      ; position = Ap_Seugui { front_foot = Left }
      ; technique =
          Chained
            [ Kick (Ap_Tchagui { foot = Left; level = Eulgoul })
            ; Hand_attack (Jileugui { hand = Left; level = Montong })
            ]
      }
    ; { direction = South
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Left; level = Ale })
      }
    ; { direction = South
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique = Hand_attack (Jileugui { hand = Right; level = Montong })
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
      ; technique = Hand_attack (Jileugui { hand = Right; level = Montong })
      }
    ; { direction = East
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Block (Maki { hand = Right; level = Ale })
      }
    ; { direction = East
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique = Hand_attack (Jileugui { hand = Left; level = Montong })
      }
    ; { direction = North
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Right; level = Montong })
      }
    ; { direction = North
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Block (Maki { hand = Left; level = Montong })
      }
    ; { direction = West
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Left; level = Ale })
      }
    ; { direction = West
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique =
          Chained
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
          Chained
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
      ; technique = Block (Maki { hand = Right; level = Montong })
      }
    ; { direction = West (* Rotating going through South *)
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Block (Maki { hand = Left; level = Montong })
      }
    ; { direction = South
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Left; level = Ale })
      }
    ; { direction = South
      ; position = Ap_Seugui { front_foot = Right }
      ; technique =
          Chained
            [ Kick (Ap_Tchagui { foot = Right; level = Eulgoul })
            ; Hand_attack (Jileugui { hand = Right; level = Montong })
            ]
      }
    ; { direction = South
      ; position = Ap_Seugui { front_foot = Left }
      ; technique =
          Chained
            [ Kick (Ap_Tchagui { foot = Left; level = Eulgoul })
            ; Hand_attack (Jileugui { hand = Left; level = Montong })
            ]
      }
    ; { direction = South
      ; position = Ap_Seugui { front_foot = Right }
      ; technique =
          Chained
            [ Kick (Ap_Tchagui { foot = Right; level = Eulgoul })
            ; Hand_attack (Jileugui { hand = Right; level = Montong })
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
          Chained
            [ Kick (Ap_Tchagui { foot = Right; level = Eulgoul })
            ; Hand_attack (Jileugui { hand = Right; level = Montong })
            ; Hand_attack (Jileugui { hand = Left; level = Montong })
            ]
      }
    ; { direction = East
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Block (Maki { hand = Right; level = Ale })
      }
    ; { direction = East
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique =
          Chained
            [ Kick (Ap_Tchagui { foot = Left; level = Eulgoul })
            ; Hand_attack (Jileugui { hand = Left; level = Montong })
            ; Hand_attack (Jileugui { hand = Right; level = Montong })
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
      ; technique = Block (Han_Sonnal_Maki { hand = Left; level = Montong })
      }
    ; { direction = West
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique = Hand_attack (Jileugui { hand = Right; level = Montong })
      }
    ; { direction = East
      ; position = Dwitt_Koubi { front_foot = Right }
      ; technique = Block (Han_Sonnal_Maki { hand = Right; level = Montong })
      }
    ; { direction = East
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique = Hand_attack (Jileugui { hand = Left; level = Montong })
      }
    ; { direction = North
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Right; level = Montong })
      }
    ; { direction = North
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Block (Maki { hand = Left; level = Montong })
      }
    ; { direction = East (* Rotating going through South *)
      ; position = Ap_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Left; level = Ale })
      }
    ; { direction = East
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique =
          Chained
            [ Kick (Ap_Tchagui { foot = Right; level = Eulgoul })
            ; Hand_attack (Jileugui { hand = Right; level = Montong })
            ; Hand_attack (Jileugui { hand = Left; level = Montong })
            ]
      }
    ; { direction = West (* Rotating going through South *)
      ; position = Ap_Seugui { front_foot = Right }
      ; technique = Block (Maki { hand = Right; level = Ale })
      }
    ; { direction = West
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique =
          Chained
            [ Kick (Ap_Tchagui { foot = Left; level = Eulgoul })
            ; Hand_attack (Jileugui { hand = Left; level = Montong })
            ; Hand_attack (Jileugui { hand = Right; level = Montong })
            ]
      }
    ; { direction = South
      ; position = Ap_Seugui { front_foot = Left }
      ; technique =
          Chained
            [ Block (Maki { hand = Left; level = Ale })
            ; Hand_attack (Jileugui { hand = Right; level = Montong })
            ]
      }
    ; { direction = South
      ; position = Ap_Seugui { front_foot = Right }
      ; technique =
          Chained
            [ Block (Maki { hand = Right; level = Ale })
            ; Hand_attack (Jileugui { hand = Left; level = Montong })
            ]
      }
    ; { direction = South
      ; position = Ap_Seugui { front_foot = Left }
      ; technique =
          Chained
            [ Kick (Ap_Tchagui { foot = Left; level = Eulgoul })
            ; Block (Maki { hand = Left; level = Ale })
            ; Hand_attack (Jileugui { hand = Right; level = Montong })
            ]
      }
    ; { direction = South
      ; position = Ap_Seugui { front_foot = Right }
      ; technique =
          Chained
            [ Kick (Ap_Tchagui { foot = Right; level = Eulgoul })
            ; Block (Maki { hand = Right; level = Ale })
            ; Hand_attack (Jileugui { hand = Left; level = Montong })
            ]
      }
    ]
;;

let poomsae_4 =
  create
    ~name:"TAE GEUG SA JANG"
    [ { direction = West
      ; position = Dwitt_Koubi { front_foot = Left }
      ; technique = Block (Sonnal_Maki { hand = Left; level = Montong })
      }
    ; { direction = West
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique = Hand_attack (Pyon_Sonn_Seo_Jileugui { hand = Right })
      }
    ; { direction = East
      ; position = Dwitt_Koubi { front_foot = Right }
      ; technique = Block (Sonnal_Maki { hand = Right; level = Montong })
      }
    ; { direction = East
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique = Hand_attack (Pyon_Sonn_Seo_Jileugui { hand = Left })
      }
    ; { direction = North
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique = Hand_attack (Jebipoum_Mok_Tchigui { hand = Right })
      }
    ; { direction = North
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique =
          Chained
            [ Kick (Ap_Tchagui { foot = Right; level = Eulgoul })
            ; Hand_attack (Jileugui { hand = Left; level = Montong })
            ]
      }
    ; { direction = North
      ; position = Dwitt_Koubi { front_foot = Right }
      ; technique =
          Chained
            [ Kick (Yop_Tchagui { foot = Left; level = Eulgoul })
            ; Kick (Yop_Tchagui { foot = Right; level = Eulgoul })
            ; Block (Sonnal_Maki { hand = Right; level = Montong })
            ]
      }
    ; { direction = East (* Rotating going through South *)
      ; position = Dwitt_Koubi { front_foot = Left }
      ; technique = Block (Bakkat_Maki { hand = Left; level = Montong })
      }
    ; { direction = East
      ; position = Dwitt_Koubi { front_foot = Left }
      ; technique =
          Chained
            [ Kick (Ap_Tchagui { foot = Right; level = Eulgoul })
            ; Block (Maki { hand = Right; level = Montong })
            ]
      }
    ; { direction = West (* Rotating going through South *)
      ; position = Dwitt_Koubi { front_foot = Right }
      ; technique = Block (Bakkat_Maki { hand = Right; level = Montong })
      }
    ; { direction = West
      ; position = Dwitt_Koubi { front_foot = Right }
      ; technique =
          Chained
            [ Kick (Ap_Tchagui { foot = Left; level = Eulgoul })
            ; Block (Maki { hand = Left; level = Montong })
            ]
      }
    ; { direction = South
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique = Hand_attack (Jebipoum_Mok_Tchigui { hand = Right })
      }
    ; { direction = South
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique =
          Chained
            [ Kick (Ap_Tchagui { foot = Right; level = Eulgoul })
            ; Hand_attack (Deung_Joumok_Ap_Tchigui { hand = Right; level = Eulgoul })
            ]
      }
    ; { direction = East
      ; position = Ap_Seugui { front_foot = Left }
      ; technique =
          Chained
            [ Block (Maki { hand = Left; level = Montong })
            ; Hand_attack (Jileugui { hand = Right; level = Montong })
            ]
      }
    ; { direction = West (* Going through South *)
      ; position = Ap_Seugui { front_foot = Right }
      ; technique =
          Chained
            [ Block (Maki { hand = Right; level = Montong })
            ; Hand_attack (Jileugui { hand = Left; level = Montong })
            ]
      }
    ; { direction = South
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique =
          Chained
            [ Block (Maki { hand = Left; level = Montong })
            ; Hand_attack (Jileugui { hand = Right; level = Montong })
            ; Hand_attack (Jileugui { hand = Left; level = Montong })
            ]
      }
    ; { direction = South
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique =
          Chained
            [ Block (Maki { hand = Right; level = Montong })
            ; Hand_attack (Jileugui { hand = Left; level = Montong })
            ; Hand_attack (Jileugui { hand = Right; level = Montong })
            ]
      }
    ]
;;

let poomsae_5 =
  create
    ~name:"TAE GEUG OH JANG"
    [ { direction = West
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Left; level = Ale })
      }
    ; { direction = West
      ; position = Wen_Seugui
      ; technique = Hand_attack (Me_Jumok_Nelyeu_Tchigui { hand = Left })
      }
    ; { direction = East
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique = Block (Maki { hand = Right; level = Ale })
      }
    ; { direction = East
      ; position = Oren_Seugui
      ; technique = Hand_attack (Me_Jumok_Nelyeu_Tchigui { hand = Right })
      }
    ; { direction = North
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique =
          Chained
            [ Block (Maki { hand = Left; level = Montong })
            ; Block (Maki { hand = Right; level = Montong })
            ]
      }
    ; { direction = North
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique =
          Chained
            [ Kick (Ap_Tchagui { foot = Right; level = Eulgoul })
            ; Hand_attack (Deung_Joumok_Ap_Tchigui { hand = Right; level = Eulgoul })
            ; Block (Maki { hand = Left; level = Montong })
            ]
      }
    ; { direction = North
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique =
          Chained
            [ Kick (Ap_Tchagui { foot = Left; level = Eulgoul })
            ; Hand_attack (Deung_Joumok_Ap_Tchigui { hand = Left; level = Eulgoul })
            ; Block (Maki { hand = Right; level = Montong })
            ]
      }
    ; { direction = North
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique =
          Hand_attack (Deung_Joumok_Ap_Tchigui { hand = Right; level = Eulgoul })
      }
    ; { direction = East (* Rotating going through South *)
      ; position = Dwitt_Koubi { front_foot = Left }
      ; technique = Block (Han_Sonnal_Maki { hand = Left; level = Montong })
      }
    ; { direction = East
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique = Hand_attack (Palkoup_Dolyeu_Tchigui { elbow = Right })
      }
    ; { direction = West (* Rotating going through South *)
      ; position = Dwitt_Koubi { front_foot = Right }
      ; technique = Block (Han_Sonnal_Maki { hand = Right; level = Montong })
      }
    ; { direction = West
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique = Hand_attack (Palkoup_Dolyeu_Tchigui { elbow = Left })
      }
    ; { direction = South
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique =
          Chained
            [ Block (Maki { hand = Left; level = Ale })
            ; Block (Maki { hand = Right; level = Montong })
            ]
      }
    ; { direction = South
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique =
          Chained
            [ Kick (Ap_Tchagui { foot = Right; level = Eulgoul })
            ; Block (Maki { hand = Right; level = Ale })
            ; Block (Maki { hand = Left; level = Montong })
            ]
      }
    ; { direction = East
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique = Block (Maki { hand = Right; level = Eulgoul })
      }
    ; { direction = East
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique =
          Chained
            [ Kick (Yop_Tchagui { foot = Right; level = Eulgoul })
            ; Hand_attack (Palkoup_Pyo_Jeuk_Tchigui { elbow = Left })
            ]
      }
    ; { direction = West
      ; position = Ap_Koubi_Seugui { front_foot = Right }
      ; technique = Block (Maki { hand = Left; level = Eulgoul })
      }
    ; { direction = East
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique =
          Chained
            [ Kick (Yop_Tchagui { foot = Left; level = Eulgoul })
            ; Hand_attack (Palkoup_Pyo_Jeuk_Tchigui { elbow = Right })
            ]
      }
    ; { direction = South
      ; position = Ap_Koubi_Seugui { front_foot = Left }
      ; technique =
          Chained
            [ Block (Maki { hand = Left; level = Ale })
            ; Block (Maki { hand = Right; level = Montong })
            ]
      }
    ; { direction = South
      ; position = Dwitt_Koa { front_foot = Right }
      ; technique =
          Chained
            [ Kick (Ap_Tchagui { foot = Right; level = Eulgoul })
            ; Hand_attack (Deung_Joumok_Ap_Tchigui { hand = Right; level = Eulgoul })
            ]
      }
    ]
;;

let poomsae_6 = create ~name:"TAE GEUG YOUK JANG" []
let poomsae_7 = create ~name:"TAE GEUG TCHIL JANG" []
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

let preceding_poomsaes t =
  let rec aux acc = function
    | [] -> List.rev acc
    | hd :: tl -> if phys_equal hd t then aux acc [] else aux (hd :: acc) tl
  in
  aux [] all
;;

let new_elements t =
  let preceding_elements =
    List.fold (preceding_poomsaes t) ~init:Elements.empty ~f:(fun acc t ->
      Elements.union acc (elements t))
  in
  Elements.diff (elements t) preceding_elements
;;

let hello_world = [%sexp "Hello, World!"]

let print_cmd =
  Command.basic
    ~summary:"print hello world"
    (let%map_open.Command () = return () in
     fun () -> print_s hello_world)
;;

let main = Command.group ~summary:"" [ "print", print_cmd ]
