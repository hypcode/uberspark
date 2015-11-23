/*
 * @XMHF_LICENSE_HEADER_START@
 *
 * eXtensible, Modular Hypervisor Framework (XMHF)
 * Copyright (c) 2009-2012 Carnegie Mellon University
 * Copyright (c) 2010-2012 VDG Inc.
 * All Rights Reserved.
 *
 * Developed by: XMHF Team
 *               Carnegie Mellon University / CyLab
 *               VDG Inc.
 *               http://xmhf.org
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in
 * the documentation and/or other materials provided with the
 * distribution.
 *
 * Neither the names of Carnegie Mellon or VDG Inc, nor the names of
 * its contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
 * THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * @XMHF_LICENSE_HEADER_END@
 */

/*
 * xcnwlog verification driver
 * author: amit vasudevan (amitvasudevan@acm.org)
*/


#include <xmhf.h>
#include <xmhf-hwm.h>
#include <xmhfgeec.h>

#include <xc_nwlog.h>

u32 cpuid = 0;	//BSP cpu

//////
// frama-c non-determinism functions
//////

u32 Frama_C_entropy_source;

//@ assigns Frama_C_entropy_source \from Frama_C_entropy_source;
void Frama_C_update_entropy(void);

u32 framac_nondetu32(void){
  Frama_C_update_entropy();
  return (u32)Frama_C_entropy_source;
}

u32 framac_nondetu32interval(u32 min, u32 max)
{
  u32 r,aux;
  Frama_C_update_entropy();
  aux = Frama_C_entropy_source;
  if ((aux>=min) && (aux <=max))
    r = aux;
  else
    r = min;
  return r;
}


//////
u32 check_esp, check_eip = CASM_RET_EIP;
slab_params_t test_sp;
typedef enum {
	XCNWLOG_VERIF_INIT,
	XCNWLOG_VERIF_LOGDATA
} xcnwlog_verif_t;

xcnwlog_verif_t xcnwlog_verif = XCNWLOG_VERIF_INIT;
bool xcnwlog_logdata_startedxmit = false;


void cbhwm_e1000_write_tdt(u32 origval, u32 newval){
	switch(xcnwlog_verif){
		case XCNWLOG_VERIF_INIT:
			//@assert 1;
			break;

		case XCNWLOG_VERIF_LOGDATA:{
			if(xmhfhwm_e1000_tctl & E1000_TCTL_EN){
				//@assert newval == 0;
				//@assert xmhfhwm_e1000_tdbah == 0;
				//@assert xmhfhwm_e1000_tdbal == (u32)&xcnwlog_lsdma;
				//@assert xmhfhwm_e1000_status_transmitting == false;
				xcnwlog_logdata_startedxmit = true;
			}
			break;
		}

		default:
			//@assert 0;
			break;
	}
}

void cbhwm_e1000_write_tdbah(u32 origval, u32 newval){

	switch(xcnwlog_verif){
		case XCNWLOG_VERIF_INIT:
			//@assert 1;
			break;

		case XCNWLOG_VERIF_LOGDATA:{
			//@assert 0;
			break;
		}

		default:
			//@assert 0;
			break;
	}


}

void cbhwm_e1000_write_tdbal(u32 origval, u32 newval){

	switch(xcnwlog_verif){
		case XCNWLOG_VERIF_INIT:
			//@assert 1;
			break;

		case XCNWLOG_VERIF_LOGDATA:{
			//@assert 0;
			break;
		}

		default:
			//@assert 0;
			break;
	}

}


void cbhwm_e1000_write_tdlen(u32 origval, u32 newval){

	switch(xcnwlog_verif){
		case XCNWLOG_VERIF_INIT:
			//@assert 1;
			break;

		case XCNWLOG_VERIF_LOGDATA:{
			//@assert 0;
			break;
		}

		default:
			//@assert 0;
			break;
	}


}




void main(void){
	//populate hardware model stack and program counter
	xmhfhwm_cpu_gprs_esp = _slab_tos[cpuid];
	xmhfhwm_cpu_gprs_eip = check_eip;
	check_esp = xmhfhwm_cpu_gprs_esp; // pointing to top-of-stack

	test_sp.src_slabid = framac_nondetu32interval(0, XMHFGEEC_TOTAL_SLABS-1);
	test_sp.in_out_params[0] =  framac_nondetu32(); 	test_sp.in_out_params[1] = framac_nondetu32();
	test_sp.in_out_params[2] = framac_nondetu32(); 	test_sp.in_out_params[3] = framac_nondetu32();
	test_sp.in_out_params[4] = framac_nondetu32(); 	test_sp.in_out_params[5] = framac_nondetu32();
	test_sp.in_out_params[6] = framac_nondetu32(); 	test_sp.in_out_params[7] = framac_nondetu32();
	test_sp.in_out_params[8] = framac_nondetu32(); 	test_sp.in_out_params[9] = framac_nondetu32();
	test_sp.in_out_params[10] = framac_nondetu32(); 	test_sp.in_out_params[11] = framac_nondetu32();
	test_sp.in_out_params[12] = framac_nondetu32(); 	test_sp.in_out_params[13] = framac_nondetu32();
	test_sp.in_out_params[14] = framac_nondetu32(); 	test_sp.in_out_params[15] = framac_nondetu32();

	//execute harness
	xcnwlog_verif = XCNWLOG_VERIF_INIT;
	e1000_init_module();
	//@assert (e1000_adapt.hw.hw_addr == (uint8_t *)E1000_HWADDR_BASE);
	//@assert (e1000_adapt.tx_ring.tdt == (uint16_t)(E1000_TDT));
	//@assert (e1000_adapt.tx_ring.tdh == (uint16_t)(E1000_TDH));
        //@assert xmhfhwm_e1000_tdbah == 0;
	//@assert xmhfhwm_e1000_tdbal == (u32)&xcnwlog_lsdma;
	//@assert xmhfhwm_e1000_tdlen == (E1000_DESC_COUNT * sizeof(struct e1000_tx_desc));



	//@assert xmhfhwm_e1000_status_transmitting == false;
	xcnwlog_verif = XCNWLOG_VERIF_LOGDATA;
	e1000_xmitack();
	//@assert xcnwlog_logdata_startedxmit == true && xmhfhwm_e1000_status_transmitting == false;



	//@assert xmhfhwm_cpu_gprs_esp == check_esp;
	//@assert xmhfhwm_cpu_gprs_eip == check_eip;
}

