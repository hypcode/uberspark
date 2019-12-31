(****************************************************************************)
(****************************************************************************)
(* uberSpark codegen interface for uobj collection *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(****************************************************************************)
(****************************************************************************)


(****************************************************************************)
(* types *)
(****************************************************************************)
type sentinel_info_t =
{
	mutable f_code			: string;
	mutable f_libcode  	: string;	
	mutable f_sizeof_code : int;	
	mutable f_addr : int;
    mutable f_pm_addr : int;
    mutable f_name : string;
    mutable f_secname : string;
	mutable f_type : string; 	
};;





(****************************************************************************)
(* interfaces *)
(****************************************************************************)


(*--------------------------------------------------------------------------*)
(* generate sentinel code *)
(*--------------------------------------------------------------------------*)
let generate_sentinel_code	
    (output_filename : string)
    ?(output_banner = "uobjcoll/uobj sentinel code")
	(pm_sentinel_list : sentinel_info_t list)
    : bool	= 

    let retval = ref false in
    
    Uberspark_logger.log ~lvl:Uberspark_logger.Debug "%s: length of pm_sentinel_list=%u" 
        __LOC__ (List.length pm_sentinel_list);
    let oc = open_out output_filename in
        Printf.fprintf oc "\n/* --- this file is autogenerated --- */";
        Printf.fprintf oc "\n/* %s */" output_banner;
        Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n/* --- sentinel code follows --- */";
        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n";

        List.iter (fun (sinfo_entry : sentinel_info_t)  ->

            Printf.fprintf oc "\n";
            Printf.fprintf oc "\n";
            Printf.fprintf oc "\n.section %s" sinfo_entry.f_secname;
            Printf.fprintf oc "\n.global %s" sinfo_entry.f_name;
            Printf.fprintf oc "\n%s:" sinfo_entry.f_name;
            let tcode = Str.global_replace (Str.regexp "PUBLICMETHOD_ADDR") (string_of_int sinfo_entry.f_pm_addr) sinfo_entry.f_code in
            Printf.fprintf oc "\n%s" tcode;
            Printf.fprintf oc "\n";
            Printf.fprintf oc "\n";

        ) pm_sentinel_list;

    close_out oc;	

    retval := true;
    (!retval)
;;




(*--------------------------------------------------------------------------*)
(* generate sentinel (legacy) library code *)
(*--------------------------------------------------------------------------*)
let generate_sentinel_libcode	
    (output_filename : string)
    ?(output_banner = "uobjcoll/uobj legacy code public methods interface library")
	(canonical_publicmethods_sentinels_hashtbl : ((string, int)  Hashtbl.t) )
    (sentinel_libcode : string)
    (sentinel_libcode_section_name : string)
    : bool	= 

    let retval = ref false in
    
    Uberspark_logger.log ~lvl:Uberspark_logger.Debug "%s: length of canonical_publicmethods_sentinels_hashtbl=%u" 
        __LOC__ (Hashtbl.length canonical_publicmethods_sentinels_hashtbl);
    let oc = open_out output_filename in
        Printf.fprintf oc "\n/* --- this file is autogenerated --- */";
        Printf.fprintf oc "\n/* %s */" output_banner;
        Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n/* --- uobjcoll/uobj legacy code public methods interface code follows --- */";
        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n";

        Hashtbl.iter (fun canonical_pm_name pm_addr  ->

            Printf.fprintf oc "\n";
            Printf.fprintf oc "\n";
            Printf.fprintf oc "\n.section %s" sentinel_libcode_section_name;
            Printf.fprintf oc "\n.global %s" canonical_pm_name;
            Printf.fprintf oc "\n%s:" canonical_pm_name;
            let tcode = Str.global_replace (Str.regexp "PUBLICMETHOD_SENTINEL_ADDR") (string_of_int pm_addr) sentinel_libcode in
            Printf.fprintf oc "\n%s" tcode;
            Printf.fprintf oc "\n";
            Printf.fprintf oc "\n";

        ) canonical_publicmethods_sentinels_hashtbl;

    close_out oc;	

    retval := true;
    (!retval)
;;





(*--------------------------------------------------------------------------*)
(* generate uobj binary image section mapping *)
(*--------------------------------------------------------------------------*)
let generate_uobj_binary_image_section_mapping	
    (output_filename : string)
    ?(output_banner = "uobj collection uobj binary image section mapping source")
	(uobjcoll_uobjinfo_list : Defs.Basedefs.uobjinfo_t list)
    : bool	= 
        let retval = ref false in
        
        Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjcoll_uobjinfo_list length=%u" (List.length uobjcoll_uobjinfo_list);
        let oc = open_out output_filename in
            Printf.fprintf oc "\n/* --- this file is autogenerated --- */";
            Printf.fprintf oc "\n/* %s */" output_banner;
            Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
            Printf.fprintf oc "\n";
            Printf.fprintf oc "\n";
            Printf.fprintf oc "\n/* --- uobj binary image section definitions follow --- */";
            Printf.fprintf oc "\n";
            
            List.iter ( fun (uobjinfo_entry : Defs.Basedefs.uobjinfo_t) ->
                Printf.fprintf oc "\n";
                Printf.fprintf oc "\n.section .uobj_%s" uobjinfo_entry.f_uobj_name;
                Printf.fprintf oc "\n.incbin \"%s\"" ("./" ^ uobjinfo_entry.f_uobj_name ^ "/" ^ Uberspark_namespace.namespace_uobj_build_dir ^ "/uobj.bin");
                Printf.fprintf oc "\n";
            ) uobjcoll_uobjinfo_list;

            Printf.fprintf oc "\n";
            Printf.fprintf oc "\n/* --- end of uobj binary image section definitions --- */";
            Printf.fprintf oc "\n";

        close_out oc;	

        retval := true;
        (!retval)
;;




(*--------------------------------------------------------------------------*)
(* generate uobjcoll linker script *)
(*--------------------------------------------------------------------------*)
let generate_linker_script	
    (output_filename : string)
    ?(output_banner = "uobj collection linker script")
	(uobjcoll_uobjinfo_list : Defs.Basedefs.uobjinfo_t list)
    (uobjcoll_load_addr : int)
    (uobjcoll_size : int)
    : bool	= 
        let retval = ref false in
        
        Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjcoll_uobjinfo_list length=%u" (List.length uobjcoll_uobjinfo_list);

    let oc = open_out output_filename in
        Printf.fprintf oc "\n/* autogenerated %s */" output_banner;
        Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n";

        Printf.fprintf oc "\nMEMORY";
        Printf.fprintf oc "\n{";
        Printf.fprintf oc "\n %s (%s) : ORIGIN = 0x%08x, LENGTH = 0x%08x"
            ("mem_uobjcoll")
            ( "rw" ^ "ail") (uobjcoll_load_addr) (uobjcoll_size);
        Printf.fprintf oc "\n}";
        Printf.fprintf oc "\n";
    
            
        Printf.fprintf oc "\nSECTIONS";
        Printf.fprintf oc "\n{";
        Printf.fprintf oc "\n";

        List.iter ( fun (uobjinfo_entry : Defs.Basedefs.uobjinfo_t) ->

            Printf.fprintf oc "\n %s : {" (".uobj_" ^ uobjinfo_entry.f_uobj_name);
                        Printf.fprintf oc "\n *(%s)" (".uobj_" ^ uobjinfo_entry.f_uobj_name);
            Printf.fprintf oc "\n	} >%s =0x9090" ("mem_uobjcoll");
            Printf.fprintf oc "\n";

        ) uobjcoll_uobjinfo_list;

        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n	/* this is to cause the link to fail if there is";
        Printf.fprintf oc "\n	* anything we didn't explicitly place.";
        Printf.fprintf oc "\n	* when this does cause link to fail, temporarily comment";
        Printf.fprintf oc "\n	* this part out to see what sections end up in the output";
        Printf.fprintf oc "\n	* which are not handled above, and handle them.";
        Printf.fprintf oc "\n	*/";
        Printf.fprintf oc "\n	/DISCARD/ : {";
        Printf.fprintf oc "\n	*(*)";
        Printf.fprintf oc "\n	}";
        Printf.fprintf oc "\n}";
        Printf.fprintf oc "\n";
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
        close_out oc;

        retval := true;
        (!retval)
;;
