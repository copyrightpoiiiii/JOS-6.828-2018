#include "ns.h"

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
	binaryname = "ns_output";

	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver

	uint32_t id,r;
	int perm;
	while(1){
		r = ipc_recv((envid_t *)&id,&nsipcbuf,&perm);
		if(r != NSREQ_OUTPUT) continue;
		while(sys_pkt_try_send((void *)nsipcbuf.pkt.jp_data,(size_t)nsipcbuf.pkt.jp_len)<0)
			sys_yield();
	}

}
