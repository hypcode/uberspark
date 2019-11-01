(* uberspark front-end command processing logic for command: uobj *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner

type opts = { 
  platform : string; 
  arch : string;
  cpu: string;
};;

(* fold all uobj options into type opts *)
let cmd_uobj_opts_handler 
  (platform : string option)
  (arch : string option)
  (cpu : string option)
  : opts = 
  let l_platform = ref "" in
  let l_arch = ref "" in
  let l_cpu = ref "" in

  match platform with
  | None -> 
    l_platform := "";
  | Some l_str ->
    l_platform := l_str;
  ;

  match arch with
  | None -> 
    l_arch := "";
  | Some l_str ->
    l_arch := l_str;
  ;

  match cpu with
  | None -> 
    l_cpu := "";
  | Some l_str ->
    l_cpu := l_str;
  ;

  { platform = !l_platform; arch = !l_arch; cpu = !l_cpu}
;;

(* handle uobj command options *)
let cmd_uobj_opts_t =
  let docs = "ACTION OPTIONS" in
	let platform =
    let doc = "Specify uobj target $(docv)." in
    Arg.(value & opt (some string) None & info ["p"; "platform"] ~docv:"PLATFORM" ~doc ~docs)
  in
	let arch =
    let doc = "Specify uobj target $(docv)." in
    Arg.(value & opt (some string) None & info ["a"; "arch"] ~docv:"ARCH" ~doc ~docs)
  in
	let cpu =
    let doc = "Specify uobj target $(docv)." in
    Arg.(value & opt (some string) None & info ["c"; "cpu"] ~docv:"CPU" ~doc ~docs)
  in
  Term.(const cmd_uobj_opts_handler $ platform $ arch $ cpu)




(* build action handler *)
let handler_uobj_build
  (cmd_uobj_opts: opts)
  (uobj_path_ns : string)
  =

  if cmd_uobj_opts.platform = "" then
      `Error (true, "uobj PLATFORM must be specified.")
  else if cmd_uobj_opts.arch = "" then
      `Error (true, "uobj ARCH must be specified.")
  else if cmd_uobj_opts.cpu = "" then
      `Error (true, "uobj CPU must be specified.")
  else
    begin
      let (rval, abs_uobj_path_ns) = (Uberspark.Osservices.abspath uobj_path_ns) in
      if(rval == false) then
      begin
        Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "could not obtain absolute path for uobj: %s" abs_uobj_path_ns;
        ignore (exit 1);
      end
      ;

      if not (Uberspark.Bridge.initialize_from_config ()) then 
        begin
          Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "could not initialize bridges!";
          ignore (exit 1);
        end
      ;

      (* create uobj instance and parse manifest *)
      let uobj = new Uberspark.Uobj.uobject in
      let uobj_mf_filename = (abs_uobj_path_ns ^ "/" ^ Uberspark.Config.namespace_uobj_mf_filename) in
      Uberspark.Logger.log "parsing uobj manifest: %s" uobj_mf_filename;
      let rval = (uobj#parse_manifest uobj_mf_filename true) in	
      if (rval == false) then
        begin
          Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to stat/parse manifest for uobj: %s" uobj_mf_filename;
          ignore (exit 1);
        end
      ;

      Uberspark.Logger.log "successfully parsed uobj manifest";
      (*TBD: validate platform, arch, cpu target def with uobj target spec*)

      let target_def: Uberspark.Defs.Basedefs.target_def_t = {f_platform = cmd_uobj_opts.platform; f_arch = cmd_uobj_opts.arch; f_cpu = cmd_uobj_opts.cpu} in
        uobj#initialize target_def;

      Uberspark.Logger.log "proceeding to compile c files...";
      if not (uobj#compile_c_files ()) then
        begin
          Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "could not compile one or more uobj c files!";
          ignore (exit 1);
        end
      ;
      Uberspark.Logger.log "compiled c files successfully!";

      `Ok ()
    end
  ;

;;


(* main handler for uobj command *)
let handler_uobj 
  (copts : Commonopts.opts)
  (cmd_uobj_opts: opts)
  (action : [> `Build ] as 'a)
  (path_ns : string)
  : [> `Error of bool * string | `Ok of unit ] = 

  let retval : [> `Error of bool * string | `Ok of unit ] ref = ref (`Ok ()) in

  (* perform common initialization *)
  Commoninit.initialize copts;

  match action with
    | `Build -> 
      retval := handler_uobj_build cmd_uobj_opts path_ns;
  ;

(*  (* initialize bridges *)
  if (Commoninit.initialize_bridges) then 
    begin
  
    end
  else
    begin
      retval := `Error (false, "error in initializing bridges. check your bridge definitions");
    end
  ;
*)
  (!retval)
;;