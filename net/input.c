#include "ns.h"
#include <kern/e1000.h>

extern union Nsipc nsipcbuf;

void sleep(int msec){
	int now = sys_time_msec();
	int fin = now + msec;
	if(now < 0 && now > -MAXERROR)
		panic("sleep error\n");
	if(fin < now)
		panic("sleep input error\n");
	while(sys_time_msec() < fin)
		sys_yield();
}

void
input(envid_t ns_envid)
{
	binaryname = "ns_input";

	// LAB 6: Your code here:
	// 	- read a packet from the device driver
	//	- send it to the network server
	// Hint: When you IPC a page to the network server, it will be
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.

	size_t len;
	char buf[RX_PACKET_SIZE];
	while(1){
		while(sys_pkt_try_recv((void *)buf,&len)<0)
			sys_yield();
		memcpy(nsipcbuf.pkt.jp_data,buf,len);
		nsipcbuf.pkt.jp_len = len;
		ipc_send(ns_envid,NSREQ_INPUT,&nsipcbuf,PTE_P|PTE_U);
		sleep(50);
	}

}
