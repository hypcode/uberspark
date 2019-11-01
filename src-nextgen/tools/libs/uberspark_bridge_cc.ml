(****************************************************************************)
(****************************************************************************)
(* uberSpark bridge module interface implementation -- cc bridge submodule *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(****************************************************************************)
(****************************************************************************)

open Unix
open Yojson

(****************************************************************************)
(* cc-bridge data variables *)
(****************************************************************************)

(* bridge-cc uberspark header node variable *)	
let uberspark_hdr: Uberspark_manifest.hdr_t = {
	f_coss_version = "any";
	f_mftype = "bridge";
	f_uberspark_min_version = "any";
	f_uberspark_max_version = "any";
};;

(* bridge-cc node variable *)	
let bridge_cc : Uberspark_manifest.Bridge.bridge_cc_t = {
	bridge_hdr = { btype = "";
				execname = "";
				path = "";
				devenv = "";
				arch = "";
				cpu = "";
				version = "";
				params = [];
				container_fname = "";
				namespace = "";
	};
	params_prefix_to_obj = "";
	params_prefix_to_asm = "";
	params_prefix_to_output = "";
};;


(****************************************************************************)
(* cc-bridge interfaces *)
(****************************************************************************)


let load_from_json
	(json_node : Yojson.Basic.json)
	: bool =

	let retval = ref false in

	let rval_uberspark_hdr = Uberspark_manifest.parse_uberspark_hdr json_node uberspark_hdr in
	(*let rval_bridge_hdr = Uberspark_manifest.Bridge.parse_bridge_hdr json_node bridge_cc.bridge_hdr in*)
	let rval_bridge_cc = Uberspark_manifest.Bridge.parse_bridge_cc json_node bridge_cc in

	if rval_bridge_cc && rval_uberspark_hdr then
		begin
			(* TBD: sanity check input mftype and override with bridge only if permissible *)
			(* e.g., if existing mftype is top-level *)
			uberspark_hdr.f_mftype <- "bridge";
			retval := true;
		end
	else
		begin
			retval := false;
		end
	;

	(!retval)
;;


let load_from_file 
	(json_file : string)
	: bool =
	let retval = ref false in
	Uberspark_logger.log "loading cc-bridge settings from file: %s" json_file;


	let (rval, bridge_cc_json) = Uberspark_manifest.get_manifest_json json_file in
	if rval then
		begin
			retval := load_from_json bridge_cc_json;
		end
	else
		begin
			retval := false;
		end
	;

	(!retval)
;;


let load 
	(bridge_ns : string)
	: bool =
	let bridge_ns_json_path = Uberspark_config.namespace_root ^ 
		Uberspark_config.namespace_bridge_cc_bridge ^ "/" ^ bridge_ns ^ "/" ^
		Uberspark_config.namespace_bridge_mf_filename in
		(load_from_file bridge_ns_json_path)
;;


let store_to_file 
	(json_file : string)
	: bool =
	let retval = ref false in
	Uberspark_logger.log "storing cc-bridge settings to file: %s" json_file;

	let oc = open_out json_file in

		Uberspark_manifest.write_prologue ~prologue_str:"uberSpark cc-bridge manifest" oc;
		Uberspark_manifest.write_uberspark_hdr oc uberspark_hdr;
		(*Uberspark_manifest.Bridge.write_bridge_hdr oc bridge_cc.bridge_hdr;*)
		Uberspark_manifest.Bridge.write_bridge_cc ~continuation:false oc bridge_cc;
		Uberspark_manifest.write_epilogue oc;

	close_out oc;	

	retval := true;
	(!retval)
;;


let store 
	()
	: bool =
	let retval = ref false in 
    let bridge_ns = bridge_cc.bridge_hdr.btype ^ "/" ^
		bridge_cc.bridge_hdr.devenv ^ "/" ^
		bridge_cc.bridge_hdr.arch ^ "/" ^
		bridge_cc.bridge_hdr.cpu ^ "/" ^
		bridge_cc.bridge_hdr.execname ^ "/" ^
		bridge_cc.bridge_hdr.version in
	let bridge_ns_json_path = Uberspark_config.namespace_root ^ 
		Uberspark_config.namespace_bridge_cc_bridge ^ "/" ^ bridge_ns in
	let bridge_ns_json_filename = bridge_ns_json_path ^ "/" ^
		Uberspark_config.namespace_bridge_mf_filename in

	(* make the namespace directory *)
	Uberspark_osservices.mkdir ~parent:true bridge_ns_json_path (`Octal 0o0777);

	retval := store_to_file bridge_ns_json_filename;

	(* check if bridge type is container, if so store dockerfile *)
	if !retval && bridge_cc.bridge_hdr.btype = "container" then
		begin
			let input_bridge_dockerfile = bridge_cc.bridge_hdr.container_fname in 
			let output_bridge_dockerfile = bridge_ns_json_path ^ "/uberspark-bridge.Dockerfile" in 
				Uberspark_osservices.file_copy input_bridge_dockerfile output_bridge_dockerfile;
		end
	;

	(!retval)
;;


let build 
	()
	: bool =

	let retval = ref false in

	if bridge_cc.bridge_hdr.btype = "container" then
		begin
			let bridge_ns = Uberspark_config.namespace_bridge_cc_bridge ^ "/" ^
				bridge_cc.bridge_hdr.btype ^ "/" ^
				bridge_cc.bridge_hdr.devenv ^ "/" ^
				bridge_cc.bridge_hdr.arch ^ "/" ^
				bridge_cc.bridge_hdr.cpu ^ "/" ^
				bridge_cc.bridge_hdr.execname ^ "/" ^
				bridge_cc.bridge_hdr.version in
			let bridge_container_path = Uberspark_config.namespace_root ^ bridge_ns in

			Uberspark_logger.log "building cc-bridge: %s" bridge_ns;

			if (Container.build_image bridge_container_path bridge_ns) == 0 then begin	
				Uberspark_logger.log "cc-bridge build success!"; 
				retval := true;
			end else begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not build cc-bridge!"; 
				retval := false;
			end
			;
										
		end
	else
		begin
			Uberspark_logger.log ~lvl:Uberspark_logger.Warn "ignoring build command for 'native' bridge";
			retval := true;
		end
	;

	(!retval)
;;


let invoke 
	?(gen_obj = false)
	?(gen_asm = false)
	(c_file_list : string list)
	: bool =

	let retval = ref false in

	if gen_obj then begin
		
		if bridge_cc.bridge_hdr.btype = "container" then begin
			Uberspark_logger.log ~lvl:Uberspark_logger.Warn "cc-bridge container invocation. TBD!";
			retval := true;
		end else begin
			Uberspark_logger.log ~lvl:Uberspark_logger.Warn "cc-bridge native invocation. TBD!";
			retval := true;
		end;

	end else begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "no op specified for cc-bridge invoke!";
		retval := false;
	end;


	(!retval)
;;
